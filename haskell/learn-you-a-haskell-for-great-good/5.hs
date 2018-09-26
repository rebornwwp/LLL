module Main where

maximum' :: (Ord a) => [a] -> a
maximum' [] = error "maximum of empty list."
maximum' [x] = x
maximum' (x:xs)
  | x > maxTail = x
  | otherwise = maxTail
  where maxTail = maximum' xs

maximum1 :: (Ord a) => [a] -> a
maximum1 []     = error "maximum of empty list."
maximum1 [x]    = x
maximum1 (x:xs) = max x $ maximum1 xs

replicate' :: (Num i, Ord i) => i -> a -> [a]
replicate' n x
  | n <= 0 = []
  | otherwise = x:replicate' (n-1) x

take' :: (Num i, Ord i) => i -> [a] -> [a]
take' n _
    | n <= 0 = []
take' _ [] = []
take' n (x:xs) = x : take' (n-1) xs

-- 无限list
repeat' :: a -> [a]
repeat' x = x : repeat' x

zip' :: [a] -> [b] -> [(a, b)]
zip' _ []          = []
zip' [] _          = []
zip' (x:xs) (y:ys) = (x, y) : zip' xs ys

elem' :: (Eq a) => a -> [a] -> Bool
elem' a [] = False
elem' a (x:xs)
  | a == x = True
  | otherwise = a `elem'` xs

quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
  let smallerSorted = quicksort [a | a <- xs, a <= x]
      biggerSorted = quicksort [a | a <- xs, a > x]
  in smallerSorted ++ [x] ++ biggerSorted

main = do
  print $ maximum' [1,2,3,10,5]
  print $ maximum1 [1,2,3,10,5]
  print $ replicate' 4 4
  print $ take' 4 [1 .. 10]
  print $ take' 4 $ repeat' 4
  print $ zip' [1..10] [1..5]
  print $ 4 `elem'` [1 .. 10]
  print $ quicksort [10,9 .. 1]

