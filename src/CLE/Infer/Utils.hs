{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE FlexibleInstances #-}
module CLE.Infer.Utils where

import qualified LLVM.AST as LL
import qualified LLVM.AST.Constant as LC
import CLE.Infer.Constraint (QName (GlobalName, LocalName))
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
    namesFrom LL.Call {LL.function, LL.arguments} = namesFrom function ++ namesFrom (fst <$> arguments)
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

fromLLName :: LL.Name -> LL.Name -> QName
fromLLName funName (LL.Name s) = GlobalName (LL.Name s) True
fromLLName funName n = LocalName funName n


notIntrinsicName :: LL.Name -> Bool
notIntrinsicName n
    | n == LL.mkName "llvm.dbg.declare"
    || n == LL.mkName "printf"
    || n == LL.mkName "llvm.var.annotation" = False
    | otherwise = True

filterNames :: [LL.Name] -> [LL.Name]
filterNames = filter notIntrinsicName
    

toUnnamed :: LL.Name -> b -> Word -> (QName, b)
toUnnamed name ty i = (LocalName name (LL.UnName i), ty)