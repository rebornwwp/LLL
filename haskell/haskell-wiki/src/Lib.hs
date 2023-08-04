module Lib
  ( someFunc
  ) where

someFunc :: IO ()
someFunc = putStrLn "someFunc"


-- 依赖注入, 可以方便测试代码mock
type ProcessF = Int -> Int

f :: ProcessF -> Int -> Int
f x a = x a + 100
