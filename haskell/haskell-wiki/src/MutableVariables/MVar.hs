module MutableVariables.MVar where

import           Prelude       (print)
import           RIO
import           System.Random (randomRIO)

main :: IO ()
main = do
  var <- newMVar (0 :: Int)
  replicateConcurrently_ 1000 (inner var)
  takeMVar var >>= print
  where
    inner var =
      modifyMVar_ var $ \val
      -- I'm the only thread currently running. I could play around
      -- with some shared resource like a file
       -> do
        x <- randomRIO (1, 10)
        return $! val + x
