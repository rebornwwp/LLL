module PickPeak.JorgeVS.Kata where

{-
In this kata, you will write a function that returns the positions and the
values of the "peaks" (or local maxima) of a numeric array.

For example, the array arr = [0, 1, 2, 5, 1, 0] has a peak at position 3
with a value of 5 (since arr[3] equals 5).

The output will be returned as an object with two properties: pos and peaks.
Both of these properties should be arrays. If there is no peak in the given
array, then the output should be {pos: [], peaks: []}.

Example: pickPeaks([3, 2, 3, 6, 4, 1, 2, 3, 2, 1, 2, 3]) should return
{pos: [3, 7], peaks: [6, 3]} (or equivalent in other languages)

All input arrays will be valid integer arrays (although it could still
be empty), so you won't need to validate the input.

The first and last elements of the array will not be considered as peaks
(in the context of a mathematical function, we don't know what is after
and before and therefore, we don't know if it is a peak or not).

Also, beware of plateaus !!! [1, 2, 2, 2, 1] has a peak while [1, 2, 2, 2, 3]
does not. In case of a plateau-peak, please only return the position and value
of the beginning of the plateau. For example: pickPeaks([1, 2, 2, 2, 1])
returns {pos: [1], peaks: [2]} (or equivalent in other languages)

Have fun!
-}

import           Data.Function (on, (&))
import           Data.List     (groupBy)
import           Data.Tuple    (swap, uncurry)

data PickedPeaks = PickedPeaks
  { pos   :: [Int]
  , peaks :: [Int]
  } deriving (Eq, Show)

-- 注意重复的值对结题的误导，需要将带有相邻重复值的list变成转换成不带有相邻重复值的list->转化成等价问题
-- 不然容易被带入边界问题里面
pickPeaks :: [Int] -> PickedPeaks
pickPeaks s = PickedPeaks (map fst ps) (map snd ps)
  where
    picks :: [(Int, Int)] -> [(Int, Int)]
    picks [] = []
    picks [_] = []
    picks [_, _] = []
    picks (x:y:z:res)
      | snd x < snd y && snd y >= snd z = y : picks (y : z : res)
      | otherwise = picks (y : z : res)
    neighborDuplication :: [(Int, Int)] -> [(Int, Int)]
    neighborDuplication =
      foldl
        (\acc (x, y) ->
           if null acc
             then acc ++ [(x, y)]
             else if (snd $ last acc) /= y
                    then acc ++ [(x, y)]
                    else acc)
        []
    ps = picks $ neighborDuplication $ zip [0 ..] s

pickPeaks' :: [Int] -> PickedPeaks
pickPeaks' ls = [b | (a,b,c) <- zip3 xs (tail xs) (drop 2 xs), a<b && b>c] & unzip & swap & uncurry PickedPeaks
    where xs = zip ls [0..] & groupBy (on (==) fst) & map head

main :: IO ()
main = do
  print $ pickPeaks [3, 2, 3, 6, 4, 1, 2, 3, 2, 1, 2, 3]
  print $ pickPeaks [1, 2, 2, 2, 1]
  print $ pickPeaks [0, 1, 2, 5, 1, 0]
  print $ pickPeaks [0, 1, 2, 2, 2]

