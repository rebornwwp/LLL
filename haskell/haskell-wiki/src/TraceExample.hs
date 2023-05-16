module TraceExample
  ( trancemain
  ) where

import           Debug.Trace (trace)

factorial :: Int -> Int
factorial n
  | n == 0 = trace "branch 1" 1
  | otherwise = trace "branch 2" $ n * factorial (n - 1)

debug :: c -> String -> c
debug = flip trace

trancemain :: IO ()
trancemain = do
  putStrLn $ "factorial 6: " ++ show (factorial 6)
  print ((1 + 2) `debug` "adding")
