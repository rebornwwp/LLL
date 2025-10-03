{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE DerivingVia                #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE StandaloneDeriving #-}

module MetaProgramming.Via where

import           Data.Monoid (Alt (..))

newtype Age =
  Age Int
  deriving newtype (Eq, Ord)


newtype Age' =
  Age' Int
  deriving (Eq, Ord) via Int

newtype MAge =
  MAge (Maybe Int)
  deriving  (Show)

--  deriving (Semigroup, Monoid) via (Alt Maybe Int)
--  deriving (Semigroup, Monoid) via (Dual (Alt Maybe Int))
deriving via (Alt Maybe Int) instance Semigroup MAge

deriving via (Alt Maybe Int) instance Monoid MAge
