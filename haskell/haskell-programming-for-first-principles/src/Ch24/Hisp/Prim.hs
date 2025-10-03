module Ch24.Hisp.Prim where

import           Ch24.Hisp.LispVal (Eval, IFunc (IFunc), LispVal (Fun))
import           Control.Exception (throw)
import qualified Data.Map          as Map
import qualified Data.Text         as T

type Prim = [(T.Text, LispVal)]

type Unary = LispVal -> Eval LispVal

type Binary = LispVal -> LispVal -> Eval LispVal

mkF :: ([LispVal] -> Eval LispVal) -> LispVal
mkF = Fun . IFunc

primEnv :: Prim
primEnv = []

unop :: Unary -> [LispVal] -> Eval LispVal
unop op [x] = op x
-- unop _ args = throw $ NumArg 1 args
