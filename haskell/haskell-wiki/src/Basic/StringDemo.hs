{-# LANGUAGE OverloadedStrings #-}

module Basic.StringDemo where

import qualified Data.ByteString         as S
import qualified Data.ByteString.Builder as BB
import qualified Data.ByteString.Char8   as S8
import           Data.Monoid             ((<>))
import qualified Data.Text               as T
import qualified Data.Text.Encoding      as TE
import qualified Data.Text.IO            as TIO
import qualified Data.Text.Lazy.Builder  as TB
import           Data.Word               (Word8)

-- https://www.fpcomplete.com/haskell/tutorial/string-types/
-- The two primary packages for dealing with string-like data in Haskell are bytestring and text.
-- bytestring is work for binary data
-- text is work for textual data
mainbytestring :: IO ()
mainbytestring = do
  S.writeFile "content.txt" "This is some sample content"
  bs <- S.readFile "content.txt"
  print bs
  print $ S.takeWhile (/= space) bs
  print $ S.take 5 bs
  print $ "File contents: " <> bs
  putStrLn $ "Largest byte: " ++ show (S.foldl1' max bs)
    -- Or just use S.maximum
  putStrLn $ "Spaces: " ++ show (S.length (S.filter (== space) bs))
  where
    space :: Word8
    space = 32 -- ASCII code

maintext :: IO ()
maintext = do
  TIO.writeFile "content.txt" "This is some sample content"
  text <- TIO.readFile "content.txt"
  print text
  print $ T.takeWhile (/= ' ') text
  print $ T.take 5 text
  print $ "File contents: " <> text
  putStrLn $ "Largest character: " ++ show (T.foldl1' max text)
    -- Or just use T.maximum
  putStrLn $ "Spaces: " ++ show (T.length (T.filter (== ' ') text))

mainpack :: IO ()
mainpack = do
  print (S8.pack "This is now a ByteString" :: S.ByteString)
  print (T.pack "This is now a Text" :: T.Text)

-- The `encodeUtf8` function converts a Text into a ByteString,
mainTextToByteString :: IO ()
mainTextToByteString = do
  let text = "This is some text, with non-Latin chars: שלום"
      bs = TE.encodeUtf8 text
  S.writeFile "content.txt" bs
  bs2 <- S.readFile "content.txt"
  let text2 = TE.decodeUtf8 bs2
  print text2

-- the `decodeUtf8` function converts from a ByteString to Text
mainBytestringToText :: IO ()
mainBytestringToText = do
  let bs = "Invalid UTF8 sequence254253252"
  print $ TE.decodeUtf8 bs

-- strict ByteString, lazy ByteString, strict Text, and lazy Text.
-- 更细的划分类型有lazy和strict的类型，建议是不清楚的时候，就不要使用lazy的
-- 如果要使用占用内存比较大的时候，使用streaming data library, 比如conduit.
-- 建议
-- When interacting over standard input/output/error, use the functions from Data.Text.IO.
-- When reading from files, sockets, or any other source, always use ByteString-based functions and then, if necessary, use explicit character decoding functions to convert to Text.
-- best way to write file
mainWriteFile :: IO ()
mainWriteFile = do
  S.writeFile "utf8-file.txt" $ TE.encodeUtf8 "hello hola שלום"
  text <- TIO.readFile "utf8-file.txt"
  print text

mainInputIO :: IO ()
mainInputIO = do
  TIO.putStrLn "What is your name?"
  name <- TIO.getLine
  TIO.putStrLn $ "Hello, " <> name

-- a Builder datatype, like string builder in java
main :: IO ()
main = do
  print (BB.toLazyByteString ("Hello " <> "there " <> "world" :: BB.Builder))
  print (TB.toLazyText ("Hello " <> "there " <> "world" :: TB.Builder))
-- bytestring with streaming manner
-- import Data.Monoid ((<>))
-- import qualified Data.ByteString as S
-- import Data.ByteString.Builder (Builder)
-- import Data.Streaming.ByteString.Builder (toByteStringIO)
-- main :: IO ()
-- main = toByteStringIO S.putStr ("Hello " <> "there " <> "world" :: Builder)
