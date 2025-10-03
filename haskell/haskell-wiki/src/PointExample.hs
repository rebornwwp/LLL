module PointExample
  ( main1
  ) where

getLine1 :: IO String
getLine1 = return "hello1"

getLine2 :: IO String
getLine2 = return "hello2"

f1 = sequence [Just 3, Just 4]

f2 = sequence [Just 3, Just 4, Nothing]

main1 :: IO ()
main1 = do
  lines <- sequence [getLine1, getLine2] :: IO [String]
  print lines
