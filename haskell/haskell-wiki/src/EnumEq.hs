{-# LANGUAGE DeriveAnyClass #-}

module EnumEq where

class (Eq a, Enum a, Bounded a) =>
      CircleEnum a
  where
  cpred :: a -> a
  cpred d
    | d == minBound = maxBound
    | otherwise = pred d
  csucc :: a -> a
  csucc d
    | d == maxBound = minBound
    | otherwise = succ d

data Direction
  = North
  | East
  | South
  | West
  deriving (Eq, Enum, Bounded, CircleEnum, Show)

data Turn
  = TNone
  | TLeft
  | TRight
  | TAround
  deriving (Eq, Enum, Bounded, Show)

instance Semigroup Turn where
  TNone <> t         = t
  TLeft <> TLeft     = TAround
  TLeft <> TRight    = TNone
  TLeft <> TAround   = TRight
  TRight <> TLeft    = TNone
  TRight <> TRight   = TAround
  TRight <> TAround  = TLeft
  TAround <> TAround = TNone
  t1 <> t2           = t2 <> t1

instance Monoid Turn where
  mempty = TNone

rotate :: Turn -> Direction -> Direction
rotate TNone   = id
rotate TLeft   = cpred
rotate TRight  = csucc
rotate TAround = csucc . csucc

every :: (Enum a, Bounded a) => [a]
every = enumFrom minBound

orient :: Direction -> Direction -> Turn
-- orient d1 d2 = head $ filter (\t -> rotate t d1 == d2) [TNone .. TAround]
orient d1 d2 = head $ filter (\t -> rotate t d1 == d2) every

rotateMany :: Direction -> [Turn] -> Direction
rotateMany = foldl (flip rotate)

-- use semigroup and monoid feature
rotateMany' :: Direction -> [Turn] -> Direction
rotateMany' dir ts = rotate (mconcat ts) dir

rotateManySteps :: Direction -> [Turn] -> [Direction]
rotateManySteps = scanl (flip rotate)

orientMany :: [Direction] -> [Turn]
orientMany ds@(_:_:_) = zipWith orient ds (tail ds)
orientMany _          = []
