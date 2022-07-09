{-# LANGUAGE DeriveGeneric, OverloadedStrings #-}
module CLE.JSON.Topology where

import GHC.Generics (Generic)
import Data.Aeson
import qualified Data.Vector as V
import Data.ByteString.Char8 (unpack)
import Data.ByteString.Short (fromShort)
import CLE.Infer.Constraint ( QName(GlobalName), Ty (Labelled) )
import CLE.JSON.Model (CLEMap (CLEMap), Label, levelOf, lookupLabel, Level (Level))
import qualified Data.Map as M
import Data.Coerce (coerce)
import qualified LLVM.AST as LL
import Data.Maybe (mapMaybe)
import Data.Bifoldable (biconcatMap)
import Data.Bifunctor (Bifunctor(first))
import Data.List (nub)

data Assignment = Assignment {
    name :: String,
    enclave :: String,
    level :: String,
    line :: Maybe Int
} deriving (Generic, Show, Eq)

data Topology = Topology {
    sourcePath :: String,
    enclaves :: [String],
    levels :: [String],
    globalScopedVars :: [Assignment],
    functions :: [Assignment]
} deriving (Generic, Show, Eq)

instance ToJSON Assignment where
instance FromJSON Assignment where

instance ToJSON Topology where
    toJSON (Topology sourcePath enclaves levels globalScopedVars functions)
        = object [
            "source_path" .= sourcePath,
            "enclaves" .= enclaves,
            "levels" .= levels,
            "global_scoped_vars" .= globalScopedVars,
            "functions" .= functions
            ]

fromTypeMap :: CLEMap -> M.Map QName Ty -> Topology
fromTypeMap clemap tymap = Topology "" enclaves levels globAssngs funcAssngs  
    where
    enclaves = (++ "_E") <$> levels 
    levels = nub $ (\(Level l) -> l) . levelOf <$> M.elems m
        where
        (CLEMap m) = clemap
    globAssngs = toAssgnList globmap
    funcAssngs = toAssgnList fnmap
    toAssgnList = mapMaybe (uncurry $ fromNameLabelPair clemap)
    globmap = mapMaybeFirst (first (toGlobalName False)) $ M.toList labelmap
    fnmap = mapMaybeFirst (first (toGlobalName True)) $ M.toList labelmap
    labelmap = M.mapMaybe fromLabel tymap
    toGlobalName s (GlobalName n f) =
        if f == s then Just n else Nothing
    toGlobalName _ _ = Nothing
    mapMaybeFirst f = mapMaybe (interpret . f)
        where
            interpret (Just a, b) = Just (a, b)
            interpret (Nothing, _) = Nothing
    fromLabel (Labelled l) = Just l
    fromLabel _ = Nothing

fromNameLabelPair :: CLEMap -> LL.Name -> Label -> Maybe Assignment
fromNameLabelPair map (LL.Name n) l
    = Assignment name
    <$> enclave
    <*> level
    <*> Just Nothing
    where
        enclave = (++ "_E") <$> level
        level = (\(Level l) -> l) . levelOf <$> def
        def = lookupLabel l map
        name = unpack $ fromShort n
fromNameLabelPair _ _ _ = Nothing
