module Codewars.G964.Kprimes where

{-
Examples:
k = 2 -> 4, 6, 9, 10, 14, 15, 21, 22, …
k = 3 -> 8, 12, 18, 20, 27, 28, 30, …
k = 5 -> 32, 48, 72, 80, 108, 112, …
#Task:

Write function count_Kprimes (or countKprimes or count-K-primes or kPrimes) which given parameters k, start, end (or nd) returns an array (or a list or a string depending on the language - see "Solution" and "Sample Tests") of the k-primes between start (inclusive) and end (inclusive).
#Example:

countKprimes(5, 500, 600) --> [500, 520, 552, 567, 588, 592, 594]
...............................................................................

for all languages except Bash shell
Given positive integers s and a, b, c where a is 1-prime, b 3-prime, c 7-prime find the number of solutions of a + b + c = s. Call this function puzzle(s).

Examples:

puzzle(138) --> 1 ([2 + 8 + 128] is solution)
puzzle(143) --> 2 ([3 + 12 + 128, 7 + 8 + 128] are solutions)
...............................................................................

Notes:

The first function would have been better named: findKprimes or kPrimes :-)
In C some helper functions are given (see declarations in 'Solution').
For Go: nil slice is expected when there are no k-primes between start and end.
-}


factor :: Int -> Int
factor = fact 2
  where
    fact n x
      | n * n <= x = if x `mod` n == 0 then 1 + fact n (x `quot` n) else fact (n + 1) x
      | x > 1 = 1
      | otherwise = 0

factor2 :: Int -> Int
factor2 n
  | n < 2 = 0
  | otherwise = 1 + factor2 (n `div` i)
  where
    i = head $ filter ((== 0) . mod n) [2..]

factor'' :: Int -> [Int]
factor'' 1 = []
factor'' x
  | null (f x) = [x]
  | otherwise = head (f x) : factor'' (x `quot` head (f x))
  where
    f x = dropWhile ((/= 0) . mod x) $ [2 .. ceiling $ sqrt $ fromIntegral x]

countKprimes :: Int -> Int -> Int -> [Int]
countKprimes k start end = filter ((== k) . factor2) [start .. end]

puzzle :: Int -> Int
puzzle s =
  length
    [ 1
    | x <- countKprimes 1 2 s
    , y <- countKprimes 3 2 s
    , z <- countKprimes 7 2 s
    , x + y + z == s
    ]

factor' 1 = []
factor' n = let divisors = dropWhile ((/= 0) . mod n) [2 .. ceiling $ sqrt $ fromIntegral n]
           in let prime = if null divisors then n else head divisors
           in (prime :) . factor' $ quot n prime


countKprimes' :: Int -> Int -> Int -> [Int]
countKprimes' k start end = filter ((== k) . length . factor') [start .. end]

puzzle' :: Int -> Int
puzzle' n = length [1 | a <- as, b <- bs, c <- cs, a + b + c == n]
    where as = countKprimes' 1 2 n
          bs = countKprimes' 3 2 n
          cs = countKprimes' 7 2 n

main :: IO ()
main = do
  print $ puzzle 138
  print $ puzzle 143
  print $ puzzle' 138
  print $ puzzle' 143
