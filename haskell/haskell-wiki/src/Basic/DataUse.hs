module Basic.DataUse where

data X =
  XBA
    { a :: String
    , b :: String
    }
  deriving (Show)

empty :: X
empty = XBA {a = "", b = ""}

hasty :: X
hasty = empty {a = "xx"}
