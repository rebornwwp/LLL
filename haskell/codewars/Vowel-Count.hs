module Codewars.Kata.Vowel where

{-
Return the number (count) of vowels in the given string.

We will consider a, e, i, o, and u as vowels for this Kata.

The input string will only consist of lower case letters and/or spaces.
-}

isVowel :: Char -> Int
isVowel c
  | cond = 1
  | otherwise = 0
  where
    cond = c `elem` "aeiou"

getCount :: String -> Int
getCount s = sum $ map isVowel s

getCount' :: String -> Int
getCount' = length . filter (`elem` "aeiou")

main :: IO ()
main = print $ getCount "aeiouq"
