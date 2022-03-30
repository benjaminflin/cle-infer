module CLE where

import Data.Map (Map)

data JSON = JSON { 
    level :: String,
    cdf :: [CDF]
} deriving (Show, Eq)


data Taints = Taints {
    argtaints :: [[String]],
    codtaints :: [String],
    rettaints :: [String] 
} deriving (Show, Eq)

data CDF = CDF {
    remotelevel :: String,
    taints :: Maybe Taints,
    oneway :: Bool,
    direction :: Direction
} deriving (Show, Eq) 

data Direction = Ingress | Egress | Bidirectional deriving (Show, Eq)

type CLEMap = Map String JSON 