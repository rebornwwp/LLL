{-# LANGUAGE OverloadedStrings #-}

module Ch28.BasicLibrary.StringsType where

import qualified Codec.Compression.GZip as GZip
import qualified Data.ByteString.Lazy   as BL
import qualified Data.Text.Encoding     as TE
import qualified Data.Text.IO           as TIO

input :: BL.ByteString
input = "123"

compressed :: BL.ByteString
compressed = GZip.compress input

mainTest :: IO ()
mainTest = do
  TIO.putStrLn $ TE.decodeUtf8 (s input)
  TIO.putStrLn $ TE.decodeUtf8 (s compressed)
  where
    s = BL.toStrict
