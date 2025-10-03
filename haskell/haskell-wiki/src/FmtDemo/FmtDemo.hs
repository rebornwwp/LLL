{-# LANGUAGE OverloadedStrings #-}

module FmtDemo.FmtDemo where

import qualified Data.Text as T
import           Fmt

name :: T.Text
name = "jone"

age :: Int
age = 30

x = fmt $ "hello" +| name |+ "!\nI know that your age is " +| age |+ ".\n"

y = fmt $ "That is " +| hexF age |+ " in hex!\n"
