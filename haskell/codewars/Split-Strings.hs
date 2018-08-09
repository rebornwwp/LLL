module Codewars.Kata.SplitStrings where

{-
Complete the solution so that it splits the string into pairs of two characters.
If the string contains an odd number of characters then it should replace the
missing second character of the final pair with an underscore ('_').

Examples:

solution "abc" `shouldBe` ["ab", "c_"]
solution "abcdef" `shouldBe` ["ab", "cd", "ef"]
-}

import           Data.List.Split (chunksOf)
solution, solution2 :: String -> [String]
solution []       = []
solution [x]      = [x : "_"]
solution (x:y:ss) = [x : y : ""] ++ solution ss

solution2 = takeWhile ((2 ==) . length) . chunksOf 2 . (++ "_")

main = do
  print $ solution "abc"
  print $ solution "abcdef"
  print $ solution2 "abd"
  print $ solution2 "abcdef"

