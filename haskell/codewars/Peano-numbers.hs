module Haskell.Codewars.Peano where

{-
Peano numbers are a simple way of representing the natural numbers using only a zero value and a successor function. In Haskell, it is easy to create a type of Peano number values:

data Peano = Zero | Succ Peano
Here, Zero and Succ are constructors:

Zero :: Peano
Succ :: Peano -> Peano
where:

0 is represented by Zero
1 is represented by Succ Zero
2 is represented by Succ (Succ Zero)
3 is represented by Succ (Succ (Succ Zero))
etc.
Your mission in this Kata is to implement the following operations with peano numbers:

add Addition
sub Subtract (error: "negative number")
mul Multiplication
div Integer division (error: "divide by 0")
even Even number
odd Odd number
compare Compare (LT, GT or EQ)
using only these functions and not.
-}

import           Prelude hiding (Double, Float, Int, Integer, Num, Rational,
                          Word, compare, div, even, odd)

data Peano = Zero | Succ Peano deriving (Eq, Show)

add, sub, mul, div :: Peano -> Peano -> Peano
-- Addition
add Zero x     = x
add x Zero     = x
add x (Succ p) = add (Succ x) p

-- Subtraction
sub x Zero            = x
sub Zero _            = error "negative number"
sub (Succ x) (Succ y) = sub x y

-- Multiplication
mul Zero _ = Zero
mul _ Zero = Zero
mul x y = f x y $ Zero
  where
    f x (Succ Zero) = add x
    f x (Succ y)    = f x y . add x

-- Integer division
div _ Zero = error "divide by 0"
div x (Succ Zero) = x
div x y    = f x y $ Zero
  where
    f x y = if compare x y == LT then id else f (sub x y) y . add (Succ Zero)

even, odd :: Peano -> Bool
-- Even
even Zero        = True
even (Succ Zero) = False
even x           = even (sub x (Succ (Succ Zero)))

-- Odd
odd = not . even

compare :: Peano -> Peano -> Ordering
-- Compare
compare Zero (Succ _)     = LT
compare Zero Zero         = EQ
compare (Succ _) Zero     = GT
compare (Succ x) (Succ y) = compare x y

main = do
  print $ add (Succ Zero) (Succ Zero)
  print $ div (Succ (Succ (Succ Zero))) (Succ (Succ Zero))
  print $ div (Succ Zero) Zero
