module Main where

-- tuple list

import           Data.Char (isLetter, toUpper)

type ShopItem = (String, Int)
a = ("Salt 1 Kg", 139) :: ShopItem

type Basket = [ShopItem]


minAndMax :: Integer -> Integer -> (Integer, Integer)
minAndMax x y
  | x >= y = (y, x)
  | otherwise = (x, y)

-- pattern mactching
addPair :: (Integer, Integer) -> Integer
addPair (x, y) = x + y

shift :: ((Integer, Integer), Integer) -> (Integer, (Integer, Integer))
shift ((x, y), z) = (x, (y, z))

name :: ShopItem -> String
name = fst

price :: ShopItem -> Int
price = snd

fibStep :: (Integer, Integer) -> (Integer, Integer)
fibStep (u, v) = (v, u + v)

fibPair :: Integer -> (Integer, Integer)
fibPair n
  | n == 0 = (0, 1)
  | otherwise = fibStep (fibPair (n - 1))

fastFib :: Integer -> Integer
fastFib = fst . fibPair

data People = People Name Age
  deriving (Show, Eq)

type Name = String
type Age = Int

showPerson :: People -> String
showPerson (People name age) = name ++ "--" ++ show age

data Shape = Circle Float | Rectangle Float Float
  deriving (Show, Ord, Eq)

area :: Shape -> Float
area (Circle r)      = pi * r * r
area (Rectangle a b) = a * b

addPairs pairList = [m + n | (m, n) <- pairList]

doubleAll :: [Integer] -> [Integer]
doubleAll xs = [x * 2 | x <- xs]

capitalize :: String -> String
capitalize st = [toUpper s | s <- st]

capitalizeLetters :: String -> String
capitalizeLetters st = [toUpper s | s <- st, isLetter s]

divisors :: Integer -> [Integer]
divisors n
  | n <= 0 = []
  | otherwise = [i | i <- [1 .. n], n `mod` i == 0]

isPrime :: Integer -> Bool
isPrime n
  | n <= 1 = False
  | otherwise = length (divisors n) == 2

matches :: Integer -> [Integer] -> [Integer]
matches n xs = [x | x <- xs, x == n]

elem' :: Integer -> [Integer] -> Bool
elem' n xs = length (matches n xs) > 0

onSeparateLines :: [String] -> String
onSeparateLines st = init [c | s <- st, c <- s ++ "\n"]

duplicate' :: String -> Integer -> String
duplicate' s n
  | n <= 0 = ""
  | otherwise = [c | _ <- [1 .. n], c <- s]

pushRight :: String -> String
pushRight s
  | length s > 12 = s
  | otherwise = duplicate' " " (toInteger (linelength - length s)) ++ s
  where
    linelength = 12

type Person = String
type Book = String
type Database = [(Person, Book)]

exampleBase :: Database
exampleBase =
  [ ("Alice", "Tintin")
  , ("Ana", "Little Women")
  , ("Alice", "Asterix")
  , ("Rory", "Tintin")
  ]

books :: Database -> Person -> [Book]
books db findperson = [book | (person, book) <- db, person == findperson]

borrowers :: Database -> Book -> [Person]
borrowers db findbook = [person | (person, book) <- db, book == findbook]

borrowed :: Database -> Book -> Bool
borrowed db findbook = not . null $ borrowers db findbook

numBorrowed :: Database -> Person -> Int
numBorrowed db findperson = length $ books db findperson

makeLoan :: Database -> Person -> Book -> Database
makeLoan db p b = db ++ (p, b)

returnLoad :: Database -> Person -> Book -> Database
returnLoad db p b = [pair | pair <- db, pair /= (p, b)]


main :: IO()
main = do
  putStrLn $ onSeparateLines ["hello", "world"]
  putStrLn $ duplicate' "hello" 2
