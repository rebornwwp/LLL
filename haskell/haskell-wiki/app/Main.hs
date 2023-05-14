module Main
  ( main
  ) where

import           Control.Monad.Reader (runReader)
import           Lib                  ()
import           ReaderLib            (initEmail, main1, view, view')

main :: IO ()
main = do
  putStrLn "what is your email address?" >> getLine >>= \email ->
    print $ view email
  putStrLn "what is your email address?" >> getLine >>= \email ->
    print $ runReader view' email
  putStrLn "what is your email address?" >> getLine >>= \email ->
    print $ runReader initEmail email
  main1
