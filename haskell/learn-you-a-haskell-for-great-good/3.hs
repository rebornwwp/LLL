module Main where

-- type 类型命名必须是以大写开始
removeNonUppercase :: String -> String
removeNonUppercase st = [c | c <-st, c `elem` ['A'..'Z']]

addThree :: Int->Int->Int->Int
addThree a b c = a+b+c

factorial :: Integer->Integer
factorial n = product [1..n]

circumference' :: Double -> Double
circumference' r = 2*pi*r


-- type variables 类型变量命名必须是以小写的开始，约定是单个字符
maximum' :: (Ord a) => [a] -> a
maximum' []     = error "maximum a empty list."
maximum' [x]    = x
maximum' (x:xs) = max x (maximum' xs)

repeat' :: a -> [a]
repeat' x = x : repeat' x

reverse' :: [a] -> [a]
reverse' []     = []
reverse' (x:xs) = reverse' xs ++ [x]

replicate' :: (Num i, Ord i) => i -> a -> [a]
replicate' n x
  | n <= 0 = []
  | otherwise = x : replicate' (n - 1) x

take' :: (Num i, Ord i) => i -> [a] -> [a]
take' n x
  | n <= 0 = []
take' _ [] = []
take' n (x:xs) = x : take' (n - 1) xs

zip' :: [a] -> [b] -> [(a, b)]
zip' _ []          = []
zip' [] _          = []
zip' (x:xs) (y:ys) = (x, y) : zip' xs ys

elem' :: (Eq a) => a -> [a] -> Bool
elem' x [] = False
elem' x (y:ys)
  | x == y = True
  | otherwise = x `elem'` ys

quicksort :: (Ord a)=>[a] ->[a]
quicksort []=[]
quicksort (x:xs) =
  let smallerSorted = quicksort [a|a<-xs, a<=x]
      biggerSorted = quicksort [a|a<-xs, a>x]
  in smallerSorted ++ [x] ++ biggerSorted

main = do
  print $ removeNonUppercase "hello WORLD!"
  print $ addThree 1 2 3
  print $ factorial 10
  print $ circumference' 10
  print $ maximum' [1 .. 10]
  print $ reverse' "char"
  print $ replicate' 5 'x'
  print $ replicate' 5 "char"
  print $ take' 2 "char"
  print $ take' 5 "char"
  print $ zip' [1 .. 10] [2 .. 11]
  print $ 2 `elem'` [1 .. 10]
