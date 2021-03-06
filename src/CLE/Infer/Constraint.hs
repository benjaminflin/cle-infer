{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE TupleSections #-}
module CLE.Infer.Constraint where

import CLE.JSON.Model (Label(Label), CLEMap (CLEMap), Definition (NodeDefinition, FunDefinition, argtaints, rettaints))
import qualified LLVM.AST as LL
import Data.ByteString.Char8 (unpack)
import Data.ByteString.Short (fromShort)
import qualified Data.Map as M
import Data.Maybe (mapMaybe)
import Debug.Trace (traceShowM)

data QName
    = LocalName {
        functionName :: LL.Name,
        instructionName :: LL.Name
    }
    | GlobalName {
        globalName :: LL.Name,
        isFunc :: Bool
    }
    deriving (Eq, Ord)

showLLName :: LL.Name -> String
showLLName (LL.Name s) = "@" ++ unpack (fromShort s)
showLLName (LL.UnName s) = "%" ++ show s 

type NamedTy = (QName, Ty)  

instance Show QName where
    show (LocalName f i) = showLLName f ++ "." ++ showLLName i
    show (GlobalName g _) = showLLName g

data Ty
    = Labelled Label
    | UniVar Int
    deriving (Show, Eq)

data Constraint
    = OneOf NamedTy [NamedTy]
    | ArgOf (NamedTy, Int) NamedTy
    | RetOf NamedTy NamedTy
    | Eq NamedTy NamedTy
    deriving (Show, Eq)

type Subst = (NamedTy, NamedTy)
type NamedLabel = (QName, Label)
data ConstraintErr 
    = LabelMismatch NamedLabel NamedLabel 
    | NotOneOf NamedTy [NamedTy] 
    | LookupError Label 
    deriving Show

lookupLabel :: CLEMap -> Label -> Either ConstraintErr Definition
lookupLabel (CLEMap m) lbl = 
    case M.lookup lbl m of
        Just def -> pure def
        Nothing -> Left $ LookupError lbl 

substs :: CLEMap -> Constraint -> Either ConstraintErr [Subst]
substs map (Eq (n, Labelled x) (m, Labelled y))
    | x == y = pure []
    | otherwise = Left $ LabelMismatch (n, x) (m, y)
substs map (Eq a@(_, Labelled _) b) = pure [(a, b)]
substs map (Eq b a@(_, Labelled _)) = pure [(a, b)]
substs map (OneOf x [y]) = substs map (Eq x y)
substs map (OneOf x@(_, l@(Labelled _)) (y : ys)) = do
    if l `elem` fmap snd (y : ys) then pure [] else 
        Left $ NotOneOf x (y : ys)  
-- substs map (OneOf x@(_, UniVar _) (y : _)) = substs map (Eq x y)
substs map (ArgOf (a@(n, Labelled l), i) b@(m, UniVar _)) = do
    substs map $ Eq a b
substs map (ArgOf (t@(_, UniVar _), i) b@(n, Labelled l)) = do
    def <- lookupLabel map l 
    case def of 
        NodeDefinition {} -> substs map $ Eq t b
        FunDefinition {argtaints} -> substs map $ OneOf t ((n,) . Labelled <$> argtaints !! i)
substs map (RetOf t@(_, UniVar _) b@(n, Labelled l)) = do
    def <- lookupLabel map l 
    case def of 
        NodeDefinition {} -> substs map $ Eq t b
        FunDefinition {rettaints} -> 
            substs map $ OneOf t ((n,) . Labelled <$> rettaints)
substs map (RetOf a@(n, Labelled l) b@(m, UniVar _)) = do
    substs map $ Eq a b
substs map _ = pure []

class Substitutable a where
    subst :: Subst -> a -> a

instance (Functor f, Substitutable a) => Substitutable (f a) where
    subst s = fmap (subst s)

instance Substitutable Ty where
    subst ((_, x), (_, y)) t
        | y == t = x
        | otherwise = t

instance Substitutable Constraint where
    subst s (Eq a b) = Eq (subst s a) (subst s b)
    subst s (OneOf x b) = OneOf (subst s x) (subst s b)
    subst s (RetOf x b) = RetOf (subst s x) (subst s b) 
    subst s (ArgOf x b) = ArgOf (subst' s x) (subst s b) 
        where
            subst' s (nameTy, a) = (subst s nameTy, a)

substMany :: Substitutable a => [Subst] -> a -> a
substMany ss x = foldl (flip subst) x ss

solve :: CLEMap -> [Constraint] -> Either ConstraintErr ([Constraint], [Subst])
solve map cs = do
    ss <- concat <$> mapM (substs map) cs
    let cs' = substMany ss cs  
    pure (cs', ss)

solveUntilConvergence :: CLEMap -> [Constraint] -> Either ConstraintErr ([Constraint], [Subst])
solveUntilConvergence map constrs = go constrs []
    where
    go constrs substs = do
        (constrs', substs') <- solve map constrs 
        if constrs' == constrs then
            pure (constrs', substs ++ substs')
        else 
            go constrs' (substs ++ substs')

inSubsts :: NamedTy -> [Subst] -> Bool  
inSubsts n = any compareNamedTy
    where
        compareNamedTy (a, b) = n == a || n == b

applyArbitrary :: CLEMap -> [Subst] -> Constraint -> Either ConstraintErr Constraint
applyArbitrary map substs c@(OneOf x@(n, UniVar _) (y : ys)) = 
    pure $ if x `inSubsts` substs then c else Eq x y
applyArbitrary map substs (RetOf t@(_, UniVar _) b@(n, Labelled l)) = do
    def <- lookupLabel map l 
    case def of 
        NodeDefinition {} -> applyArbitrary map substs $ Eq t b
        FunDefinition {rettaints} -> 
            applyArbitrary map substs $ OneOf t ((n,) . Labelled <$> rettaints)
applyArbitrary map substs (ArgOf (t@(_, UniVar _), i) b@(n, Labelled l)) = do
    def <- lookupLabel map l 
    case def of 
        NodeDefinition {} -> applyArbitrary map substs $ Eq t b
        FunDefinition {argtaints} -> applyArbitrary map substs $ OneOf t ((n,) . Labelled <$> argtaints !! i)
applyArbitrary _ _ x = pure x 

solveUntilAssignment :: CLEMap -> [Constraint] -> Either ConstraintErr ([Constraint], [Subst])
solveUntilAssignment map constrs = do
    (constrs, substs) <- solveUntilConvergence map constrs 
    constrs' <- mapM (applyArbitrary map substs) constrs
    (constrs, substs') <- solveUntilConvergence map constrs' -- 
    pure (constrs, substs ++ substs')
