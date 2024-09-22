{-# LANGUAGE DataKinds        #-}
{-# LANGUAGE TemplateHaskell  #-}
{-# LANGUAGE TypeApplications #-}

module CompileTimeEvaluation.Result where

import           CompileTimeEvaluation.CompileTimeEvaluation
import           Data.Proxy                                  (Proxy (Proxy))
import           Language.Haskell.TH.Syntax                  (Lift (lift))

main = do
  print (fib 10)
  -- 这里使用template， 这里将会在编译器进行计算, 并且只能在另外一个module中使用
  -- 快速将代码转变成编译器求值
  print $(lift (fib 10))
  printFib (Proxy @5) -- Should print Fib 5 = 5
  printFib (Proxy @10) -- Should print Fib 10 = 55
  printFiba (Proxy @10) -- Should print Fib 10 = 55
