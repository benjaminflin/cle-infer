module Data.Map.Utils where

import Prelude hiding ( null )

import Data.Map ( (!?), mapMaybe, empty, Map, null )

compose :: Ord b => Map b c -> Map a b -> Map a c
compose bc ab
    | null bc = empty
    | otherwise = mapMaybe (bc !?) ab
