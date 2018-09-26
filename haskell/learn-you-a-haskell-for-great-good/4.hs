module Main where

lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER SEVEN"
lucky x = "Sorry, you're out of luck, pal"

sayMe :: (Integral a) => a -> String
sayMe 1 = "one"
sayMe 2 = "two"
sayMe 3 = "three"
sayMe 4 = "four"
sayMe 5 = "five"
sayMe x = "not between 1 and 5!"

factorial :: (Integral a) => a -> a
factorial 0 = 1
factorial n = n * factorial (n - 1)

charName :: Char -> String
charName 'a' = "Albert"
charName 'b' = "Broseph"
charName 'c' = "Cecil"

addVector :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVector a b = (fst a + fst b, snd a + snd b)

addVector' :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVector' (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

-- 前后类型相同
first :: (a, b, c) -> a
first (x, _, _) = x

second :: (a, b, c) -> b
second (_, y, _) = y

third :: (a, b, c) -> c
third (_, _, z) = z

head' :: [a] -> a
head' []     = error "Can't call head on an empty list, dummy"
head' (x:xs) = x

tell :: (Show a) => [a] -> String
tell [] = "The list is empty"
tell [x] = "The list has one element: " ++ show x
tell [x, y] = "The list has two elements: " ++ show x ++ " and " ++ show y
tell (x:y:_) =
  "This list is long. The first two elements are: " ++
  show x ++ " and " ++ show y

length' :: (Num b) => [a] -> b
length' []     = 0
length' (_:xs) = 1 + length' xs

sum' :: (Num a) => [a] -> a
sum' []     = 0
sum' (x:xs) = x + sum' xs

capital :: String -> String
capital ""         = "Empty string, whoops!"
capital all@(x:xs) = "the first letter of " ++ all ++ " is " ++ [x]

-- guard, where and let
-- where是语法结构
-- let为是表达式
bmiTell :: (RealFloat a) => a -> a -> String
bmiTell weight height
  | bmi <= skinny = "You're underweight, you emo, you!"
  | bmi <= normal = "You're supposedly normal. Pffft, I bet you're ugly!"
  | bmi <= fat = "You're fat! Lose some weight, fatty!"
  | otherwise = "You're a whale, congratulations!"
  where
    bmi = weight / height ^ 2
    (skinny, normal, fat) = (18.5, 25.0, 30.0)

initials :: String -> String -> String
initials firstname lastname = [f] ++ ". " ++ [l] ++ "."
  where
    (f:_) = firstname
    (l:_) = lastname

calcBmis :: (RealFloat a) => [(a, a)] -> [a]
calcBmis xs = [bmi w h | (w, h) <- xs]
  where
    bmi weight height = weight / height ^ 2

calcBmis' :: (RealFloat a) => [(a, a)] -> [a]
calcBmis' xs =
  [bmi w h | (w, h) <- xs, let bmi w h = w / h ^ 2, bmi w h >= 25.0]

cylinder :: (RealFloat a) => a -> a -> a
cylinder r h =
  let sideArea = 2 * pi * r * h
      topArea = pi * r ^ 2
   in sideArea + 2 * topArea

max' :: (Ord a) => a -> a -> a
max' a b
  | a > b = a
  | otherwise = b

myCompare :: (Ord a) => a -> a -> Ordering
a `myCompare` b
  | a > b = GT
  | a == b = EQ
  | otherwise = LT

-- case expressions                                                                                                                                                       [16/125]
-- case expression of pattern -> result
--                    pattern -> result
--                    pattern -> result
--                    ...
head1 :: [a] -> a
head1 xs =
  case xs of
    []     -> error "No head for empty lists!"
    (x:xs) -> x

describeList :: [a] -> String
describeList xs =
  "The list is " ++
  case xs of
    []  -> "empty."
    [x] -> "a singleton list."
    xs  -> "a longer list."

describeList' :: [a] -> String
describeList' xs = "The list is " ++ what xs
  where
    what []  = "empty."
    what [x] = "a singleton list."
    what xs  = "a longer list."

main = do
  print $ lucky 7
  print $ lucky 8
  print $ sayMe 10
  print $ sayMe 5
  print $ factorial 10
  print $ factorial 0
  print $ charName 'a'
  print $ charName 'b'
  print $ addVector (1, 2) (3, 4)
  print $ addVector' (1, 2) (3, 4)
  print $ head' [1 .. 2]
  print $ head' "hello world"
  print $ tell ["wang", "zhang", "li", "sun"]
  print $ length' [1 .. 10]
  print $ sum' [1 .. 10]
  print $ capital ""
  print $ capital "hello world"
  print $ bmiTell 20 165
  print $ max' 1 10
  print $ 3 `myCompare` 5
  print $ initials "wang" "wanpeng"
  print $ describeList []
  print $ describeList' ['a']
  print $ describeList' [1 .. 10]
