module Codewars.UniqueSeries where

{-
Consider a series that has the following property:

0,1,2,3,4,5,6,7,8,9,10,22,11,20..There is nothing special between numbers 0 and 10. For all other numbers, the next element in the series is the lowest number that doesn't contain any digits of the previous one, and is not already in the series.

For instance, the number 10 has digits 1 and 0. The smallest number before or after 10 that does not have 1 or 0 and is not already in the series is 22. Similarly, the smallest number before or after 22 that has not yet appeared in the series and that has no 2 is 11. Once a number appers in the series, it cannot appear again.

You will be given an index number and your task will be return the element at that position. See test cases for more examples.

Note that the test range is n <= 500.

Good luck!

If you like this Kata, please try:

Sequence convergence

https://www.codewars.com/kata/unique-digit-sequence-ii-optimization-problem
-}

series :: [Integer]
series = 0 : go 1
  where
    go :: Int -> [Integer]
    go n = [head $ filter (\x -> notContain (series !! (n - 1)) x && notElem x (take n series)) [0 ..]] ++ go (n + 1)
    notContain x y = all (flip notElem (show y)) $ show x

findNum :: Int -> Integer
findNum n = series !! n

main = do
  print $ take 30 series
