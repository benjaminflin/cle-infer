{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE TupleSections #-}
module CLE.JSON.Model where

import CLE.JSON.Raw (Direction, GuardDirective)
import qualified CLE.JSON.Raw as R
import Data.Maybe (fromMaybe)
import Data.List (find)
import Data.Map (Map)
import qualified Data.Map as M
import Data.Coerce (coerce)
newtype Level = Level String deriving (Show, Eq, Ord)
newtype Label = Label String deriving (Show, Eq, Ord)

data CDF = CDF {
    remotelevel :: String,
    direction :: Direction,
    guarddirective :: Maybe GuardDirective
} deriving (Show, Eq)

data Definition
    = NodeDefinition {
        level :: Level,
        cdfs :: [CDF]
    }
    | FunDefinition {
        level :: Level,
        argtaints :: [[Label]],
        codtaints :: [Label],
        rettaints :: [Label],
        cdfs :: [CDF]
    } deriving (Show, Eq)

data TaintKind = Arg | Cod | Ret deriving (Show, Eq, Ord)

newtype Err
    = NotDefined TaintKind 
    deriving (Eq)

instance Show Err where
    show (NotDefined Arg) = "argtaints not defined for function cdf"
    show (NotDefined Cod) = "codtaints not defined for function cdf"
    show (NotDefined Ret) = "rettaints not defined for function cdf"

type Result = Either Err 

data CDFKind = Var | Fun [[Label]] [Label] [Label] deriving (Show, Eq, Ord)

newtype CLEMap = CLEMap (Map Label Definition) deriving (Show, Eq)   

classifyCDF :: R.CDF -> Result CDFKind
classifyCDF
    (R.CDF remotelevel direction guarddirective (Just arg) (Just cod) (Just ret))
    = pure (Fun (fmap (fmap Label) arg) (fmap Label cod) (fmap Label ret))
classifyCDF
    (R.CDF remotelevel direction guarddirective Nothing Nothing Nothing)
    = pure Var
classifyCDF
    R.CDF {R.argtaints = Nothing} = Left $ NotDefined Arg
classifyCDF
    R.CDF {R.codtaints = Nothing} = Left $ NotDefined Cod
classifyCDF
    R.CDF {R.rettaints = Nothing} = Left $ NotDefined Ret

forgetTaints :: R.CDF -> CDF 
forgetTaints 
    R.CDF {R.remotelevel, R.direction, R.guarddirective} 
        = CDF remotelevel direction guarddirective

toDefinition :: R.CLEJSON -> Result Definition
toDefinition (R.CLEJSON level (Just cdfs)) = do
    let cdfs' = fmap forgetTaints cdfs
    case find ((== level). R.remotelevel) cdfs of
        Just cdf -> do 
            kind <- classifyCDF cdf
            pure $ case kind of
                Var -> NodeDefinition (Level level) cdfs' 
                Fun arg cod ret -> FunDefinition (Level level) arg cod ret cdfs' 
        Nothing -> pure $ NodeDefinition (Level level) cdfs'
toDefinition (R.CLEJSON level Nothing) = pure $ NodeDefinition (Level level) []

fromRawCLEMap :: R.CLEMap -> Result CLEMap
fromRawCLEMap (R.CLEMap map) 
    = CLEMap . M.fromList <$> mapM mapPair (M.toList $ M.mapKeys Label map)
    where
        mapPair (l, j) = (l, ) <$> toDefinition j 

toEither :: Result a -> Either String a  
toEither (Left x) = Left (show x)
toEither (Right x) = Right x  

toRawCDF :: Maybe ([[Label]], [Label], [Label]) -> CDF -> R.CDF
toRawCDF (Just (args, cod, ret)) (CDF remotelevel guarddirective direction) = 
    R.CDF remotelevel guarddirective direction (mapArgs args) (mapTaint cod) (mapTaint ret)
    where
        mapArgs = Just . fmap (fmap coerce)
        mapTaint = Just . fmap coerce
toRawCDF Nothing (CDF remotelevel guarddirective direction) = 
    R.CDF remotelevel guarddirective direction Nothing Nothing Nothing
    
toRawCLEJSON :: Definition -> R.CLEJSON 
toRawCLEJSON (NodeDefinition level cdfs) = R.CLEJSON (coerce level) $ 
    if null cdfs then Nothing else Just $ fmap (toRawCDF Nothing) cdfs
toRawCLEJSON (FunDefinition level args cod ret cdfs) = R.CLEJSON (coerce level) $
    if null cdfs then Nothing else 
        Just $ fmap 
            (toRawCDF $ Just (args, cod, ret)) cdfs

toRawCLEMap :: CLEMap -> R.CLEMap 
toRawCLEMap (CLEMap map) = R.CLEMap $ toRawCLEJSON <$> M.mapKeys coerce map