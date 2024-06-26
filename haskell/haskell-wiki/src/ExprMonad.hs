{-# LANGUAGE DeriveFunctor         #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverlappingInstances  #-}
{-# LANGUAGE TypeOperators         #-}

module ExprMonad where

-- data Expr a
--   = Var a
--   | Add (Expr a) (Expr a)
--   deriving (Show)
-- instance Monad Expr
--  where
--   return x        = undefined
--   (Var a) >>= f   = undefined
--   (Add x y) >>= f = undefined
-- module ALaCarte where
-- Definitions
data Expr f =
  In (f (Expr f))

-- We define a separate data type for each constructor we want to use
-- then we can combine them together using the (:+:) operator to make
-- our data types à la carte.
data Lit a =
  Lit Int

data Add a =
  Add a a

-- Coproduct
data (f :+: g) e
  = Inl (f e)
  | Inr (g e)

infixr 1 :+:

-- By defining functor instances we can write a generic fold operator
-- which will be useful to evaluate our expressions.
instance Functor Lit where
  fmap = undefined

instance Functor Add where
  fmap = undefined

instance (Functor f, Functor g) => Functor (f :+: g) where
  fmap f (Inl a) = undefined
  fmap f (Inr b) = undefined

foldExpr :: Functor f => (f a -> a) -> Expr f -> a
foldExpr f (In e) = undefined

-- Now we can write a simple interpreter. Your definitions should correspond
-- closely with the definition for the old interpreter given in the description.
class Functor f =>
      Eval f
  where
  evalAlgebra :: f Int -> Int

instance Eval Lit where
  evalAlgebra (Lit x) = undefined

instance Eval Add where
  evalAlgebra (Add x y) = undefined

instance (Eval f, Eval g) => Eval (f :+: g) where
  evalAlgebra (Inl l) = undefined
  evalAlgebra (Inr r) = undefined

eval :: Eval f => Expr f -> Int
eval = undefined

-- HINT: Use foldExpr
-- The problem is that it is painful to write expressions.
-- This is how you would write 5+6
pain :: Expr (Lit :+: Add)
pain = In (Inr (Add (In (Inl (Lit 5))) (In (Inl (Lit 6)))))

-- Injection
-- To ease writing expressions, we will now define a type class
-- which will choose the right constructors for us. Think of the sub :<: sup to say that
-- sub is a subtype of sup.
-- It might also help to think of :+: as the cons operator for a type level list.
-- Then the type class can be viewed as searching for the correct injection by
-- searching through the list for the correct type.
class (Functor sub, Functor sup) =>
      sub :<: sup
  where
  inj :: sub a -> sup a

-- Reflexivity
instance Functor f => f :<: f where
  inj = undefined

instance (Functor f, Functor g) => f :<: (f :+: g) where
  inj = undefined

instance (Functor f, Functor g, Functor h, f :<: g) => f :<: (h :+: g) where
  inj = undefined

-- Note: This part requires overlapping instances, this is safe as long as :+: associates to the right.
-- A modern implementation would use type families.
-- Then we can use this type class to write smart constructors.
inject :: (g :<: f) => g (Expr f) -> Expr f
inject = In . inj

lit :: (Lit :<: f) => Int -> Expr f
lit n = undefined

add :: (Add :<: f) => Expr f -> Expr f -> Expr f
add e1 e2 = undefined

-- Then as long as we specify the type, writing expressions is easy.
expr :: Expr (Add :+: Lit)
expr = add (lit 5) (lit 6)
-- > eval expr
-- 11
-- -- We can add multiplication very easily.
-- data Mult a =
--   Mult a a
--   deriving (Functor)
-- instance Eval Mult where
--   ??
-- mult :: ??
-- mult e1 e2 = undefined
-- -- We must specify the type of expressions
-- expr2 :: ??
-- expr2 = mult (add (lit 5) (lit 6)) (lit 2)
-- -- > eval expr
-- -- 22
-- -- Adding a new interpreter
-- -- To add a pretty printer, we define a new type class in much the
-- -- same way as for the first interpreter.
-- class Functor f => Pretty f where
--   ??
-- pretty :: Pretty f => Expr f -> String
-- pretty = undefined
-- instance Pretty Lit where
--   ??
-- instance Pretty Add where
--   ??
-- instance Pretty Mult where
--   ??
-- instance (Pretty f, Pretty g) => Pretty (f :+: g) where
--   ??
-- -- > pretty expr1
-- -- "(5+6)"
-- -- > pretty expr2
-- -- "((5+6)*2)"
