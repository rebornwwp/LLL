module MutableVariables.STMLib where

import           Control.Concurrent.STM

-- 从IORef迁移到STM，可以避免data race
mainSTM :: IO ()
mainSTM = do
  var <- atomically $ newTVar "Hello"
  origVal <- atomically $ readTVar var
  atomically $ writeTVar var (origVal ++ " World")
  newVal <- atomically $ readTVar var
  putStrLn newVal
  -- OR
  var <- newTVarIO "Hello"
  -- OR
  atomically $ do
    origVal <- readTVar var
    writeTVar var (origVal ++ " World")
  -- OR
  var <-
    atomically $ do
      var <- newTVar "Hello"
      modifyTVar var (++ " World")
      pure var
  atomically (readTVar var) >>= putStrLn
