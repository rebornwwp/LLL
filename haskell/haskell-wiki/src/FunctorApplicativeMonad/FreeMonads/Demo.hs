module FunctorApplicativeMonad.FreeMonads.Demo where

-- data List a = Nil | Cons a (List a)
-- data Free f a = Nil a | Cons f (Free f a)
data Free f a
  = Pure a
  | Free (f (Free f a))
