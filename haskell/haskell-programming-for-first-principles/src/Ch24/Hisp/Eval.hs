{-# LANGUAGE OverloadedStrings #-}

module Ch24.Hisp.Eval where

import           Ch24.Hisp.LispVal (Eval, IFunc (IFunc),
                                    LispException (TypeMismatch),
                                    LispVal (Atom, Bool, Fun, List, Nil, Number, String))
import           Ch24.Hisp.Prim    (primEnv, unop)
import           Control.Exception (throw)
import           Control.Monad.RWS (MonadIO (liftIO), MonadReader (ask))
import           Data.Map          (toList)
import qualified Data.Map          as Map
import qualified Data.Text         as T

basicEnv :: Map.Map T.Text LispVal
basicEnv = Map.fromList $ primEnv <> [("read", Fun $ IFunc $ unop readFn)]

readFn :: LispVal -> Eval LispVal
readFn x = do
  val <- eval x
  case val of
    (String txt) -> lineToEvalForm txt
    _            -> throw $ TypeMismatch "read expects string, insted got: " val

lineToEvalForm :: T.Text -> Eval LispVal
lineToEvalForm = undefined

eval :: LispVal -> Eval LispVal
eval (List [Atom "dumpEnv", x]) = do
  env <- ask
  liftIO $ print $ toList env
  eval x
eval (Number i) = return $ Number i
eval (String s) = return $ String s
eval (Bool b) = return $ Bool b
eval (List []) = return Nil
eval Nil = return Nil
eval n@(Atom _) = getVar n
eval _ = undefined

getVar :: LispVal -> Eval LispVal
getVar = undefined
