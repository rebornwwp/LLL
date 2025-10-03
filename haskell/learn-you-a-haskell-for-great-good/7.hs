import           Data.Char
import           Data.List hiding ((.))
import qualified Data.Map
import qualified Data.Map  as M
--import           Data.List (nub, sort)  部分加载

-- nub remove replication
numUniques :: (Eq a) => [a] -> Int
numUniques = length . nub

-- haskell的惰性并不是总是好的，面对较大list的时候可能不会立即跟新塞满堆栈，此时可以抛弃惰性，重构相同功能代码的到严格版本.

search :: (Eq a) => [a] -> [a] -> Bool
search needle haystack =
  let nlen = length needle
  in foldl (\acc x -> ((take nlen x == needle) || acc)) False (tails haystack)

main = do
  print $ numUniques [1, 2, 2, 3, 3, 4, 4]
  print $ numUniques [1, 2, 2, 3, 3, 4, 4]
  print $ intersperse '.' "CODEMONKEY"
  print $ intercalate " " ["hey", "there", "guys"]
  print $ intercalate [0,0,0] [[1,2,3],[4,5,6],[7,8,9]]
  print $ transpose [[1,2,3],[4,5,6],[7,8,9]]
  print $ map sum $ transpose [[1,2,3],[4,5,6],[7,8,9]]
  -- 非惰性版本
  print $ concat ["foo", "bar", "car"]
  print $ concat [[1,2,3],[4,5,6],[7,8,9]]
  print $ concatMap (replicate 4) [1,2,3]
  print $ and $ map (>4) [1..5]
  print $ all (>4) [1..5]
  print $ or $ map (>4) [1..5]
  print $ any (>4) [1..5]
  print $ splitAt 3 "hello world"
  print $ splitAt 100 "hello world"
  print $ splitAt (-3) "hello world"
  print $ let (a, b) = splitAt 5 "hello world" in b ++ a
  print $ takeWhile (<3) [1..10]
  print $ takeWhile (/=' ') "this is a sentence"
  print $ dropWhile (/=' ') "this is a sentence"
  print $ let (fw, rest) = span (/=' ') "this is a sentence" in "First word:" ++ fw ++ ", the rest:" ++ rest
  print $ sort [10 .. 1]
  print $ group [1,1,1,1,2,2,2,2,3,3,2,2,2,5,6,7]
  print $ map (\l@(x:xs) -> (x, length l)) . group . sort $ [1,1,1,1,2,2,2,2,3,3,2,2,2,5,6,7]
  print $ inits "w00t"
  print $ tails "w00t"
  print $ "cat" `isInfixOf` "im a cat burglar"
