{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE InstanceSigs          #-}
{-# LANGUAGE LambdaCase            #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TypeApplications      #-}
{-# LANGUAGE TypeOperators         #-}

module DesignPattern.ExpressionProblem.A where

import           Control.Applicative ((<|>))
import           Prelude             hiding (getChar, putChar, readFile,
                                      writeFile)
import qualified Prelude

newtype Expr f =
  In (f (Expr f))

newtype Val e =
  Val Int

type IntExpr = Expr Val

data Add e =
  Add e e

type AddExpr = Expr Add


-- | data (:+:) f g e
data (:+:) f g e
  = Inl (f e)
  | Inr (g e)

infixr 8 :+:

addExample :: Expr (Val :+: Add)
addExample = In (Inr (Add (In (Inl (Val 118))) (In (Inl (Val 1219)))))

instance Functor Val
 where
  fmap f (Val x) = Val x
