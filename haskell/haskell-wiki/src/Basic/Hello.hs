{-# LANGUAGE ExistentialQuantification #-}

module Basic.Hello where

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
