module Naiveeq where

data Color = Red | Green | Blue

instance Show Color where
  show Red = "Red"
  show Green = "Green"
  show Blue = "Blue"

instance Read Color where
  readsPrec _ value =
    tryParse [("Red", Red), ("Green", Green), ("Blue", Blue)]
    where tryParse [] = []
          tryParse ((attempt, result):xs) =
            if (take (length attempt) value) == attempt
               then [(result, drop (length attempt) value)]
               else tryParse xs

data Color2 = Yellow | White | Blank
  deriving (Read, Show, Eq, Ord)

main :: IO ()
main = do
  let a = read "Red" :: Color
      b = read "Blue" :: Color
      c = read "Green" :: Color
  print a
  print b
  print c
  print $ Yellow > White

