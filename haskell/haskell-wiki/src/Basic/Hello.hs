{-# LANGUAGE GADTs #-}

module Basic.Hello where

import           Debug.Trace (traceM)

data ABC a b c =
  ABC
    { xa :: a
    , xb :: b
    , xc :: c
    }

data AB x y =
  forall b. Show b =>
            AB
              { ui :: b
              , uo :: x
              , up :: y
              }

data Option a =
  Option
    { optName   :: String
    , optParser :: String -> Maybe a
    }

instance Functor Option where
  fmap f (Option name p) = Option name (fmap f . p)

data Parser a where
  NilP :: a -> Parser a
  ConsP :: Option (a -> b) -> Parser a -> Parser b
