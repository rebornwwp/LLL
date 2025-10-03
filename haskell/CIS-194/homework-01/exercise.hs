module Homework1 where

import           Data.Char (digitToInt)
import           Data.List (minimumBy)
import           Data.Ord  (comparing)

-- source http://www.cis.upenn.edu/~cis194/spring13/hw/01-intro.pdf
-- exercise 1
toDigits :: Integer -> [Integer]
toDigits n
  | n <= 0 = []
  | otherwise = toDigits (n `div` 10) ++ [n `mod` 10]

toDigitsRev :: Integer -> [Integer]
toDigitsRev = reverse . toDigits

-- exercise 2
doubleEven :: [Integer] -> [Integer]
doubleEven []     = []
doubleEven (x:xs) = 2 * x : doubleOdd xs

doubleOdd :: [Integer] -> [Integer]
doubleOdd []     = []
doubleOdd (x:xs) = x : doubleEven xs

doubleEveryOther :: [Integer] -> [Integer]
doubleEveryOther = reverse . doubleOdd . reverse

-- exercise 3
sumDigits :: [Integer] -> Integer
sumDigits = sum . map (fromIntegral . digitToInt) . concatMap show

-- exercise 4
validate :: Integer -> Bool
validate n
  | isZero = True
  | otherwise = False
  where
    isZero = (sumDigits . doubleEveryOther . toDigits) n `mod` 10 == 0

-- exercise 5
type Peg = String

type Move = (Peg, Peg)

hanoi :: Integer -> Peg -> Peg -> Peg -> [Move]
hanoi 0 _ _ _ = []
hanoi n a b c = hanoi (n - 1) a c b ++ [(a, b)] ++ hanoi (n - 1) c b a

-- exercise 6
-- http://service.scs.carleton.ca/sites/default/files/tr/TR-04-10.pdf
-- https://gist.github.com/dmgottlieb/56369e01521c61dd00b6
-- n pegs' hanoi tower is based on n-1 pegs' hanoi tower
fourHanoi :: Integer -> Peg -> Peg -> Peg -> Peg -> [Move]
fourHanoi 0 _ _ _ _ = []
fourHanoi 1 src des _ _ = [(src, des)]
fourHanoi n src des t1 t2 =
  shortest
    [ fourHanoi (n - k) src t1 t2 des ++
    hanoi k src des t2 ++ fourHanoi (n - k) t1 des src t2
    | k <- [1 .. n - 1]
    ]

shortest :: [[a]] -> [a]
shortest [] = []
shortest ls = minimumBy (comparing length) ls

main :: IO ()
main = do
  print $ toDigits 1234
  print $ toDigitsRev 1234
  print $ toDigits 0
  print $ toDigits (-10)
  print $ doubleEveryOther [1, 2, 3]
  print $ (sumDigits $ doubleEveryOther [8, 7, 6, 5]) == 0
  print $ validate 4012888888881881
  print $ validate 4012888888881882
  print $ hanoi 2 "a" "b" "c" == [("a", "c"), ("a", "b"), ("c", "b")]
  print $ hanoi 5 "a" "b" "c"
  print $ length $ fourHanoi 15 "a" "b" "c" "d"
