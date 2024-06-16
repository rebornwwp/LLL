{-# LANGUAGE DeriveAnyClass    #-}
{-# LANGUAGE DeriveGeneric     #-}
{-# LANGUAGE LambdaCase        #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module JSONDemo.JsonDemo where

import           Data.Aeson   hiding (Error)
import           Data.Text    (Text)
import           GHC.Generics

-- 手动创建 Object
customValue :: Value
customValue =
  object
    [ "list_price" .= (15000 :: Int)
    , "sale_price" .= (15000 :: Int)
    , "description" .= ("eee" :: String)
    ]

--- 使用自动化的encode和decode来实现
-- 下面介绍的是generic的方式, 自动的方式 haskell的数据结构中的filedname 必须与json中字段相同
-- 也可以通过 derive instances at compile-time, using Data.Aeson.TH and the TemplateHaskell extension 的方式
-- 方式1
data Foo =
  Foo
    { field1 :: Int
    , field2 :: String
    }
  deriving (Show, Generic, ToJSON, FromJSON)

--  方式2
data Person =
  Person
    { name :: Text
    , age  :: Int
    }
  deriving (Generic, Show)

instance FromJSON Person

-- slow way
-- instance ToJSON Person
--  better efficiency
instance ToJSON Person where
  toEncoding = genericToEncoding defaultOptions

maintest :: IO ()
maintest = do
  putStrLn $ "Encode: " ++ show (encode (Person {name = "Joe", age = 12}))
  putStrLn $
    "Decode: " ++
    show (decode "{ \"name\": \" Joe \", \"age\": 12 }" :: Maybe Person)

-- 通过自定义decode和encode的方式实现, 可以将不同的field进行对应起来
data PersonA =
  PersonA
    { namea :: Text
    , agea  :: Int
    }
  deriving (Show)

-- We expect a JSON object, so we fail at any non-Object value.
instance FromJSON PersonA where
  parseJSON =
    withObject "persona" $ \obj -> do
      namea <- obj .: "name"
      agea <- obj .: "age"
      return PersonA {..}

instance ToJSON PersonA where
  toJSON (PersonA name age) = object ["name" .= name, "age" .= age]

-- Working with a arbitrary JSON data
x :: Maybe Value
x = decode "{ \"foo\": false, \"bar\": [1, 2, 3] }" :: Maybe Value

-- If you have an optional field, use (.:?) instead of (.:).
data Item =
  Item
    { iname        :: String
    , idescription :: Maybe String
    }
  deriving (Show)

instance FromJSON Item where
  parseJSON =
    withObject "Item" $ \obj -> do
      name <- obj .: "name"
      desc <- obj .:? "description"
      return (Item {iname = name, idescription = desc})

-- Parsing enum datatypes
data UserType
  = User
  | Admin
  | CustomerSupport

-- 最简单的方式：
--   deriving (Generic, ToJSON, FromJSON)
-- enumparse = encode CustomerSupport
instance FromJSON UserType where
  parseJSON =
    withText "UserType" $ \case
      "user"           -> return User
      "admin"          -> return Admin
      "custom_support" -> return CustomerSupport
      _                -> fail "string is not one of known enum values"

data APIResult
  = JSONData Value
  | Error Text
  deriving (Show)

instance FromJSON APIResult where
  parseJSON =
    withObject "APIResult" $ \obj -> do
      ok <- obj .: "ok"
      if ok
        then fmap JSONData (obj .: "data")
        else fmap Error (obj .: "error_msg")

-- goodData :: LB.ByteString
goodData = "{\"ok\":true,\"data\":{\"foo\":2}}"

-- badData :: LB.ByteString
badData = "{\"ok\":false,\"error_msg\":\"no_credentials\"}"

good = decode goodData :: Maybe APIResult

bad = decode badData :: Maybe APIResult
