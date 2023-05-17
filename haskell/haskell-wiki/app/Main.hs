module Main
  ( main
  ) where

import           Control.Monad.Reader (runReader)
import           Lib                  ()
import qualified PointExample         as Point
import           ReaderLib            (initEmail, main1, view, view')
import qualified ReaderTLib           as RT
import qualified StateExample         as S
import           TraceExample         (trancemain)
import qualified WriterLib            as W

main :: IO ()
main
  -- putStrLn "what is your email address?" >> getLine >>= \email ->
  --   print $ view email
  -- putStrLn "what is your email address?" >> getLine >>= \email ->
  --   print $ runReader view' email
  -- putStrLn "what is your email address?" >> getLine >>= \email ->
  --   print $ runReader initEmail email
 = do
  main1
  trancemain
  Point.main1
  W.writerMain
  S.main1
  RT.main1
