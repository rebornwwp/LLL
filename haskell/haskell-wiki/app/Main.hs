module Main
  ( main
  ) where

import qualified CodeWars                                    as CW
import qualified CodeWars1                                   as CW1
import           Control.Monad.Reader                        (runReader)
import           FunctorApplicativeMonad.Monads.ReaderLib    (initEmail, main1,
                                                              view, view')
import qualified FunctorApplicativeMonad.Monads.ReaderTLib   as RT
import qualified FunctorApplicativeMonad.Monads.StateExample as S
import qualified FunctorApplicativeMonad.Monads.WriterLib    as W
import           Lib                                         ()
import qualified NewTypeExample                              as NT
import qualified PointExample                                as Point
import qualified SafeHaskell                                 as SH
import           TraceExample                                (tracemain)

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
  tracemain
  Point.main1
  W.writerMain
  S.main1
  RT.main1
  NT.main1
  SH.main1
  CW.main
  CW1.funcx
