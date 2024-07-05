module Benchmark.BenchmarkExample where

import           Criterion.Main

fib m
  | m < 0 = error "negative!"
  | otherwise = go m
  where
    go 0 = 0
    go 1 = 1
    go n = go (n - 1) + go (n - 2)

maintest :: IO ()
maintest =
  defaultMain
    [ bgroup
        "fib"
        [ bench "1" $ whnf fib 1
        , bench "5" $ whnf fib 5
        , bench "11" $ whnf fib 11
        ]
    ]
