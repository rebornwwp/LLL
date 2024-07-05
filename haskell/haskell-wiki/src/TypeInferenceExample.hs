{-# LANGUAGE ExtendedDefaultRules #-}
{-# LANGUAGE OverloadedStrings    #-}

module TypeInferenceExample where

import qualified Data.Text as T

-- f :: Char -> Char
-- f x = const x g
-- g :: p -> Char
-- g y = f 'A'
data Tree a
  = Leaf
  | Bin a (Tree (a, a))

size :: Tree a -> Int
size Leaf      = 0
size (Bin _ t) = 1 + 2 * size t

-- default (String, T.Text)
default (T.Text, String)

-- example :: T.Text
example :: T.Text
example = "foo"
