module Basic.Closures where

import           Data.IORef (IORef, modifyIORef, newIORef, readIORef)

intSeq :: IORef Int -> IO Int
intSeq ref = do
  modifyIORef ref (+ 1)
  readIORef ref

testmain :: IO ()
testmain = do
  ref <- newIORef 0
  let nextInt = intSeq ref
  nextInt >>= print
  nextInt >>= print
  nextInt >>= print
  ref' <- newIORef 0
  let newInt' = intSeq ref'
  newInt' >>= print
