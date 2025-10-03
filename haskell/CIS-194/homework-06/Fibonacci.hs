{-# LANGUAGE FlexibleInstances #-}
{-# OPTIONS_GHC -fno-warn-missing-methods #-}
module Fibonacci where

-- exercise 1
fib :: Integer -> Integer
fib 1 = 0
fib 2 = 1
fib n = fib (n - 1) + fib (n - 2)

fibs1 :: [Integer]
fibs1 = 0 : 1 : zipWith (+) fibs1 (tail fibs1)

-- exercise 3
data Stream a = Cons a (Stream a)

instance Show a => Show (Stream a) where
  show = loop (20::Int) where
    loop 0 _ = "\n"
    loop n (Cons x rest) = show x ++ ", " ++ loop (n - 1) rest

streamToList :: Stream a -> [a]
streamToList (Cons a rest) = a : streamToList rest

-- exercise 4
streamRepeat :: a -> Stream a
streamRepeat x = Cons x (streamRepeat x)

streamMap :: (a -> b) -> Stream a -> Stream b
streamMap f (Cons x rest) = Cons (f x) (streamMap f rest)

streamFromSeed :: (a -> a) -> a -> Stream a
streamFromSeed f x = Cons x (streamFromSeed f (f x))

-- exercise 5
nats :: Stream Integer
nats = streamFromSeed (+1) 0

ruler :: Stream Integer
ruler = undefined

interleaveStream :: Stream a -> Stream a -> Stream a
interleaveStream (Cons x rest1) (Cons y rest2) = Cons x (Cons y (interleaveStream rest1 rest2))

streamZipWith :: (a -> b -> c) -> Stream a -> Stream b -> Stream c
streamZipWith f (Cons x rest1) (Cons y rest2) = Cons (f x y) (streamZipWith f rest1 rest2)


-- exercise 7
data Matrix = Matrix Integer Integer Integer Integer deriving Show

instance Num Matrix where
  (Matrix a0 b0 c0 d0) * (Matrix a1 b1 c1 d1) =
    Matrix
      (a0 * a1 + b0 * c1)
      (a0 * b1 + b0 * d1)
      (c0 * a1 + d0 * c1)
      (c0 * b1 + d0 * d1)

fib4 :: Integer -> Integer
fib4 0 = 0
fib4 n =
  let f = Matrix 1 1 1 0
   in let fn (Matrix _ o _ _) = o
       in fn (f ^ n)


main :: IO ()
main = do
  print $ fib 10
  print $ take 15 fibs1
  print $ take 15 . streamToList $ streamRepeat 5
  print $ streamFromSeed (+1) 0
  print $ streamZipWith (+) (streamRepeat 3) (streamRepeat 5)
  print $ Matrix 1 0 0 1 * Matrix 2 3 4 5
  print $ fib4 5
