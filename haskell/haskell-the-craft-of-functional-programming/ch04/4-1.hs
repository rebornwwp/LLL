module Main where

import Test.HUnit
import Test.QuickCheck hiding (Result)

maxThree :: Integer -> Integer -> Integer -> Integer
maxThree x y z = max (max x y) z

maxFour :: Integer -> Integer -> Integer -> Integer -> Integer
maxFour a b c d =  max (maxThree a b c) d

between :: Integer -> Integer -> Integer -> Bool
between a b c = (a <= b && b <= c) || (a >= b && b >= c)

howManyEqual :: Integer -> Integer -> Integer -> Integer
howManyEqual a b c
  | a == b && b == c = 3
  | a == b = 2
  | b == c = 2
  | a == c = 2
  | otherwise = 0

howManyOfFourEqual :: Integer -> Integer -> Integer -> Integer -> Integer
howManyOfFourEqual a b c d
  | a == b && b == c && c == d = 4
  | otherwise =
    maxFour
      (howManyEqual a b c)
      (howManyEqual a b d)
      (howManyEqual b c d)
      (howManyEqual a c d)

isOdd, isEven :: Int -> Bool
isOdd n
  | n <= 0 = False
  | otherwise = isEven (n - 1)

isEven n
  | n < 0 = False
  | n == 0 = True
  | otherwise = isOdd (n - 1)

data Move = Rock | Paper | Scissors
  deriving (Show, Eq)

data Result = Win | Lose | Draw
  deriving (Show, Eq)

beat :: Move -> Move
beat Rock     = Paper
beat Paper    = Scissors
beat Scissors = Rock

lose :: Move -> Move
lose Rock     = Scissors
lose Paper    = Rock
lose Scissors = Paper

outCome :: Move -> Move -> Result
outCome x y =
  case (x, y) of
    (Rock, Rock) -> Draw
    (Rock, Paper) -> Lose
    (Rock, Scissors) -> Win
    (Scissors, Scissors) -> Draw
    (Scissors, Rock) -> Lose
    (Scissors, Paper) -> Win
    (Paper, Paper) -> Draw
    (Paper, Scissors) -> Lose
    (Paper, Rock) -> Win

testRPS = TestList [
    TestCase (assertEqual "rock beats scissors"  Win (outcome Rock Scissors)),
    TestCase (assertEqual "paper beats rock"  Win (outcome Paper Rock)),
    TestCase (assertEqual "scissors beats paper"  Win (outcome Scissors Paper)),
    TestCase (assertEqual "scissors loses to rock" Lose (outcome Scissors Rock)),
    TestCase (assertEqual "rock loses to paper" Lose (outcome Rock Paper)),
    TestCase (assertEqual "paper loses to scissors" Lose (outcome Paper Scissors)),
    TestCase (assertEqual "draw Scissors" Draw (outcome Scissors Scissors)),
    TestCase (assertEqual "draw Paper" Draw (outcome Paper Paper)),
    TestCase (assertEqual "draw Rock" Draw (outcome Rock Rock))
]

data Temp = Cold | Hot
  deriving (Dq,Show, Ord)

data Month = January | February | March | April | May | June | July | August | September | October | November | December
  deriving (Show, Eq, Ord)

data Season = Spring | Summer | Autumn | Winter
  deriving (Show, Eq, Ord)

temperatureIn :: Season -> Temp
temperatureIn Spring = Cold
temperatureIn Summer = Hot
temperatureIn Autumn = Cold
temperatureIn Winter = Cold

seasonIn :: Month -> Season
seasonIn month
  | month <= March = Spring
  | month <= June = Summer
  | month <= September = Autumn
  | otherwise = Winter

fac :: Integer -> Integer
fac n
  | n == 0 = 1
  | n > 0 = fac (n - 1) * n

rangeProduct :: Integer -> Integer
rangeProduct m n
  | m > n = 0
  | otherwise = product [m, m + 1 ... n]

remainder m n
  | m < n = m
  | otherwise = remainder (m - n) n

divide m n
  | m < n = 0
  | otherwise = 1 + divide (m - n) n
