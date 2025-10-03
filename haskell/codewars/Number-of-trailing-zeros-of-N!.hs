module Zeros where

{-
Write a program that will calculate the number of trailing zeros in a factorial of a given number.

N! = 1 * 2 * 3 * ... * N

Be careful 1000! has 2568 digits...

For more info, see: http://mathworld.wolfram.com/Factorial.html

Examples

zeros(6) = 1
# 6! = 1 * 2 * 3 * 4 * 5 * 6 = 720 --> 1 trailing zero

zeros(12) = 2
# 12! = 479001600 --> 2 trailing zeros
Hint: You're not meant to calculate the factorial. Find another way to find the number of zeros.
-}

-- 第一个方法，将操作放在操作的过程中进行操作，避免以下更大的是的产生
zeros :: Int -> Int
zeros 0 = 0
zeros n = f n + zeros (n - 1)
  where f x | x `mod` 5 == 0 = 1 + f (x `div` 5)
            | otherwise = 0

-- 第二个方法，从5，25，125... 出发来寻找 这个中重复a/25
zeros' :: Int -> Int
zeros' n = sum $ zipWith (\x y -> x `div` y) (repeat n) [5 ^ i | i <- [1..], n `div` (5^i)> 0]

-- 这三个方法，第二个方法的改进，去除了中间重复的操作
f 0 = 0
f x = x `div` 5 + f (x `div` 5)

main = do
  print $ zeros 0
  print $ zeros 30
  print $ zeros 25
  -- print $ zip (map zeros [0..129]) [0..129]
  print $ f 1000000000
  print $ f 100000
