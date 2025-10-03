{-# LANGUAGE NoStarIsType  #-}
{-# LANGUAGE TypeOperators #-}

module TypeLevelProgramming.TypeOperators where

-- for about operator symbol:
-- https://typeclasses.com/identifiers-and-operators#type-operators
-- https://typeclasses.com/ghc/type-operators
-- 开启TypeOperators，就可以使用operator symbols 在type level上
-- 不开启，就会在标准haskell下，就只能在value level上使用
-- 对类型做操作，在 type-level 创建新的类型
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

-- type synonyms
-- The value of the Point type may be used to store a point
-- in one-dimensional, twodimensional, or three-dimensional space.
type Point a = a + a * a + a * a * a

zero2D :: Point Int
zero2D = Inl (Inr (0 :*: 0))

testmain :: IO ()
testmain = do
  print val1
  print val2
  print zero2D
