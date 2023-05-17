module StateExample
  ( main1
  ) where

-- https://smunix.github.io/dev.stephendiehl.com/hask/index.html#state-monad
import           Control.Monad.State (MonadState (get, put), State, execState,
                                      modify)

test :: State Int Int
test = do
  put 3
  modify (+ 1)
  get

main1 :: IO ()
main1 = print $ execState test 0
