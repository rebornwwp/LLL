module Sort where

import Data.List (sortBy)
import Data.Ord (comparing)

sortByLength :: Ord a => [[a]] -> [[a]]
sortByLength = sortBy (comparing length) 

main = do
  print $ sortByLength [[2,3,4], [3,2], [5]]
  print $ sortByLength ["hello", "hh", "a", "hello world"]