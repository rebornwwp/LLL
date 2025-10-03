module LispVal where

import qualified Data.Text as T

data LispVal =
  Atom T.Text
