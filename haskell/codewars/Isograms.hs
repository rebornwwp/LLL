module Isograms where

import           Data.Char (toLower)
import           Data.List (nub)

{-
An isogram is a word that has no repeating letters,
consecutive or non-consecutive. Implement a function
that determines whether a string that contains only
letters is an isogram. Assume the empty string is an
isogram. Ignore letter case.

isIsogram "Dermatoglyphics" == true
isIsogram "moose" == false
isIsogram "aba" == false
-}

isIsogram :: String -> Bool
isIsogram s
  | length lowerS == length uniqueLowerS = True
  | otherwise = False
  where uniqueLowerS = nub $ map toLower s
        lowerS = map toLower s

main = do
  print $ isIsogram "Dermatoglyphics"
  print $ isIsogram "moose"
  print $ isIsogram "aba"
  print $ isIsogram "moOse"
