module LastDigit where

{-
Define a function

lastDigit :: Integer -> Integer -> Integer
that takes in two numbers a and b and returns the last decimal digit of a^b. Note that a and b may be very large!

For example, the last decimal digit of 9^7 is 9, since 9^7 = 4782969. The last decimal digit of (2^200)^(2^300), which has over 10^92 decimal digits, is 6.

The inputs to your function will always be non-negative integers.

Examples

lastDigit 4 1             `shouldBe` 4
lastDigit 4 2             `shouldBe` 6
lastDigit 9 7             `shouldBe` 9
lastDigit 10 (10^10)      `shouldBe` 0
lastDigit (2^200) (2^300) `shouldBe` 6
Remarks

JavaScript

Since JavaScript doesn't have native arbitrary large integers, your arguments are going to be strings representing non-negative integers, e.g.

lastDigit("10", "10000000000");
The kata is still as hard as the variants for Haskell or Python, don't worry.
-}

digitsMap =
  [ [0]
  , [1]
  , [6, 2, 4, 8]
  , [1, 3, 9, 7]
  , [6, 4]
  , [5]
  , [6]
  , [1, 7, 9, 3]
  , [6, 8, 4, 2]
  , [1, 9]
  ]

lastDigit :: Integer -> Integer -> Integer
lastDigit _ 0 = 1
lastDigit a b = baseList !! (fromIntegral (b `mod` toInteger (length baseList)))
  where
    baseList = digitsMap !! fromIntegral (a `mod` 10)


main = do
  print $ lastDigit 4 1
  print $ lastDigit 4 2
  print $ lastDigit 9 7
  print $ lastDigit 10 (10^10)
  print $ lastDigit (2^200) (2^300)
  print $ lastDigit 10 0

