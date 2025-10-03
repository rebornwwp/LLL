{-# LANGUAGE DeriveFunctor      #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE GADTs              #-}
{-# LANGUAGE InstanceSigs       #-}
{-# LANGUAGE KindSignatures     #-}

module FunctorApplicativeMonad.FreeMonads.Demo where

import           Control.Monad.Free
import           Data.Kind          (Type)
import           Debug.Trace        (trace)


-- data List a = Nil | Cons a (List a)
-- data Free f a = Nil a | Cons f (Free f a)
-- data Free f a
--   = Pure a
--   | Free (f (Free f a))

-- data Interaction :: Type -> Type where
--   Return :: a -> Interaction a
--   Say0 :: String -> (() -> Interaction b) -> Interaction b
--   Ask0 :: (String -> Interaction b) -> Interaction b
-- 对上面的演进
-- data Interaction :: Type -> Type where
--   Return :: a -> Interaction a
--   Wrap :: InteractionOp a -> Interaction a

-- data InteractionOp :: Type -> Type where
--   Say0 :: String -> (() -> Interaction b) -> InteractionOp b
--   Ask0 :: (String -> Interaction b) -> InteractionOp b

-- 对上面的演进
-- data Free :: (Type -> Type) -> Type -> Type where
--   Return :: a -> Free f a
--   Wrap :: f (Free f a) -> Free f a

-- data InteractionOp :: Type -> Type where
--   Say0 :: String -> (() -> r) -> InteractionOp r
--   Ask0 :: (String -> r) -> InteractionOp r

-- type Interaction = Free InteractionOp

-- 对上面演进
-- Free f is a monad whenever f is a functor
-- data Free :: (Type -> Type) -> Type -> Type where
--   Return :: a -> Free f a
--   Wrap :: f (Free f a) -> Free f a

-- instance Functor f => Monad (Free f) where
--   return :: a -> Free f a
--   return = Return
--   (>>=) :: Free f a -> (a -> Free f b) -> Free f b
--   Return x >>= f = f x
--   Wrap c >>= f   = Wrap (fmap (>>= f) c)
data BinTreeF l a =
  NodeF l a a
  deriving (Functor)

type FreeBinTree l = Free (BinTreeF l)

buildBalanced :: [Int] -> FreeBinTree Int (Maybe Int)
buildBalanced [] = pure Nothing
buildBalanced [x] = pure $ Just x
buildBalanced xs = do
  let len = length xs
      (l, x:r) = splitAt (len `div` 2) xs
  b <- liftF $ NodeF x l r
  buildBalanced b

data BinTree l
  = Nil
  | Leaf l
  | Branch l (BinTree l) (BinTree l)
  deriving (Show)

convert :: FreeBinTree a (Maybe a) -> BinTree a
convert (Pure Nothing) = Nil
convert (Pure (Just x)) = Leaf x
convert (Free f) =
  let NodeF x l r = convert <$> f
   in Branch x l r

xxx = convert $ buildBalanced [0 .. 10]

--- >>> x
-- Branch 5 (Branch 2 (Branch 1 (Leaf 0) Nil) (Branch 4 (Leaf 3) Nil)) (Branch 8 (Branch 7 (Leaf 6) Nil) (Branch 10 (Leaf 9) Nil))
data LogF next
  = WriteLog String next
  | Done
  deriving (Functor)

type Log = Free LogF

writeLog :: String -> Log ()
writeLog msg = liftF (WriteLog msg ())

done :: Log ()
done = liftF Done

program :: Log ()
program = do
  writeLog "Starting process"
  writeLog "Process running"
  writeLog "Process completed"
  done

interpret :: Log a -> IO ()
interpret (Pure _)                   = return ()
interpret (Free (WriteLog msg next)) = putStrLn msg >> interpret next
interpret (Free Done)                = putStrLn "Finished"

xx = interpret program


-- ghci> xx
-- Starting process
-- Process running
-- Process completed
-- Finished

-- AST demo
-- 普通的方式定义
data ExprE
  = LitE Int
  | AddE ExprE ExprE


-- 使用 Free monad 定义
newtype StateF s a = StateF
  { runStateF :: s -> (a, s)
  } deriving stock (Functor)

getF :: StateF s s
getF = StateF $ \s -> (s, s)

putF :: s -> StateF s ()
putF s = StateF $ const ((), s)

type State s = Free (StateF s)

get :: State s s
get = liftF getF

put :: s -> State s ()
put = liftF . putF

someComputation :: State Int ()
someComputation = do
  i <- get
  put $ i + 1
  i2 <- get
  put $ i2 + 1
  pure ()


-- an interpreter
runState :: State s a -> s -> (a, s)
runState (Pure x) s = (x, s)
runState (Free f) s =
  let (m, s') = runStateF f s
   in runState m s'

printState :: (Show s, Show a) => State s a -> s -> String
printState (Pure x) s = "pure (" <> show x <> "," <> show s <> ")"
printState (Free m) s =
  let (x, s') = runStateF m s
   in "state change " <> show s <> " -> " <> show s' <> "\n" <> printState x s'
