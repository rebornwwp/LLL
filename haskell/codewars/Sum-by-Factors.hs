module Codewars.Kate.SumByFactors where

{-
Given an array of positive or negative integers

I= [i1,..,in]

you have to produce a sorted array P of the form

[ [p, sum of all ij of I for which p is a prime factor (p positive) of ij] ...]

P will be sorted by increasing order of the prime numbers. The final result has
to be given as a string in Java, C#, C, C++ and as an array of arrays in other
languages.

Example:

I = [12, 15] -- result = [(2,12),(3,27),(5,15)]
[2, 3, 5] is the list of all prime factors of the elements of I, hence the result.

Notes:

It can happen that a sum is 0 if some numbers are negative!
Example: I = [15, 30, -45] 5 divides 15, 30 and (-45) so 5 appears in the result,
the sum of the numbers for which 5 is a factor is 0 so we have [5, 0] in the result
amongst others.

In Fortran - as in any other language - the returned string is not permitted to
contain any redundant trailing whitespace: you can use dynamically allocated
character strings.
-}

import           Data.List

-- 这个代码中对于数的isprime进行了判断
sumOfDivided :: [Integer] -> [(Integer, Integer)]
sumOfDivided xs = result
  where
    isPrime k = null [x | x <- [2 .. k - 1], k `mod` x == 0]
    primes = [n | n <- [2 .. (maximum . map abs) xs], isPrime n]
    result =  foldl' (\acc (x, y, isMod) -> if isMod then acc ++ [(x,y)] else acc) [] $ zipWith (\xs y -> (y, sum $ filter (\a -> a `mod` y == 0) xs, any (\a -> a `mod` y == 0) xs)) (replicate (length primes) xs) primes


-- 并没有对prime做什么判断，只是做因式分解
factors' :: Integral t => t -> [t]
factors' n
  | n < 0 = factors' (-n)
  | n > 0 = if 1 == n
               then []
               else let fac = mfac n 2 in fac : factors' (n `div` fac)
  where mfac m x
          | rem m x == 0 = x
          | x * x > m    = m
          | otherwise    = mfac m (if odd x then x + 2 else x + 1)

sumOfDivided' :: [Integer] -> [(Integer, Integer)]
sumOfDivided' xs = sort $ (\x -> (x, sum [o | o <- xs, f1 o x])) <$> f xs
  where f n = nub $ n >>= factors'
        f1 n m = 0 == mod n m

main :: IO ()
main = do
  print $ sumOfDivided [12, 15]
  print $ sumOfDivided [15, 30, -45]
  print $ sumOfDivided' [12, 15]
  print $ sumOfDivided' [15, 30, -45]
  print $ sumOfDivided' [18, 27, 81]

