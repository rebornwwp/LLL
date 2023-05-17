-- {-# LANGUAGE GeneralizedNewtypeDeriving #-}
module NewTypeExample where

newtype Velocity =
  Velocity
    { unVelocity :: Double
    }
  deriving (Eq, Ord)

v :: Velocity
v = Velocity 2.710

x :: Double
x = 1.100

-- y = v + x
newtype Quantity v a =
  Quantity a
  deriving (Eq, Ord, Num, Show)

data Haskeller

type Haskellers = Quantity Haskeller Int

a :: Haskellers
a = Quantity 2 :: Haskellers

b :: Haskellers
b = Quantity 6 :: Haskellers

totalHaskellers :: Haskellers
totalHaskellers = a + b
