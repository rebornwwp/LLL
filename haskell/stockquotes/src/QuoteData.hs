{-# LANGUAGE DeriveAnyClass     #-}
{-# LANGUAGE DeriveGeneric      #-}
{-# LANGUAGE InstanceSigs       #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module QuoteData where

import           Data.ByteString.Char8 (unpack)
import           Data.Csv              (Field, FromField (..), FromNamedRecord,
                                        Parser)

import           Data.Time             (Day, defaultTimeLocale, parseTimeM)
import           GHC.Generics          (Generic)


-- day,close,volume,open,high,low
-- 2019-05-01,210.520004,64827300,209.880005,215.309998,209.229996
-- 2019-05-02,209.149994,31996300,209.839996,212.649994,208.130005
data QuoteData =
  QuoteData
    { day    :: Day
    , volume :: Int
    , open   :: Double
    , close  :: Double
    , high   :: Double
    , low    :: Double
    }
  deriving (Generic, FromNamedRecord)

instance FromField Day where
  parseField :: Field -> Parser Day
  parseField = parseTimeM True defaultTimeLocale "%Y-%m-%d" . unpack

data QField
  = Open
  | Close
  | High
  | Low
  | Volume
  deriving (Eq, Ord, Show, Enum, Bounded)

field2fun :: QField -> QuoteData -> Double
field2fun Open   = open
field2fun Close  = close
field2fun High   = high
field2fun Low    = low
field2fun Volume = fromIntegral . volume
