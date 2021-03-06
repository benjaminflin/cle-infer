{-# LANGUAGE TypeOperators, GADTs, NamedFieldPuns, TupleSections #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE DataKinds #-}
module CLE.LLVM.Annotater where

import CLE.LLVM.Wrapper hiding ( name, basicBlocks, parameters, returnType )
import Data.List
import Data.Maybe
import Data.Map (Map)
import qualified LLVM.AST as LL
import LLVM.AST.Global (name, initializer, basicBlocks, type', parameters, returnType)
import qualified LLVM.AST.Constant as LC
import LLVM.AST.Constant (memberValues, Constant (address))
import qualified Data.Map as M
import qualified Data.Map.Utils as M
import LLVM.AST (function, Instruction (arguments))
import CLE.JSON.Model
import Debug.Trace

annotate :: [LL.Definition] -> [TopLevelEntity (LL & Raise (Maybe Label))]
annotate defs = mapMaybe annotateOne defs ++ annotateGlobals globals
    where
        globals = mapMaybe toGlobal defs
        toGlobal (LL.GlobalDefinition global) = Just global 
        toGlobal _ = Nothing

        annotateOne (LL.TypeDefinition name ty) = Just $ Decl name ty
        annotateOne _ = Nothing

annotateGlobals :: [LL.Global] -> [TopLevelEntity (LL & Raise (Maybe Label))]
annotateGlobals globals = fmap toWrappedGlobal globals 
    where
        toWrappedGlobal LL.Function {name, basicBlocks, parameters, returnType} =
            FunDef $ Function (toWrappedBasicBlock <$> basicBlocks) (mkPair (WrapFunction $ FunctionInfo name basicBlocks parameters returnType) name)
        toWrappedGlobal LL.GlobalVariable {name, type', initializer} =
            GlobDef $ GlobalVariable (mkPair (WrapGlobalVariable $ GlobalInfo name type' initializer) name)
        toWrappedGlobal LL.GlobalAlias {name, type'} =
            GlobDef $ GlobalVariable (mkPair (WrapGlobalVariable $ GlobalInfo name type' Nothing) name)

        mkPair :: forall f (i :: LLIndex). f i -> LL.Name -> (f & Raise (Maybe Label)) i
        mkPair x n = x :& Raise (Label <$> (M.lookup n =<< globalAnnots))

        toWrappedBasicBlock b@(LL.BasicBlock name instrs term) =
            BasicBlock name (toWrappedInstr (localAnnotationMap (fmap toUnnamed instrs)) <$> instrs) (toWrappedTerm term) (mkBBPair b)

        toWrappedInstr annotMap i@(n LL.:= instr) = Instruction $ mkInstrPair i $ Label <$> M.lookup n annotMap
        toWrappedInstr annotMap i = Instruction $ mkInstrPair i Nothing

        localAnnotationMap = foldMap annotationFrom

        annotationFrom LL.Call {
                function = Right (LL.ConstantOperand (LC.GlobalReference _ name)),
                arguments = [(LL.LocalReference _ local, _), (LL.ConstantOperand LC.GetElementPtr {address = LC.GlobalReference _ global}, _), _, _]}
                | name == LL.mkName "llvm.var.annotation" =
                case M.lookup global labelMap of
                    Just lbl -> M.singleton local lbl
                    Nothing -> M.empty
        annotationFrom _ = M.empty
        toWrappedTerm t = Terminator (WrapTerminator t :& Raise Nothing)
        toUnnamed (_ LL.:= instr) = instr
        toUnnamed (LL.Do instr) = instr
        mkBBPair b = WrapBasicBlock b :& Raise Nothing
        mkInstrPair i a = WrapInstruction i :& Raise a
        globalAnnots = globalAnnotations globals
        labelMap = toLabelMap globals


globalAnnotations :: [LL.Global] -> Maybe (Map LL.Name String)
globalAnnotations globals = M.compose (toLabelMap globals) <$> globalMapOf globals

toLabelMap :: [LL.Global] -> Map LL.Name String
toLabelMap globals = M.fromList (mapMaybe toGlobalStrPair globals)

toGlobalStrPair :: LL.Global -> Maybe (LL.Name, String)
toGlobalStrPair LL.GlobalVariable {name, initializer = Just i} = (name,) <$> unwrapArr i
    where
    unwrapArr LC.Array {memberValues} = init <$> mapM unwrapInt memberValues
    unwrapArr _ = Nothing

    unwrapInt (LC.Int _ val) = Just $ toEnum $ fromInteger val
    unwrapInt _ = Nothing
toGlobalStrPair _ = Nothing

globalMapOf :: [LL.Global] -> Maybe (Map LL.Name LL.Name)
globalMapOf g = toGlobalMap =<< llvmGlobalAnnotations g

toGlobalMap :: LL.Global -> Maybe (Map LL.Name LL.Name)
toGlobalMap = unwrapGlobal
    where
    unwrapGlobal LL.GlobalVariable {initializer = Just init} = unwrapArr init
    unwrapGlobal _ = Nothing

    unwrapArr LC.Array {memberValues} = M.fromList <$> mapM unwrapStruct memberValues
    unwrapArr _ = Nothing

    unwrapStruct LC.Struct {memberValues = [nameRef, labelRef, _, _]} = do
        name <- unwrapNameRef nameRef
        label <- unwrapLabelRef labelRef
        pure (name, label)
    unwrapStruct _ = Nothing

    unwrapNameRef (LC.BitCast (LC.GlobalReference _ n) _) = Just n
    unwrapNameRef _ = Nothing

    unwrapLabelRef LC.GetElementPtr {address = (LC.GlobalReference _ n)} = Just n
    unwrapLabelRef _ = Nothing


extractName :: LL.Global -> LL.Name
extractName LL.GlobalVariable {name} = name
extractName LL.GlobalAlias {name} = name
extractName LL.Function {name} = name

llvmGlobalAnnotations :: [LL.Global] -> Maybe LL.Global
llvmGlobalAnnotations x = traceShow (extractName <$> x) $ find ((== LL.mkName "llvm.global.annotations") . extractName) x

