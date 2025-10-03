module Rot13 where

{-
ROT13 is a simple letter substitution cipher that replaces a letter with the letter 13
letters after it in the alphabet. ROT13 is an example of the Caesar cipher.

caesar

Create a function that takes a string and returns the string ciphered with Rot13. If there are
numbers or special characters included in the string, they should be returned as they are.
Only letters from the latin/english alphabet should be shifted, like in the original
Rot13 "implementation".

Please note that using "encode" in Python is considered cheating.
-}

import           Data.Char

rot13 :: String -> String
rot13 = map f
  where
    lowerLetter = ['a'..'z']
    lowerHash = zip lowerLetter (drop 13 $ cycle lowerLetter)
    upperLetter = ['A'..'Z']
    upperHash = zip upperLetter (drop 13 $ cycle upperLetter)
    f :: Char -> Char
    f c | isAsciiLower c = let (Just y) = lookup c lowerHash in y
        | isAsciiUpper c = let (Just y) = lookup c upperHash in y
        | otherwise = c

main :: IO ()
main = do
  print $ rot13 "test"
  print $ rot13 "Test"

