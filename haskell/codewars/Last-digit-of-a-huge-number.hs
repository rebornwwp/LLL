module LastDigit (lastDigit) where

{-
For a given list [x1, x2, x3, ..., xn] compute the last (decimal) digit of x1 ^ (x2 ^ (x3 ^ (... ^ xn))).

E. g.,

lastDigit [3, 4, 2] == 1
because 3 ^ (4 ^ 2) = 3 ^ 16 = 43046721.

Beware: powers grow incredibly fast. For example, 9 ^ (9 ^ 9) has more than 369 millions of digits. lastDigit has to deal with such numbers efficiently.

Corner cases: we assume that 0 ^ 0 = 1 and that lastDigit of an empty list equals to 1.

This kata generalizes Last digit of a large number; you may find useful to solve it beforehand.
-}

{-
学习材料：https://brilliant.org/wiki/finding-the-last-digit-of-a-power/

x ^ (4n+a) ^ n 将问题分解成两个问题，一个是x ^ m 和 m = (4n+a) ^ n --- 为什么选择4为底可以看讲义。
x ^ m 这个问题很容易解决

m = (4n+a) ^ n --> a^n + C(n, 1) * a^(n-1) * 4 ......
so m (mod 4) = a ^ n (mod 4)
so the answer is
I: a = 0;
     n = 0; answer = 1
     n = other; answer = 0 ---> alternative is 4
II: a = 1; any n; answer = 1
III: a = 2; answer = 2 ^ n (mod 4)
       n = 0; answer = 1
       n = 1; answer = 2
       n > 1; answer = 0 ---> alternative is 4
IIII: a = 3; answer = 3 ^ n (mod 4) = (4-1) ^ n (mod 4) = (-1) ^ n (mod 4)
        n = odd number; answer = 3
        n = even number; answer = 1
-}

lastDigit :: [Integer] -> Integer
lastDigit [] = 1
lastDigit (x:xs) = (`mod` 10) . ((x `mod` 10) ^) . f $ xs
  where
    f [] = 1
    f (0:xs) = if isZero xs then 1 else 0
    f (x:xs) = case x `mod` 4 of
                 1 -> 1
                 2 | isZero xs -> 1
                   | isOne xs -> 2
                   | otherwise -> 4
                 0 | isZero xs -> 1
                   | otherwise -> 4
                 3 | isOdd xs -> 3
                   | otherwise {- alternative isEven -} -> 1
    isZero [] = False
    isZero (0:xs) = not (isZero xs)
    isZero(x:xs) = False
    isOne [] = True
    isOne (1:_) = True
    isOne (_:xs) = isZero xs
    isOdd [] = True
    isOdd (x:xs) = odd x || isZero xs



main = do
  print $ lastDigit [3, 4, 2]
  print $ lastDigit [9, 9, 9]
  print $ lastDigit []
  print $ lastDigit [0, 0]
  print $ lastDigit [0, 0, 0]
  print $ lastDigit [1, 2]
  print $ lastDigit [12, 18]
  print $ lastDigit [8, 21]
  print $ lastDigit [3, 4, 5]
  print $ lastDigit [4, 3, 6]
  print $ lastDigit [7, 6, 21]
  print $ lastDigit [7, 11, 2]
  print $ lastDigit [12, 30, 21]
  print $ lastDigit [2, 2, 2, 0]
  print $ lastDigit [937640, 767456, 981242]
  print $ lastDigit [123232, 694022, 140249]
  print $ lastDigit [499942, 898102, 846073]
