module IORefLib where

import           Control.Monad
import           Data.IORef
import           Text.Read     (readMaybe)

{- | https://tuttlem.github.io/2013/02/01/mutable-state-with-ioref.html
    https://www.dcc.fc.up.pt/~pbv/aulas/tapf/handouts/stmonad.html
    https://caiorss.github.io/Functional-Programming/haskell/Mutable_References.html

    traditionally in Haskell, the suffix ' is used to label strict versions of a function,
    one which evaluates a value up to weak head normal form.
-}
newtype Counter =
  Counter
    { x :: IORef Int
    }

makeCounter :: Int -> IO Counter
makeCounter i = do
  iref <- newIORef i
  return (Counter iref)

incCounter :: Int -> Counter -> IO ()
incCounter i (Counter c) = modifyIORef c (+ i)

showCounter :: Counter -> IO ()
showCounter (Counter c) = readIORef c >>= print

sumNums :: IO Int
sumNums = newIORef 0 >>= go
  where
    go acc = readerNumber >>= processNumber acc
    readerNumber = do
      putStr "enter a number: "
      readMaybe <$> getLine
    processNumber acc Nothing  = readIORef acc
    processNumber acc (Just n) = modifyIORef' acc (+ n) >> go acc

sumNumbers :: IO Int
sumNumbers = newIORef 0 >>= go
  where
    go acc = readNumber >>= processNumber acc
    readNumber = do
      putStr "Put integer number (not a number to finish): "
      readMaybe <$> getLine
    processNumber acc Nothing  = readIORef acc
    processNumber acc (Just n) = modifyIORef' acc (+ n) >> go acc
