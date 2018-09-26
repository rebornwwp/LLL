module Main where

{- FirstScript.hs -}

size :: Integer
size = 12 + 13

square :: Integer -> Integer
square n = n * n

double :: Integer -> Integer
double = (*) 2

example :: Integer
example = double (size - square (2 + 2))

