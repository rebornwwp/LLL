{-# LANGUAGE OverloadedStrings #-}

module HTTPDemo.Demo where

import           Data.Aeson            (Value)
import qualified Data.ByteString.Char8 as S8
import           Network.HTTP

maintest :: IO String
maintest = do
  simpleHTTP (getRequest "http://www.haskell.org/") >>=
    fmap (take 100) . getResponseBody

main = maintest >>= print
