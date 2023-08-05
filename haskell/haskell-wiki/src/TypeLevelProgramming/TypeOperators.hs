{-# LANGUAGE NoStarIsType  #-}
{-# LANGUAGE TypeOperators #-}

module TypeLevelProgramming.TypeOperators where


-- The element of the sum is a value of either left or right type.
data a + b
  = Inl a
  | Inr b
  deriving (Show)


-- The element of the product contains values of both left and right types.
data a * b =
  a :*: b
  deriving (Show)

infixl 6 +

infixl 7 *


-- we have types like Bool + Int or String * Maybe Integer with values like Inl False or "Hello" :*: Nothing,
first :: a * b -> a
first (a :*: _) = a

second :: a * b -> b
second (_ :*: b) = b

val1 :: Int + Bool * Bool
val1 = Inl 0

val2 :: Int + Bool * Bool
val2 = Inr (True :*: False)

type Point a = a + a * a + a * a * a

zero2D :: Point Int
zero2D = Inl (Inr (0 :*: 0))
