module FunctorApplicativeMonad.Applicative.A where

f :: a -> b -> c
f = undefined

a :: f a
a = undefined

b :: f b
b = undefined

-- z = pure f <*> a <*> b
h1 :: f (g (a -> b))
h1 = undefined

a1 :: f (g a)
a1 = undefined
