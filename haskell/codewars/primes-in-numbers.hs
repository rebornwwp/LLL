module Codewars.Kata.PrFactors where

{-
Given a positive number n > 1 find the prime factor decomposition of n. The result will be a string with the following form :

 "(p1**n1)(p2**n2)...(pk**nk)"
with the p(i) in increasing order and n(i) empty if n(i) is 1.

Example: n = 86240 should return "(2**5)(5)(7**2)(11)"
-}

import           Data.List (concat)
import           Data.Map  (fromListWith, toList)

prime_factors :: Integer -> String
prime_factors n =
  concat .
  map
    (\(x, y) ->
       if y == 1
         then "(" ++ show x ++ ")"
         else "(" ++ show x ++ "**" ++ show y ++ ")") .
  frequency $
  factor n
  where
    frequency :: (Ord a) => [a] -> [(a, Int)]
    frequency xs = toList (fromListWith (+) [(x, 1) | x <- xs])
    factor :: Integer -> [Integer]
    factor n
      | n < 0 = factor (abs n)
      | n > 0 =
        if n == 1
          then []
          else let fact = mfact n 2
                in fact : factor (n `div` fact)
      where
        mfact m x
          | rem m x == 0 = x
          | x * x > m = m
          | otherwise = mfact m (if odd x then x + 2 else x + 1)
