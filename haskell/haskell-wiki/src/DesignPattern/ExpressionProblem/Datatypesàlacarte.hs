{-# LANGUAGE DeriveFunctor  #-}
{-# LANGUAGE GADTs          #-}
{-# LANGUAGE InstanceSigs   #-}
{-# LANGUAGE KindSignatures #-}
{-# LANGUAGE RankNTypes     #-}
{-# LANGUAGE TypeOperators  #-}

module DesignPattern.ExpressionProblem.Datatypesàlacarte where

import           Data.Kind (Type)

data Val e =
  Val Int
  deriving (Functor)

data Add e =
  Add e e
  deriving (Functor)

newtype Fix f = In
  { out :: f (Fix f)
  }


-- coproduct
infix 1 :+:

data (:+:) :: (Type -> Type) -> (Type -> Type) -> Type -> Type where
  Inl :: f a -> (f :+: g) a
  Inr :: g a -> (f :+: g) a

instance (Functor f, Functor g) => Functor (f :+: g) where
  fmap :: forall a b. (a -> b) -> (f :+: g) a -> (f :+: g) b
  fmap f (Inl x) = Inl (fmap f x)
  fmap f (Inr x) = Inr (fmap f x)
