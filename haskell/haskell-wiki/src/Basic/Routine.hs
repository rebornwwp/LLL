module Basic.Routine where

import           Control.Concurrent (forkIO)
import           Control.Monad      (forM_)

f :: String -> IO ()
f from = forM_ [0 .. 2] (\i -> do putStrLn $ from ++ ":" ++ show i)

testmain :: IO ()
testmain = do
  f "direct"
  _ <- forkIO $ f "forkIO"
  _ <- forkIO $ putStrLn "going"
  _ <- getLine
  putStrLn "done"
