{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE QuantifiedConstraints #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE TypeFamilies #-}
module CLE.LLVM.Wrapper where

import qualified LLVM.AST as LL
import LLVM.AST.Global (basicBlocks)
import Data.List (sortBy)
import qualified LLVM.AST.Constant as LC

data LLIndex = Term | Inst | BB | Glob | Func deriving (Show)

newtype Terminator f = Terminator (f 'Term)
newtype Instruction f = Instruction (f 'Inst)
data BasicBlock f = BasicBlock LL.Name [Instruction f] (Terminator f) (f 'BB)
data Function f = Function [BasicBlock f] (f 'Func)
newtype GlobalVariable f = GlobalVariable (f 'Glob)

data TopLevelEntity f 
  = FunDef (Function f) 
  | GlobDef (GlobalVariable f)
  | Decl LL.Name (Maybe LL.Type)

instance (forall (i :: LLIndex). Show (f i)) => Show (TopLevelEntity f) where
  show (FunDef f) = show f
  show (GlobDef f) = show f
  show (Decl n t) = show n ++ " " ++ show t 


instance Show (f 'Term) => Show (Terminator f) where
  show (Terminator f) = unwords ["(Terminator", show f, ")"]

instance Show (f 'Inst) => Show (Instruction f) where
  show (Instruction f) = unwords ["(Instruction", show f, ")"]

instance (Show (f 'Term), Show (f 'Inst), Show (f 'BB)) => Show (BasicBlock f) where
  show (BasicBlock n instrs term f) = unwords ["(BasicBlock ", show n, show instrs, show term, show f, ")"]

instance (forall (i :: LLIndex). Show (f i)) => Show (GlobalVariable f) where
  show (GlobalVariable f) = unwords ["(Global", show f, ")"]

instance (forall (i :: LLIndex). Show (f i)) => Show (Function f) where
  show (Function bb f) = unwords ["(Function", show bb, show f, ")"]


data FunctionInfo = FunctionInfo {
    name :: LL.Name,
    basicBlocks :: [LL.BasicBlock],
    parameters :: ([LL.Parameter],Bool), -- ^ snd indicates varargs
    returnType :: LL.Type
} deriving (Show, Eq) 

data GlobalInfo = GlobalInfo LL.Name LL.Type (Maybe LC.Constant) deriving (Show, Eq)

data LL (i :: LLIndex) where
  WrapTerminator :: LL.Named LL.Terminator -> LL 'Term
  WrapInstruction :: LL.Named LL.Instruction -> LL 'Inst
  WrapBasicBlock :: LL.BasicBlock -> LL 'BB
  WrapFunction :: FunctionInfo -> LL 'Func
  WrapGlobalVariable :: GlobalInfo -> LL 'Glob


instance Show (LL i) where
  show (WrapTerminator t) = show t
  show (WrapInstruction i) = show i
  show (WrapBasicBlock b) = show b
  show (WrapFunction g) = show g
  show (WrapGlobalVariable g) = show g


class Wrap f where
    type LLArg f
    wrap :: LLArg f -> f LL 

instance Wrap Terminator where
    type LLArg Terminator = LL.Named LL.Terminator  
    wrap = Terminator . WrapTerminator

instance Wrap Instruction where
    type LLArg Instruction = LL.Named LL.Instruction   
    wrap = Instruction . WrapInstruction

instance Wrap BasicBlock where
    type LLArg BasicBlock = LL.BasicBlock
    wrap bb@(LL.BasicBlock n instrs term) = BasicBlock n (fmap wrap instrs) (wrap term) (WrapBasicBlock bb)

instance Wrap GlobalVariable where
    type LLArg GlobalVariable = GlobalInfo  
    wrap = GlobalVariable . WrapGlobalVariable

instance Wrap Function where 
    type LLArg Function = FunctionInfo   
    wrap f@FunctionInfo {basicBlocks} = Function (wrap <$> sortBBs basicBlocks) (WrapFunction f)
        where
            sortBBs = sortBy compBB
            compBB (LL.BasicBlock n _ _) (LL.BasicBlock n' _ _) = compare n n'

data (&) f g (i :: LLIndex) = (f i) :& (g i)

instance (Show (f i), Show (g i)) => Show ((f & g) i) where
  show (a :& b) = unwords ["(" ++ show a, "&", show b ++ ")"]

newtype Raise a (i :: LLIndex) = Raise a deriving Show

nameOf :: TopLevelEntity (LL & f) -> LL.Name
nameOf (FunDef (Function _ (WrapFunction FunctionInfo {name} :& _))) = name
nameOf (GlobDef (GlobalVariable (WrapGlobalVariable (GlobalInfo name _ _) :& _))) = name
nameOf (Decl name _) = name