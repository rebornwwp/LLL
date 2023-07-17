module ReaderTLib
  ( main1
  ) where

import           Control.Monad.Reader (MonadReader (ask, local),
                                       MonadTrans (lift), Reader,
                                       ReaderT (ReaderT, runReaderT), asks,
                                       mapReaderT, withReaderT)

{-
use case:
 当整体运行流程中都需要对某个变量读取时候使用
 如果不使用Reader a，将会使得每个调用函数将会传入此参数，或者调用链中的每个函数都需要加入此参数

 带T的Monad使用T的函数
-}
type Env = [(String, Int)]

type EvalM a = ReaderT Env Maybe a

data Config =
  Config
    { verbose :: Bool
    {- other parameters -}
    }

type ConfigM = Reader Config

data Expr
  = Val Int
  | Add Expr Expr
  | Var String
  deriving (Show)

{-
读取参数
ask :: MonadReader r m => m r, 返回整个参数
asks :: MonadReader r m => (r -> a) -> m a, apply function to the params
-}
eval :: Expr -> EvalM Int
eval ex =
  case ex of
    Val n -> return n
    Add x y -> do
      a <- eval x
      b <- eval y
      return $ a + b
    Var x -> do
      env <- ask
      val <- lift $ lookup x env
      return val

eval' :: Expr -> EvalM Int
eval' ex =
  case ex of
    Val n -> return n
    Add x y -> do
      a <- eval x
      b <- eval y
      return $ a + b
    Var x
      -- env <- reader id {- this -}
     -> do
      env <- asks id {- this: reader 与 asks 对等 -}
      val <- lift $ lookup x env
      return val

env :: Env
env = [("x", 2), ("y", 5)]

{- (2+1) + x -}
ex1 :: EvalM Int
ex1 = eval (Add (Val 2) (Add (Val 1) (Var "x")))

{-
change data
  (2+1) + z
-}
ex2 :: EvalM Int
ex2 = local changeEnv (eval (Add (Val 2) (Add (Val 1) (Var "z"))))

{- change function -}
changeEnv :: Env -> Env
changeEnv env = env <> [("z", 100)]

{-
mapReader:: (a -> b) -> Reader r a -> Reader r b  map READER
-}
mapEvalIntToString :: EvalM Int -> EvalM String
mapEvalIntToString = mapReaderT (\x -> Just "hello")

{-
withReader :: (r' -> r) -> Reader r a -> Reader r' a 将参数改变
-}
withEvalIntToString :: EvalM Int -> ReaderT String Maybe Int
withEvalIntToString = withReaderT (\x -> [(x, 100)])

example1 :: Maybe Int
example1 = runReaderT ex1 env

example2 :: Maybe Int
example2 = runReaderT ex1 []

changeExample1 :: Maybe Int
changeExample1 = runReaderT ex2 env

changeExample2 :: Maybe Int
changeExample2 = runReaderT ex2 []

mapReaderExample :: Maybe String
mapReaderExample = runReaderT (mapEvalIntToString ex1) env

withReaderExample :: Maybe Int
withReaderExample =
  runReaderT (withEvalIntToString ex1 :: ReaderT String Maybe Int) "x" {-
    与env无关， 通过传入的"x", 与withReaderT中传入的函数，创建新的数据,数据类型为[]
  -}

main1 :: IO ()
main1 = do
  print example1
  print example2
  print changeExample1
  print changeExample2
  print mapReaderExample
  print withReaderExample
