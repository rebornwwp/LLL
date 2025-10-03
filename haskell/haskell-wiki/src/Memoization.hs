{-# LANGUAGE BangPatterns #-}

module Memoization where

import           Control.Monad.State
import           System.Posix.Internals (puts)


-- import           Data.Function       (fix)
{- | document:
https://wiki.haskell.org/Memoization
https://en.wikibooks.org/wiki/Haskell/Fix_and_recursion
https://kseo.github.io/posts/2017-01-14-memoization-in-hasekll.html
-}
-- without memoization
fib1 :: Int -> Integer
fib1 0 = 1
fib1 1 = 1
fib1 n = fib1 (n - 1) + fib1 (n - 2)


-- with memoization
memoize :: (Int -> a) -> (Int -> a)
memoize f = (map f [0 ..] !!)

fib2 :: (Int -> Integer) -> Int -> Integer
fib2 f 0 = 1
fib2 f 1 = 1
fib2 f n = f (n - 1) + f (n - 2)

fibMemo :: Int -> Integer
fibMemo = fix (memoize . fib2)


-- tail recursive
fib3 :: (Eq t, Num t, Num b) => t -> b
fib3 n = go n (0, 1)
  where
    go !n (!a, !b)
      | n == 0    = a
      | otherwise = go (n - 1) (b, a + b)


-- monadic
fib4 :: Int -> Integer
-- fib4 n =
--   flip evalState (0, 1) $ do
--     forM [0 .. (n - 1)] $ \_ -> do
--       (a, b) <- get
--       put (b, a + b)
--     (a, b) <- get
--     return a
fib4 n =
  flip evalState (0, 1) $ do
    forM_ [0 .. (n - 1)] $ \_ -> do
      (a, b) <- get
      put (b, a + b)
    (a, _) <- get
    return a
