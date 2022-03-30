{-# LANGUAGE DataKinds, RankNTypes, UndecidableInstances, QuantifiedConstraints, GADTs, TypeFamilies, TypeOperators #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE NamedFieldPuns #-}
module Wrapper where

import qualified LLVM.AST as LL
import LLVM.AST.Global (basicBlocks)
import Data.List (sortBy)
import Data.Void (Void)


data LLIndex = Term | Inst | BB | Glob deriving (Show)

newtype Terminator f = Terminator (f 'Term)
newtype Instruction f = Instruction (f 'Inst)
data BasicBlock f = BasicBlock LL.Name [Instruction f] (Terminator f) (f 'BB)
data Global f
  = Function [BasicBlock f] (f 'Glob) 
  | Global (f 'Glob)

instance Show (f 'Term) => Show (Terminator f) where
  show (Terminator f) = unwords ["(Terminator", show f, ")"]

instance Show (f 'Inst) => Show (Instruction f) where
  show (Instruction f) = unwords ["(Instruction", show f, ")"]

instance (Show (f 'Term), Show (f 'Inst), Show (f 'BB)) => Show (BasicBlock f) where
  show (BasicBlock n instrs term f) = unwords ["(BasicBlock ", show n, show instrs, show term, show f, ")"]

instance (forall (i :: LLIndex). Show (f i)) => Show (Global f) where
  show (Global f) = unwords ["(Global", show f, ")"]
  show (Function bb f) = unwords ["(Function", show bb, show f, ")"]

data LL (i :: LLIndex) where
  WrapTerminator :: LL.Named LL.Terminator -> LL 'Term
  WrapInstruction :: LL.Named LL.Instruction -> LL 'Inst
  WrapBasicBlock :: LL.BasicBlock -> LL 'BB
  WrapGlobal :: LL.Global -> LL 'Glob


instance Show (LL i) where
  show (WrapTerminator t) = show t
  show (WrapInstruction i) = show i
  show (WrapBasicBlock b) = show b
  show (WrapGlobal g) = show g

type family LLArg f where
  LLArg Terminator = LL.Named LL.Terminator
  LLArg Instruction = LL.Named LL.Instruction
  LLArg BasicBlock = LL.BasicBlock
  LLArg Global = LL.Global

class Wrap f where
  wrap :: LLArg f -> f LL 

instance Wrap Terminator where
  wrap = Terminator . WrapTerminator

instance Wrap Instruction where
  wrap = Instruction . WrapInstruction

instance Wrap BasicBlock where
  wrap bb@(LL.BasicBlock n instrs term) = BasicBlock n (fmap wrap instrs) (wrap term) (WrapBasicBlock bb)

instance Wrap Global where
  wrap global@LL.GlobalVariable {..} = Global $ WrapGlobal global
  wrap global@LL.GlobalAlias {..} = Global $ WrapGlobal global
  wrap global@LL.Function {basicBlocks, ..} = Function (wrap <$> sortBBs basicBlocks) (WrapGlobal global)
    where
      sortBBs = sortBy compBB
      compBB (LL.BasicBlock n _ _) (LL.BasicBlock n' _ _) = compare n n'

data (&) f g (i :: LLIndex) = (f i) :& (g i)

instance (Show (f i), Show (g i)) => Show ((f & g) i) where
  show (a :& b) = unwords ["(", show a, " & ", show b, ")"]

newtype Raise a (i :: LLIndex) = Raise a deriving Show