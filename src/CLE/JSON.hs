module CLE.JSON where

import qualified Data.ByteString.Lazy as B 
import qualified CLE.JSON.Raw as R
import CLE.JSON.Model
import Data.Aeson (eitherDecode, encode)

decodeCLEMap :: B.ByteString -> Either String CLEMap  
decodeCLEMap input = do
    rawCLEMap <- eitherDecode input
    toEither (fromRawCLEMap rawCLEMap)

encodeCLEMap :: CLEMap -> B.ByteString 
encodeCLEMap = encode . toRawCLEMap
