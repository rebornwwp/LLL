module Main where

length' :: [a] -> Int
length' [] = 0
length' (_:xs) = 1 + length' xs

main :: IO ()
main = do
  print $ length' [1..10]
  print $ length [1..10]
