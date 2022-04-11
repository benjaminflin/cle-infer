module Lib where

import qualified LLVM.Module as LL
import qualified LLVM.Internal.Context as LL
import qualified LLVM.Internal.Module as LL
import qualified LLVM.AST as LLP
import qualified Data.ByteString as BS
import Data.Maybe

fromBitcode :: FilePath -> IO [LLP.Definition]
fromBitcode fp = 
    LL.withContext (\ctx -> LL.withModuleFromBitcode ctx (LL.File fp) fromModule)

fromModule :: LL.Module -> IO [LLP.Definition]
fromModule mod = LLP.moduleDefinitions <$> LL.moduleAST mod

