module Main where

import System.Environment

import Lib
import qualified Data.Map as M
import CLE.JSON (decodeCLEMap)
import CLE.LLVM.Annotater (annotate)
import CLE.Infer.Check (runCheck, checkAllTopLevelEntities)
import CLE.Infer.Constraint (solveUntilAssignment, solve, substMany)
import qualified Data.ByteString.Lazy as B
import qualified Data.ByteString.Lazy.Char8 as C 
import CLE.JSON.Topology (fromTypeMap)
import Data.Aeson.Encode.Pretty
main :: IO ()
main = do
    [bc, clemap] <- getArgs
    cle <- decodeCLEMap <$> B.readFile clemap 
    case cle of 
        Left s -> print s
        Right clemap -> do
            annotated <- annotate <$> fromBitcode bc
            case runCheck (checkAllTopLevelEntities annotated) clemap of
                Left x -> print x
                Right (map, _, constrs) -> do
                    case solveUntilAssignment clemap constrs of
                        Left x -> print x
                        Right (constrs', substs) -> do
                            mapM_ print constrs  
                            putStrLn "generated map:"
                            let gmap = substMany substs map  
                            C.putStrLn $ encodePretty (fromTypeMap clemap gmap) 
