module Golf where

import Data.List

-- exercise 1
skip :: Int -> [a] -> [a]
skip n = map snd . filter (\x -> fst x `mod` n == 0) . zip [1 ..]

skips :: [a] -> [[a]]
skips xs =
  zipWith 
  ($) {-zipWith的函数-}
  (map skip [1 ..]) {- 函数的list-}
  $ replicate (length xs) xs

-- exercise 2
localMaxima :: [Integer] -> [Integer]
localMaxima [_, _] = []
localMaxima (x:y:z:xs)
  | y > x && y > z = y : (localMaxima $ y : z : xs)
  | otherwise = localMaxima $ y : z : xs


-- exercise 3
counter :: [Integer] ->(Int, [(Integer, Int)])
counter xs = (maxCount, counts)
  where
  counts = map (\x -> (head x, length x - 1)) . group . sort $ xs ++ [0 .. 9]
  maxCount = maximum $ map snd counts

histo :: Int -> (Integer, Int) -> String
histo n (i, m) = show i ++ "=" ++ replicate m '*' ++ replicate (n-m) ' '

histogram :: [Integer] -> String
histogram xs = let (n, cs) = counter xs
               in unlines $ reverse $ transpose $ map (histo n) cs

main :: IO ()
main = do
  print $ skips "hello!"
  print $ localMaxima [2, 9, 5, 6, 1]
  print $ localMaxima [2,3,4,1,5]
  print $ localMaxima [1,2,3,4,5]
  putStr $ histogram [0,1,4,5,4,6,6,3,4,2,4,9,0]
