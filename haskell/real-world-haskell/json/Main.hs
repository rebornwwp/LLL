module Main (main) where

import SimpleJson
import PutJson

main :: IO ()
main = print $ JObject [("foo", JNumber 1), ("bar", JBool False)]

