{-# LANGUAGE DeriveGeneric, OverloadedStrings #-}
module CLE.JSON.Raw where

import Data.Map (Map)
import GHC.Generics (Generic)
import Data.Aeson
import qualified Data.Map as M
import qualified Data.Vector as V
import Data.Char (toLower)
import Data.Foldable (fold)

data CLEJSON = CLEJSON {
    level :: String,
    cdf :: Maybe [CDF]
} deriving (Generic, Show, Eq)

data CDF = CDF {
    remotelevel :: String,
    direction :: Direction,
    guarddirective :: Maybe GuardDirective,
    argtaints :: Maybe [[String]],
    codtaints :: Maybe [String],
    rettaints :: Maybe [String]
} deriving (Generic, Show, Eq)

data GuardDirective = GuardDirective {
    operation :: Maybe Operation,
    oneway :: Maybe Bool,
    gapstag :: Maybe [Int]
} deriving (Generic, Show, Eq)

data Operation = Allow | Redact | Deny deriving (Generic, Show, Eq)

data Direction = Ingress | Egress | Bidirectional deriving (Generic, Show, Eq)

newtype CLEMap = CLEMap (Map String CLEJSON) deriving (Generic, Show, Eq)

options :: Options 
options = defaultOptions {
    constructorTagModifier = fmap toLower 
}

instance FromJSON Operation where
    parseJSON = genericParseJSON options
instance ToJSON Operation where
    toJSON = genericToJSON options
instance FromJSON Direction where
    parseJSON = genericParseJSON options
instance ToJSON Direction where
    toJSON = genericToJSON options
instance FromJSON GuardDirective where
instance ToJSON GuardDirective where
instance FromJSON CDF where
instance ToJSON CDF where
instance FromJSON CLEJSON where
instance ToJSON CLEJSON where
instance FromJSON CLEMap where
    parseJSON = withArray "CLEMap" $ fmap (CLEMap . fold) . V.mapM parsePair
        where
            parsePair = withObject "LabelJSONPair" $ \o -> 
                M.singleton <$> o .: "cle-label" <*> o .: "cle-json"
instance ToJSON CLEMap where
    toJSON (CLEMap map) = Array $ V.fromList $ toPair <$> M.toList map
        where
            toPair (label, json) = object ["cle-label" .= label, "cle-json" .= json]


