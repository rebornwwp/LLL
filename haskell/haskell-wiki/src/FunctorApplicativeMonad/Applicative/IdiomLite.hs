module FunctorApplicativeMonad.Applicative.IdiomLite where

import           Control.Monad (ap)
import           Prelude       hiding (repeat)

-- 通过三个函数给出了，applicative style的编程模式
sequence' :: [IO a] -> IO [a]
sequence' [] = return []
sequence' (c:cs) = do
  x <- c
  xs <- sequence' cs
  return (x : xs)

-- applicative style
sequence'' :: [IO a] -> IO [a]
sequence'' []     = return []
sequence'' (c:cs) = return (:) `ap` c `ap` (sequence'' cs)

transpose :: [[a]] -> [[a]]
transpose []       = repeat []
transpose (xs:xss) = zipWith (:) xs (transpose xss)

repeat :: a -> [a]
repeat x = x : repeat x

zapp :: [a -> b] -> [a] -> [b]
zapp (f:fs) (x:xs) = f x : zapp fs xs
zapp _ _           = []

-- applicative style
transpose' :: [[a]] -> [[a]]
transpose' []       = repeat []
transpose' (xs:xss) = repeat (:) `zapp` xs `zapp` transpose xss

newtype Accy o a =
  Acc
    { acc :: o
    }
