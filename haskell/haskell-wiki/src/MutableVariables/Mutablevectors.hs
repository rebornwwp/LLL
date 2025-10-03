module MutableVariables.Mutablevectors where

import           Control.Monad
import qualified Data.Vector.Unboxed.Mutable as V
import           RIO

main :: IO ()
main = do
  fib1 <- V.replicate 1 (0 :: Int)
  fib2 <- V.replicate 1 (1 :: Int)
  -- we're gonna overflow, just ignore that
  replicateM_ 1000000 $ do
    x <- V.unsafeRead fib1 0
    y <- V.unsafeRead fib2 0
    V.unsafeWrite fib1 0 y
    V.unsafeWrite fib2 0 $! x + y
  V.unsafeRead fib2 0 >>= print
