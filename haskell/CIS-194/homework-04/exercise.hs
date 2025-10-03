module Main where

-- exercise 1
fun1, fun1' :: [Integer] -> Integer
fun1 [] = 1
fun1 (x:xs)
    | even x    = (x - 2) * fun1 xs
    | otherwise = fun1 xs

fun1' = product . map (\x -> x - 2) .filter even

fun2, fun2' :: Integer -> Integer
fun2 1 = 0
fun2 n
  | even n = n + fun2 (n `div` 2)
  | otherwise = fun2 (3 * n + 1)

fun2' = sum . filter even . takeWhile (> 1) . iterate (\x -> if even x then x `div` 2 else x * 3 + 1)

-- exercise 2
data Tree a = Leaf
            | Node Integer (Tree a) a (Tree a)
              deriving (Show, Eq)

foldTree :: [a] -> Tree a
foldTree [] = Leaf
foldTree xs = Node height 
            (foldTree $ take half xs) 
            (xs !! half)
            (foldTree $ drop (half + 1) xs)
        where 
            len = length xs
            half = len `div` 2
            height = floor (logBase 2 (fromIntegral len)::Double)

-- exercise 3
xor :: [Bool] -> Bool
xor = foldl (\x y -> (not x && y) || (x && not y)) False

map' :: (a -> b) -> [a] -> [b]
map' f = foldr (\x acc -> f x : acc) []

myFoldl :: (a -> b -> a) -> a -> [b] -> a
myFoldl f base xs = foldr (flip f) base xs

-- exercise 4
sieveSundaram :: Integer -> [Integer]
sieveSundaram n = map (\x -> 2 * x + 1) $ filter (\x -> x `notElem` removes) [1..n]
  where
    removes =
      [ i + j + 2 * i * j
      | i <- [1 .. n]
      , j <- [1 .. n]
      , i >= 0
      , i <= j
      , i + j + 2 * i * j < n
      ]

main :: IO ()
main = do
  print $ fun1 [4..10]
  print $ fun1' [4..10]
  print $ fun2' 10
  print $ xor [True, False, True, True]
  print $ map' (*2) [1,2,3,4,5]
  print $ myFoldl (+) 0 [1..10]
  print $ sieveSundaram 100
  print $ foldTree "ABCDEFGHIJ"
