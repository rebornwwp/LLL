module Ch24.LLVML.Codegen where

import           Data.Function
import           Data.List
import qualified Data.Map            as Map
import           Data.String
import           Data.Word

import           Control.Applicative
import           Control.Monad.State
-- import           LLVM.AST
-- import qualified LLVM.AST                        as AST
-- import qualified LLVM.AST.Attribute              as A
-- import qualified LLVM.AST.CallingConvention      as CC
-- import qualified LLVM.AST.Constant               as C
-- import qualified LLVM.AST.FloatingPointPredicate as FP
-- import           LLVM.AST.Global
-- import qualified LLVM.AST.Linkage                as L
-- newtype LLVM a =
--   LLVM (State AST.Module a)
