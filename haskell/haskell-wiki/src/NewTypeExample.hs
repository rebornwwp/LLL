{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module NewTypeExample
  ( main1
  ) where

newtype Velocity =
  Velocity
    { unVelocity :: Double
    }
  deriving (Eq, Ord, Num, Show)

v :: Velocity
v = Velocity 2.710

x :: Double
x = 1.100

v1 :: Velocity
v1 = Velocity 1.000

-- Type error is caught at compile time even though
-- they are the same value at runtime!
-- y = v + x
-- When Velocity is not a instance of Num class, so Velocity can't use +
z = v + v1

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

main1 :: IO ()
main1 = do
  print z

