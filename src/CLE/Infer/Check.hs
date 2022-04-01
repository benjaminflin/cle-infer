{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TupleSections #-}
module CLE.Infer.Check where


import Data.Map (Map)
import CLE.Infer.Constraint hiding (lookupLabel)
import CLE.LLVM.Wrapper
import CLE.JSON.Model
import CLE.Infer.Monad
import Control.Monad (zipWithM_, foldM)
import qualified LLVM.AST as LL
import qualified Data.Map as M
import CLE.Infer.Utils
import Control.Monad.Trans.RWS
import Debug.Trace


checkInstr ::
    LL.Name
    -> Maybe [Label]
    -> Map QName Ty
    -> Instruction (LL & Raise (Maybe Label))
    -> Check (Map QName Ty)
checkInstr fnName mcod ctx
    (Instruction (WrapInstruction nInstr :& Raise mlbl)) = do
        labelTy <- toType mlbl
        tysMentioned <- mapM (`lookupName` ctx) (fromLLName fnName <$> filterNames (namesFrom instr))
        case instr of
            LL.Call {LL.function, LL.arguments} -> do
                let calleeName = head $ namesFrom function
                if notIntrinsicName calleeName then do
                    let argNames = fmap (fromLLName fnName) . namesFrom . fst <$> arguments
                    calleeTy <- lookupName (GlobalName calleeName) ctx
                    argTys <- mapM (mapM (`lookupName` ctx)) argNames
                    let zipped = concat $ zipWith (\(qname, tys) i -> (,i) <$> zip qname tys) (zip argNames argTys) [0..]
                    mapM_ (\x -> emitConstraint $ ArgOf x (GlobalName calleeName, calleeTy)) zipped 
                    emitConstraint $ RetOf (qName, labelTy) (GlobalName calleeName, calleeTy) 
                else
                    pure ()
            _ -> emitConstraints labelTy tysMentioned
        pure $ mkCtx labelTy
        where
            mkCtx labelTy =
                case nInstr of
                    LL.Do instr -> ctx
                    n LL.:= instr -> M.singleton qName labelTy <> ctx


            qNameFromInstr (LL.Do instr) = GlobalName fnName
            qNameFromInstr (n LL.:= instr) = LocalName fnName n

            unwrapNInstr (LL.Do instr) = instr
            unwrapNInstr (n LL.:= instr) = instr

            instr = unwrapNInstr nInstr
            qName = qNameFromInstr nInstr
            emitConstraints labelTy tysMentioned = case mcod of
                Just lbls -> do
                    let codNamedTys = (GlobalName fnName,) . Labelled <$> lbls
                    mapM_ (\l -> emitConstraint $
                        OneOf (qName, l) codNamedTys) (labelTy : tysMentioned)
                Nothing -> zipWithM_ (\x y ->
                    emitConstraint $ Eq (qName, x) (qName, y)) (labelTy : tysMentioned) tysMentioned


checkTerm ::
    LL.Name
    -> Maybe [Label]
    -> Map QName Ty
    -> Terminator (LL & Raise (Maybe Label))
    -> Check (Map QName Ty)
checkTerm fnName mret ctx
    (Terminator (WrapTerminator (LL.Do (LL.Ret (Just op) _)) :& Raise mlbl)) = do
        let n = fromLLName fnName <$> namesFrom op
        case n of
            [] -> pure ctx
            (n : _) -> do
                ty <- lookupName n ctx
                emitRetConstraint n ty
                emitRetConstraint' n ty
                pure ctx
    where
        emitRetConstraint n ty = case mret of
            Just ret -> emitConstraint $ OneOf (n, ty) $ (GlobalName fnName,) . Labelled <$> ret
            Nothing -> pure ()
        emitRetConstraint' n ty = case mlbl of
            Just lbl -> emitConstraint $ Eq (n, ty) (GlobalName fnName, Labelled lbl)
            Nothing -> pure ()
checkTerm fnName mret ctx _ = pure ctx




checkBasicBlock ::
    LL.Name
    -> Maybe ([Label], [Label])
    -> Map QName Ty
    -> BasicBlock (LL & Raise (Maybe Label))
    -> Check (Map QName Ty)
checkBasicBlock fnName (Just (cod, ret)) ctx (BasicBlock _ instrs term _) = do
    ctx' <- foldM (checkInstr fnName (Just cod)) ctx instrs
    checkTerm fnName Nothing ctx' term
checkBasicBlock fnName Nothing ctx (BasicBlock _ instrs term _) = do
    ctx' <- foldM (checkInstr fnName Nothing) ctx instrs
    checkTerm fnName Nothing ctx' term


checkTopLevelEntity ::
    Map QName Ty
    -> TopLevelEntity (LL & Raise (Maybe Label))
    -> Check (Map QName Ty)
checkTopLevelEntity ctx
    (Left (Function bbs (WrapFunction FunctionInfo {name} :& Raise (Just lbl)))) = do
        (level, args, cod, ret, cdf) <- unwrapFunDef =<< lookupLabel lbl
        argTys <- mapM (const fresh) args
        let argMap = M.fromList $ zipWith (toUnnamed name) argTys [0..]
        zipWithM_ emitArgConstraint argTys (zip args [0..])
        (M.singleton (GlobalName name) (Labelled lbl) <>) <$> foldM (checkBasicBlock name $ Just (cod, ret)) (argMap <> ctx) bbs
    where

        unwrapFunDef (FunDefinition level cdfs args cod ret) = pure (level, cdfs, args, cod, ret)
        unwrapFunDef NodeDefinition {} = throw $ NotFunctionAnnotation lbl

        emitArgConstraint argTy (arg, idx) =
            emitConstraint $ OneOf (LocalName name (LL.UnName idx), argTy) $ (GlobalName name,) . Labelled <$> arg
checkTopLevelEntity ctx
    (Left (Function bbs (WrapFunction FunctionInfo {name, parameters = (args, _)} :& Raise Nothing))) = do
        argTys <- mapM (const fresh) args
        emitArgConstraints (zip argTys [0..])
        let argMap = M.fromList $ zipWith (toUnnamed name) argTys [0..]
        ctx' <- foldM (checkBasicBlock name Nothing) (argMap <> ctx) bbs
        ty <- fresh
        let instrs = M.filterWithKey (\k a -> hasGlobalName k) ctx'
        mapM_ (emitConstraint . Eq (GlobalName name, ty)) (M.toList instrs)
        pure (M.singleton (GlobalName name) ty <> ctx')
        where
            emitArgConstraints (x : xs) = zipWithM_ emitArgConstraint (x : xs) xs
            emitArgConstraints [] = pure ()

            emitArgConstraint argTyI argTyI' =
                emitConstraint $ Eq (mkNamedTy argTyI) (mkNamedTy argTyI')

            mkNamedTy (argTy, idx) = (LocalName name (LL.UnName idx), argTy)

            hasGlobalName (GlobalName n) = n == name 
            hasGlobalName (LocalName n m) = n == name
checkTopLevelEntity ctx
    (Right (GlobalVariable (WrapGlobalVariable (GlobalInfo name _ _) :& Raise mlbl))) =
        (<> ctx) . M.singleton (GlobalName name) <$> toType mlbl

checkAllTopLevelEntities :: [TopLevelEntity (LL & Raise (Maybe Label))] -> Check (Map QName Ty)
checkAllTopLevelEntities = foldM checkTopLevelEntity M.empty

runCheck :: Check a -> CLEMap -> Either CheckErr (a, Int, [Constraint])
runCheck ch clemap = runRWST ch clemap 0