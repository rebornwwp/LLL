module FunctorApplicativeMonad.Applicative.A where

import           Control.Applicative (Applicative (liftA2))
import           Control.Monad       (liftM)

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

-- x = liftA2 (<*>) h1 a1 :: f (g b)
liftMType :: (a1 -> r) -> m a1 -> m r
liftMType = liftM
