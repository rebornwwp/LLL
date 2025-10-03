{-# LANGUAGE DeriveAnyClass #-}

module ExceptionDemo.ArithException where

import           Control.Exception (throw, throwIO)
import           RIO               (MonadThrow (throwM), catch, try, tryJust)
import           RIO.Prelude
import           RIO.Prelude.Types (Exception)

data MyArithException
  = DivByZero
  | OtherArithException
  deriving (Show, Exception)

divPure :: Int -> Int -> Int
divPure _ 0 = throw DivByZero
divPure a b = a `div` b

divIO :: Int -> Int -> IO Int
divIO _ 0 = throwIO DivByZero
divIO a b = pure (a `div` b)

divM :: MonadThrow m => Int -> Int -> m Int
divM _ 0 = throwM DivByZero
divM a b = pure (a `div` b)

testComputation :: MonadThrow m => Int -> Int -> Int -> m Int
testComputation a b c = divM a b >>= divM c

divTestWithRecovery :: Int -> Int -> Int -> IO Int
divTestWithRecovery a b c = try (testComputation a b c) <&> dealWith
  where
    dealWith :: Either MyArithException Int -> Int
    dealWith (Right r) = r
    dealWith (Left _)  = 0

divTestWithRecovery2 :: Int -> Int -> Int -> IO Int
divTestWithRecovery2 a b c =
  tryJust isDivByZero (testComputation a b c) <&> dealWith
  where
    isDivByZero :: MyArithException -> Maybe ()
    isDivByZero DivByZero = Just ()
    isDivByZero _         = Nothing
    dealWith (Right r) = r
    dealWith (Left _)  = 0

divTestIO :: Int -> Int -> Int -> IO Int
divTestIO a b c = testComputation a b c `catch` handler
  where
    handler :: MyArithException -> IO Int
    handler e = do
      putStrLn $
        "We've got an exception: " ++ show e ++ "\nUsing default value 0"
      pure 0

maintest :: IO ()
maintest = do
  divTestWithRecovery 10 0 2 >>= print
  divTestWithRecovery2 10 0 2 >>= print
  divTestIO 10 0 2 >>= print
