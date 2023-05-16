module WriterLib
  ( writerMain
  ) where

import           Control.Monad.Writer (MonadWriter (tell, writer), Writer,
                                       runWriter)

logNumber :: Int -> Writer [String] Int
logNumber num = writer (num, ["Got number: " ++ show num])

--do-sugar
multWithLog :: Writer [String] Int
multWithLog = do
  a <- logNumber 3
  b <- logNumber 5
  tell ["multiplying " ++ show a ++ " and " ++ show b]
  return (a * b)

-- desugar
multWithLog' :: Writer [String] Int
multWithLog' =
  logNumber 3 >>= \x -> logNumber 5 >>= \y -> tell ["hello"] >> return (x * y)

writerMain :: IO ()
writerMain = do
  print "====================== Writer:"
  print $ runWriter $ logNumber 1
  print $ runWriter multWithLog
  print $ runWriter multWithLog'
