module Main where

import System.Environment

import Lib
import Extract
import Wrapper
import CLE
import Data.Map as M
import Check

example1CLEMap :: CLEMap 
example1CLEMap = M.fromList [
    ("PURPLE", JSON "purple" []),
    ("ORANGE", JSON "orange" [CDF "purple" Nothing False Bidirectional]),
    ("XDLINKAGE_GET_A", JSON "orange" [
        CDF "purple" (Just $ Taints [] ["ORANGE"] ["ORANGE"]) False Bidirectional,
        CDF "orange" (Just $ Taints [] ["ORANGE"] ["ORANGE"]) False Bidirectional
    ])
    ] 

main :: IO ()
main = do
    [bc] <- getArgs
    print . (\(Right (ctx, _, constrs)) -> solve' constrs ctx) . run . extract =<< fromBitcode bc
    where
        solve' constrs ctx = do
            (cs, ss) <- solveUntilConvergence constrs
            pure $ substMany ss ctx
        run t = runCheck (checkAll t) example1CLEMap 

