module Codewars.G.Persistence where

{-
Write a function, persistence, that takes in a positive parameter num and returns its multiplicative persistence, which is the number of times you must multiply the digits in num until you reach a single digit.

For example:

 persistence 39 -- returns 3, because 3*9=27, 2*7=14, 1*4=4
                -- and 4 has only one digit

 persistence 999 -- returns 4, because 9*9*9=729, 7*2*9=126,
                 -- 1*2*6=12, and finally 1*2=2

 persistence 4 -- returns 0, because 4 is already a one-digit number
-}

import           Data.Char (digitToInt)

chain :: Int -> [Int]
chain n | n >= 0 && n <= 9 = [n]
        | otherwise = n : chain (multiplicative n)
        where multiplicative a = product (map (read . return) $ show a)

persistence, persistence' :: Int -> Int
persistence n = length (chain n) - 1

persistence' n = if n < 10 then 0 else 1 + persistence' (product $ map digitToInt $ show n)

main :: IO ()
main = do
    print $ persistence 39
    print $ persistence 999
    print $ persistence 4
    print $ persistence' 999
