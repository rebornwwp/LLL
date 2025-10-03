import           Data.List
import           Prelude   hiding ((.))

-- 接受函数作为参数和返回函数的作为结果的函数叫做高阶函数,感觉如同数学中的函数一样
-- haskell中所有接受多个参数的函数都是curried functions(高阶函数),下面将用max函数来作为例子
multThree :: (Num a) => a -> a -> a -> a
multThree x y z = x * y * z

compareWithHundred :: (Num a, Ord a) => a -> Ordering
compareWithHundred = compare 100

-- 中缀函数 f(x, -1)
divideByTen :: (Floating a) => a -> a
divideByTen = (/10)

isUpperAlphanum :: Char -> Bool
isUpperAlphanum = (`elem` ['A' .. 'Z'])

subtractByTen :: (Floating a) => a -> a
subtractByTen = subtract 10

-- 函数作为参数
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

-- zip with a function
zipwith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipwith' _ [] _          = []
zipwith' _ _ []          = []
zipwith' f (x:xs) (y:ys) = f x y : zipwith' f xs ys

-- 传入函数输出相似的函数,只是将参数顺序改变了一下
flip' :: (a -> b -> c) -> (b -> a -> c)
flip' f y x = f x y

map' :: (a -> b) -> [a] -> [b]
map' _ []     = []
map' f (x:xs) = f x : map f xs

filter' :: (a -> Bool) -> [a] -> [a]
filter' _ [] = []
filter' f (x:xs)
  | f x = x : filter' f xs
  | otherwise = filter' f xs

largestDivisible :: (Integral a) => a
largestDivisible = head $ filter p [10000,9999..]
    where p x = x `mod` 3829 == 0

-- lambda functions
addThree' :: (Num a) => a -> a -> a -> a
addThree' = \x -> \y -> \z -> x + y + z

chain :: (Integral a) => a -> [a]
chain 1 = [1]
chain n
  | even n = n:chain (n `div` 2)
  | odd n = n:chain (n*3 + 1)

-- 关键字fold
-- foldl函数
sum' :: (Num a) => [a] -> a
sum' xs = foldl (\acc x -> acc + x) 0 xs

sum1' :: (Num a) => [a] -> a
sum1' = foldl (+) 0

-- 左折叠
elem' :: (Eq a) => a -> [a] -> Bool
elem' y = foldl (\acc x -> ((x==y) || acc)) False

maximum' :: (Ord a) => [a] -> a
maximum' = foldr1 (\x acc -> if x > acc then x else acc)

-- $ 函数调用符
-- f (g (z x)) 可以少写括号然后就变成了 f $ g $ z x
(.) :: (b -> c) -> (a -> b) -> a -> c
f . g = \x -> f (g x)

-- 函数为王
oddSquareSum :: Integer
oddSquareSum = sum . takeWhile (<10000) . filter odd . map (^2) $ [1..]


main = do
  print $ max 4 5
  print $ (max 4) 5
  print $ ((multThree 3) 4) 5
  print $ (multThree 3 4) 5
  let multThree_two = multThree 9
  print $ multThree_two 4 5
  print $ compareWithHundred 90
  print $ isUpperAlphanum 'A'
  print $ isUpperAlphanum 'a'
  print $ applyTwice (++ " HAHA") "HEY"
  print $ applyTwice ("HAHA " ++) "HEY"
  print $ applyTwice (3:) [1]
  print $ zipwith' (+) [1 .. 10] [2 .. 11]
  print $ zipwith' (++) ["foo", "bar", "baz"] ["fighters", "hoppers", "aldrin"]
  print $ flip' zip [1 .. 3] ["fighters", "hoppers", "aldrin"]
  print $ map' succ [1 .. 10]
  print $ filter (`elem` ['A' .. 'Z']) "i lauGh At You BecAuse u r aLL the Same"
  -- lambda function
  print $ map (\(a, b) -> a + b) [(1, 2), (3, 5), (6, 3), (2, 6), (2, 5)]
  print $ addThree' 1 3 4
  print $ sum' [1 .. 10]
  print $ subtractByTen 11
  print largestDivisible
  print $ maximum' [2,3,4,10,5]
  print $ scanl (+) 0 [1 .. 10]
  print $ scanr (+) 0 [1 .. 10]
  print $ scanl1 (+) [1 .. 10]
  print $ scanr1 (+) [1 .. 10]
  print $ map (negate . abs) [1, -2, 3, -4, 5, -6]
  print $ map (negate . sum . tail) [[1..5], [2..6], [1..10]]
