{-# LANGUAGE OverloadedStrings #-}

module Main
  ( main
  ) where

import           Control.Monad       (forM_)
import           Control.Monad.Cont  (ContT (runContT), MonadCont (callCC),
                                      MonadIO (liftIO))
-- import qualified Data.ByteString.Lazy.Char8 as L8
-- import           Network.HTTP.Simple
import           Options.Applicative

data Sample =
  Sample
    { hello      :: String
    , quiet      :: Bool
    , enthusiasm :: Int
    }

sample :: Parser Sample
sample =
  Sample <$>
  strOption (long "hello" <> metavar "TARGET" <> help "Target for the greeting") <*>
  switch (long "quiet" <> short 'q' <> help "Whether to be quiet") <*>
  option
    auto
    (long "enthusiasm" <>
     help "How enthusiastically to greet" <>
     showDefault <> value 1 <> metavar "INT")

greet :: Sample -> IO ()
greet (Sample h False n) = putStrLn $ "Hello, " ++ h ++ replicate n '!'
greet _                  = return ()

main :: IO ()
main = greet =<< execParser opts
  where
    opts =
      info
        (sample <**> helper)
        (fullDesc <>
         progDesc "Print a greeting for TARGET" <>
         header "hello - a test for optparse-applicative")

main1 :: IO ()
main1 = do
  forM_ [1 .. 3] $ \i -> do print i
  forM_ [7 .. 9] $ \j -> do print j
  withBreak $ \break ->
    forM_ [1 ..] $ \_ -> do
      p "loop"
      break ()
  where
    withBreak = (`runContT` return) . callCC
    p = liftIO . putStrLn
