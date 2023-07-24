{-# LANGUAGE InstanceSigs       #-}
{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE StandaloneDeriving #-}

module ReadShow
  (
  ) where

import           Control.Monad.Writer (MonadWriter (tell, writer), Writer)
import           Data.String          (IsString (fromString))

data Person =
  Person String (Maybe Int)

instance IsString Person where
  fromString :: String -> Person
  fromString name = Person name Nothing

homer :: Person
homer = Person "Homer perter" (Just 10)

spj :: Person
spj = "hello world"

deriving instance Show Person

deriving instance Read Person

deriving instance Eq Person

readNumber :: IO Int
-- readNumber = do
--   s <- getLine
--   pure (read s)
readNumber = read <$> getLine

sumN :: Int -> Writer String Int
sumN 0 = writer (0, "finish")
sumN n = do
  tell (show n ++ ",")
  s <- sumN (n - 1)
  pure (s + n)

cartesianProduct :: [Int] -> [Int] -> [(Int, Int)]
cartesianProduct xs ys = do
  x <- xs
  y <- ys
  pure (x, y)

addNumber :: Int -> IO String
-- addNumber n = pure (++) <*> pure (show n ++ " ") <*> getLine
addNumber n = (++) (show n ++ " ") <$> getLine
