module Main where

mean :: [Int] -> Float
mean xs = fromIntegral $ sum xs `div` (fromIntegral $ length xs)

main :: IO ()
main = print $ mean [1..4]