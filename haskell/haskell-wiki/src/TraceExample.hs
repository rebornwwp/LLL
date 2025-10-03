{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Redundant return" #-}
module TraceExample
  ( tracemain
  ) where

import           Debug.Trace   (trace, traceM)

factorial :: Int -> Int
factorial n
  | n == 0 = trace "branch 1" 1
  | otherwise = trace "branch 2" $ n * factorial (n - 1)

debug :: c -> String -> c
debug = flip trace

-- https://discourse.haskell.org/t/how-to-debug-inside-state-monad/3385/10
debugInMonad :: Maybe a -> Maybe a
debugInMonad mx = do
  trace "hello" (Just 10)
  trace "hello" (return ())
  traceM ("hello" ++ "world")
  x <- mx
  return x

tracemain :: IO ()
tracemain = do
  putStrLn $ "factorial 6: " ++ show (factorial 6)
  print ((1 + 2) `debug` "adding")
  let y = debugInMonad (Just 10)
  case y of
    Just x  -> print $ show x
    Nothing -> print "nothing"
