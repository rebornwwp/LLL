{-# LANGUAGE TypeSynonymInstances #-}
module JsonClass where

import SimpleJson

type JsonError = String

class Json a where
  toJValue :: a -> JValue
  fromJValue :: JValue -> Either JsonError a

instance Json JValue where
  toJValue = id
  fromJValue = Right
