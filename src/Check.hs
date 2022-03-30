{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE FlexibleInstances #-}
module Check where


import Wrapper
import Control.Monad.Trans.RWS
import CLE
import qualified LLVM.AST as LL
import Control.Monad.Trans.Class (lift)
import Data.Map (Map)
import LLVM.AST.Global (name, parameters)
import qualified Data.Map as M
import Data.List (find)
import Control.Monad (zipWithM_, foldM)
import qualified LLVM.AST.Constant as LC
import Debug.Trace

data Name
    = LocalName {
        functionName :: LL.Name,
        instructionName :: LL.Name
    }
    | GlobalName LL.Name
    deriving (Eq, Ord)

showLLName :: LL.Name -> String
showLLName (LL.Name s) = "@" ++ show s
showLLName (LL.UnName s) = "%" ++ show s

instance Show Name where
    show (LocalName f i) = showLLName f ++ "." ++ showLLName i
    show (GlobalName g) = showLLName g

data CheckErr
    = NotFunctionAnnotation JSON
    | LabelLookupFailure String
    | LookupFailure Name
    | NoCdf String
    | NoTaints CDF
    | Other String
    deriving (Show)

data Ty
    = Label String
    | UniVar Int
    deriving (Show, Eq)

data Constraint
    = OneOf Ty [Ty]
    | Eq Ty Ty
    deriving (Show, Eq)

type Check = RWST CLEMap [Constraint] Int (Either CheckErr)

fresh :: Check Ty
fresh = do
    i <- get
    put (i + 1)
    pure $ UniVar i

maybeLabel :: Maybe String -> Check Ty
maybeLabel (Just x) = pure $ Label x
maybeLabel Nothing = fresh

class NamesFrom a where
    namesFrom :: a -> [LL.Name]

instance NamesFrom a => NamesFrom [a] where
    namesFrom = concatMap namesFrom

instance NamesFrom LC.Constant where
    namesFrom LC.Struct {LC.memberValues} = namesFrom memberValues
    namesFrom LC.Array {LC.memberValues} = namesFrom memberValues
    namesFrom LC.Vector {LC.memberValues} = namesFrom memberValues
    namesFrom (LC.GlobalReference _ name) = [name]
    namesFrom LC.Add {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.FAdd {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.Sub {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.FSub {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.Mul {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.FMul {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.FDiv {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.UDiv {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.URem {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.FRem {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.SRem {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.Shl {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.LShr {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.AShr {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.And {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.Or {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.Xor {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.GetElementPtr {LC.address, LC.indices} = namesFrom (address : indices)
    namesFrom LC.Trunc {LC.operand0} = namesFrom operand0
    namesFrom LC.ZExt {LC.operand0} = namesFrom operand0
    namesFrom LC.SExt {LC.operand0} = namesFrom operand0
    namesFrom LC.FPToUI {LC.operand0} = namesFrom operand0
    namesFrom LC.UIToFP {LC.operand0} = namesFrom operand0
    namesFrom LC.SIToFP {LC.operand0} = namesFrom operand0
    namesFrom LC.FPTrunc {LC.operand0} = namesFrom operand0
    namesFrom LC.FPExt {LC.operand0} = namesFrom operand0
    namesFrom LC.PtrToInt {LC.operand0} = namesFrom operand0
    namesFrom LC.IntToPtr {LC.operand0} = namesFrom operand0
    namesFrom LC.BitCast {LC.operand0} = namesFrom operand0
    namesFrom LC.AddrSpaceCast {LC.operand0} = namesFrom operand0
    namesFrom LC.ICmp {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.FCmp {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.ExtractElement {LC.vector, LC.index} = namesFrom [vector, index]
    namesFrom LC.InsertElement {LC.vector, LC.index, LC.element} = namesFrom [vector, index, element]
    namesFrom LC.ShuffleVector {LC.operand0, LC.operand1} = namesFrom [operand0, operand1]
    namesFrom LC.ExtractValue {LC.aggregate} = namesFrom aggregate
    namesFrom LC.InsertValue {LC.aggregate, LC.element} = namesFrom [aggregate, element]
    namesFrom _ = []

instance NamesFrom LL.Operand where
    namesFrom (LL.LocalReference _ name) = [name]
    namesFrom (LL.ConstantOperand c) = namesFrom c
    namesFrom _ = []

instance NamesFrom (Either a LL.Operand) where
    namesFrom (Left _) = []
    namesFrom (Right o) = namesFrom o

instance NamesFrom LL.Instruction where
    namesFrom LL.Add {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.FAdd {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.Sub {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.FSub {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.Mul {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.FMul {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.SDiv {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.UDiv {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.FDiv {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.URem {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.SRem {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.FRem {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.Shl {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.LShr {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.AShr {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.And {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.Or {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.Xor {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.Alloca {LL.numElements = Just op} = namesFrom op
    namesFrom LL.Alloca {} = []
    namesFrom LL.Load {LL.address} = namesFrom address
    namesFrom LL.Store {LL.address, LL.value} = namesFrom [address, value]
    namesFrom LL.GetElementPtr {LL.address, LL.indices} = namesFrom (address : indices)
    namesFrom LL.CmpXchg {LL.address, LL.expected, LL.replacement} = namesFrom [address, expected, replacement]
    namesFrom LL.AtomicRMW {LL.address, LL.value} = namesFrom [address, value]
    namesFrom LL.Trunc {LL.operand0} = namesFrom operand0
    namesFrom LL.ZExt {LL.operand0} = namesFrom operand0
    namesFrom LL.SExt {LL.operand0} = namesFrom operand0
    namesFrom LL.FPToUI {LL.operand0} = namesFrom operand0
    namesFrom LL.FPToSI {LL.operand0} = namesFrom operand0
    namesFrom LL.SIToFP {LL.operand0} = namesFrom operand0
    namesFrom LL.UIToFP {LL.operand0} = namesFrom operand0
    namesFrom LL.FPTrunc {LL.operand0} = namesFrom operand0
    namesFrom LL.FPExt {LL.operand0} = namesFrom operand0
    namesFrom LL.PtrToInt {LL.operand0} = namesFrom operand0
    namesFrom LL.IntToPtr {LL.operand0} = namesFrom operand0
    namesFrom LL.BitCast {LL.operand0} = namesFrom operand0
    namesFrom LL.AddrSpaceCast {LL.operand0} = namesFrom operand0
    namesFrom LL.ICmp {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.FCmp {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.Phi {LL.incomingValues} = namesFrom (fst <$> incomingValues)
    namesFrom LL.Call {LL.function, LL.arguments} = {- namesFrom function ++ -} namesFrom (fst <$> arguments)
    namesFrom LL.Select {LL.condition', LL.trueValue, LL.falseValue} = namesFrom [condition', trueValue, falseValue]
    namesFrom LL.VAArg {LL.argList} = namesFrom argList
    namesFrom LL.ExtractElement {LL.vector, LL.index} = namesFrom [vector, index]
    namesFrom LL.InsertElement {LL.vector, LL.index, LL.element} = namesFrom [vector, index, element]
    namesFrom LL.ShuffleVector {LL.operand0, LL.operand1} = namesFrom [operand0, operand1]
    namesFrom LL.ExtractValue {LL.aggregate} = namesFrom aggregate
    namesFrom LL.InsertValue {LL.aggregate, LL.element} = namesFrom [aggregate, element]
    namesFrom LL.CatchPad {LL.catchSwitch, LL.args} = namesFrom (catchSwitch : args)
    namesFrom LL.CleanupPad {LL.parentPad, LL.args} = namesFrom (parentPad : args)
    namesFrom _ = []

filterNames :: [LL.Name] -> [LL.Name]
filterNames = filter notIntrinsicName
    where
    notIntrinsicName n
        | n == LL.mkName "llvm.dbg.declare"
        || n == LL.mkName "printf"
        || n == LL.mkName "llvm.var.annotation" = False
        | otherwise = True

fromLLName :: LL.Name -> LL.Name -> Name
fromLLName funName (LL.Name s) = GlobalName (LL.Name s)
fromLLName funName n = LocalName funName n

checkInstr ::
    Map Name Ty
    -> LL.Name
    -> Maybe [String]
    -> Instruction (LL & Raise (Maybe String))
    -> Check (Map Name Ty)
checkInstr ctx funName mcod (Instruction (WrapInstruction nInstr :& Raise lbl)) = do
    let instr = extractInstr nInstr
    labelTy <- maybeLabel lbl
    tysMentioned <- mapM (`lookupName` ctx) (fromLLName funName <$> filterNames (namesFrom instr))
    case mcod of
        Just cod -> do
            mapM_ (\ty -> tell [OneOf ty (Label <$> cod)]) tysMentioned
            tell [OneOf labelTy (Label <$> cod)]
        Nothing -> do
            mapM_ (\ty -> tell [Eq labelTy ty]) tysMentioned
    pure (ctx' nInstr labelTy)
    where
        extractInstr (LL.Do instr) = instr
        extractInstr (n LL.:= instr) = instr

        ctx' (n LL.:= _) labelTy = M.singleton (LocalName funName n) labelTy <> ctx
        ctx' _ _ = ctx

checkTerm ::
    Map Name Ty
    -> Maybe ([String], [String])
    -> Terminator (LL & Raise (Maybe String))
    -> Check ()
checkTerm ctx mtaints term = pure ()

checkBB ::
    Map Name Ty
    -> LL.Name
    -> Maybe ([String], [String])
    -> BasicBlock (LL & Raise (Maybe String))
    -> Check (Map Name Ty)
checkBB ctx funName (Just (cod, ret)) (BasicBlock _ instrs term _) = do
    ctx' <- foldM (\ctx -> checkInstr ctx funName (Just cod)) ctx instrs
    checkTerm ctx' (Just (cod, ret)) term
    pure ctx'
checkBB ctx funName Nothing (BasicBlock _ instrs term _) = do
    ctx' <- foldM (\ctx -> checkInstr ctx funName Nothing) ctx instrs
    checkTerm ctx' Nothing term
    pure ctx'

throw :: CheckErr -> Check a
throw err = lift $ Left err

lookupName :: Name -> Map Name Ty -> Check Ty
lookupName name map =
    case M.lookup name map of
        Just ty -> pure ty
        Nothing -> throw $ LookupFailure name


lookupLabel :: String -> Check JSON
lookupLabel lbl = do
    mjson <- asks (M.lookup lbl)
    case mjson of
        Just json -> pure json
        Nothing -> throw $ LabelLookupFailure lbl

taintsFromSameLevel :: String -> Check Taints
taintsFromSameLevel lbl = do
    json <- lookupLabel lbl
    let l = level json
    let cdfs = cdf json
    case find ((== l) . remotelevel) cdfs of
        Just f ->
            case taints f of
                Just t -> pure t
                Nothing -> throw $ NoTaints f
        Nothing -> throw $ NoCdf l

checkBBs ::
    Map Name Ty
    -> LL.Name
    -> Maybe ([String], [String])
    -> [BasicBlock (LL & Raise (Maybe String))]
    -> Check (Map Name Ty)
checkBBs ctx name mtnts = foldM (\ctx -> checkBB ctx name mtnts) ctx

checkGlobal :: Map Name Ty -> Global (LL & Raise (Maybe String)) -> Check (Map Name Ty)
checkGlobal ctx (Global (WrapGlobal LL.GlobalVariable {name} :& Raise mlbl)) =
    (<> ctx) . M.singleton (GlobalName name) <$> maybeLabel mlbl
checkGlobal ctx (Global (WrapGlobal LL.GlobalAlias {name} :& Raise mlbl)) =
    (<> ctx) . M.singleton (GlobalName name) <$> maybeLabel mlbl

checkGlobal ctx (Function bbs (WrapGlobal LL.Function {name} :& Raise (Just lbl))) = do
    (Taints args cod ret) <- taintsFromSameLevel lbl
    argTys <- mapM (const fresh) args
    zipWithM_ genOneOf argTys args
    let argMap = M.fromList $ zipWith toUnnamed argTys [0..]
    ctx' <- checkBBs (argMap <> ctx) name (Just (cod, ret)) bbs
    pure $ M.singleton (GlobalName name) (Label lbl) <> ctx'
    where
        genOneOf ty lbls = tell [OneOf ty (Label <$> lbls)]
        toUnnamed ty i = (LocalName name (LL.UnName i), ty)
checkGlobal ctx (Function bbs (WrapGlobal LL.Function {name, parameters} :& Raise Nothing)) = do
    argTys <- mapM (const fresh) [0..length parameters]
    let argMap = M.fromList $ zipWith toUnnamed argTys [0..]
    ctx' <- checkBBs (argMap <> ctx) name Nothing bbs
    (<> ctx') . M.singleton (GlobalName name) <$> fresh
    where
    toUnnamed ty i = (LocalName name (LL.UnName i), ty)
checkGlobal _ _ = throw $ Other "impossible"

checkAll :: [Global (LL & Raise (Maybe String))] -> Check (Map Name Ty)
checkAll gs = go M.empty gs
    where
    go ctx [] = pure ctx
    go ctx (g : gs) = do
        ctx' <- checkGlobal ctx g
        go ctx' gs

runCheck :: Check a -> CLEMap -> Either CheckErr (a, Int, [Constraint])
runCheck ch clemap = runRWST ch clemap 0

data ConstraintErr = LabelMismatch String String deriving Show

type Subst = (Ty, Ty)
substs :: Constraint -> Either ConstraintErr [Subst]
substs (Eq (Label x) (Label y))
    | x == y = pure []
    | otherwise = Left (LabelMismatch x y)
substs (Eq (Label x) y) = pure [(Label x, y)]
substs (Eq y (Label x)) = pure [(Label x, y)]
substs (OneOf x [y]) = substs (Eq x y)
substs _ = pure []

class Substitutable a where
    subst :: Subst -> a -> a

instance Substitutable a => Substitutable [a] where
    subst s = fmap (subst s)

instance Substitutable a => Substitutable (Map k a) where
    subst s = fmap (subst s)

instance Substitutable Ty where
    subst (x, y) t 
        | y == t = x
        | otherwise = t 

instance Substitutable Constraint where
    subst s (Eq a b) = Eq (subst s a) (subst s b)
    subst s (OneOf x b) = OneOf (subst s x) (subst s b)

substMany :: Substitutable a => [Subst] -> a -> a
substMany ss x = foldl (flip subst) x ss

solve :: [Constraint] -> Either ConstraintErr ([Constraint], [Subst])
solve cs = do
    ss <- concat <$> mapM substs cs
    let cs' = substMany ss cs  
    pure (cs', ss)

solveUntilConvergence :: [Constraint] -> Either ConstraintErr ([Constraint], [Subst])
solveUntilConvergence constrs = go constrs []
    where
    go constrs substs = do
        (constrs', substs') <- solve constrs
        if constrs' == constrs then
            pure (constrs', substs' ++ substs)
        else 
            go constrs' (substs' ++ substs)