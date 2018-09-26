module Main where

doubleMe x = x * 2

doubleUs x y = x * 2 + y * 2

doubleSmallNumber x = if x > 100 then x else x * 2

main = do
  print $ doubleMe 20
  print $ doubleUs 4 5
  print $ doubleSmallNumber 45
  print $ succ 10 + max 5 4 + 1
  -- list入门
  print $ [1 .. 10] ++ [11, 12]
  print $ "hello" ++ " " ++ "world!"
  print $ ['w', 'o'] ++ ['o', 't']
  print $ 'A' : " SMALL CAT"
  print $ 5 : [1 .. 4]
  print $ 1 : 2 : 3 : []
  print $ "hello world" !! 0
  print $ "hello world" !! 1
  print $ "hello world" !! 2
  print $ head [1 .. 5]
  print $ tail [1 .. 5]
  print $ init [1 .. 5]
  print $ last [1 .. 5]
  print $ length [1 .. 5]
  print $ null [1 .. 5]
  print $ null []
  print $ reverse [1 .. 5]
  print $ take 3 [1 .. 5]
  print $ take 0 [1 .. 5]
  print $ drop 3 [1 .. 5]
  print $ minimum [1 .. 5]
  print $ maximum [1 .. 5]
  print $ sum [1 .. 5]
  print $ product [1 .. 5]
  print $ 4 `elem` [1 .. 5]
  -- range
  print [1 .. 10]
  print ['a' .. 'z']
  print [3,6 .. 20]
  print [0.1,0.3 .. 1] -- 少用浮点数
  print $ take 10 (cycle [1, 2, 3])
  print $ take 12 (cycle "LOL ")
  print $ take 10 (repeat 5)
  print $ replicate 3 10
  -- list comprehension
  print [x + 2 | x <- [1 .. 10]]
  print [if x < 10 then "BOOM!" else "BANG!" | x <- [1 .. 20], odd x ]
  print [x | x <- [10 .. 20], x /= 13, x /= 15, x /= 19]
  -- tuple
  print $ fst (3, 8)
  print $ fst (3, 8)
  print $ snd (3, 8)
  print $ zip [1 .. 5] [2 .. 6]
  print $ zip [1 .. 5] ["one", "two", "three", "four", "five"]
  print $ zip [1 ..] ["apple", "orange", "cherry", "mango"]
  print  [ (a, b, c) | c <- [1 .. 10] , b <- [1 .. c] , a <- [1 .. b] , a ^ 2 + b ^ 2 == c ^ 2 , a + b + c == 24 ]
