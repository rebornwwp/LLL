{-# LANGUAGE GADTs         #-}
{-# LANGUAGE TypeFamilies  #-}
{-# LANGUAGE TypeOperators #-}

module Exercise.AAddBEqualBAddA
  ( plusCommutes
  ) where

-- For reference, here are the definitions, if you
-- want to copy them into an IDE:
-- For older GHC where Type is not in Prelude
import           Data.Kind (Type)

-- | The natural numbers, encoded in types.
data Z

data S n

-- | Predicate describing natural numbers.
-- | This allows us to reason with `Nat`s.
data Natural :: Type -> Type where
  NumZ :: Natural Z
  NumS :: Natural n -> Natural (S n)

-- | Predicate describing equality of natural numbers.
data Equal :: Type -> Type -> Type where
  EqlZ :: Equal Z Z
  EqlS :: Equal n m -> Equal (S n) (S m)

-- | Peano definition of addition.
type family (:+:) (n :: Type) (m :: Type) :: Type

type instance Z :+: m = m

type instance S n :+: m = S (n :+: m)

-- These are some lemmas that may be helpful.
-- They will *not* be tested, so rename them
-- if you so desire. Good luck!
-- | For any n, n = n.
reflexive :: Natural n -> Equal n n
reflexive = error "Optional: reflexive"

-- | if a = b, then b = a.
symmetric :: Equal a b -> Equal b a
symmetric = error "Optional: symmetric"

-- | if a = b and b = c, then a = c.
transitive :: Equal a b -> Equal b c -> Equal a c
transitive = error "Optional: transitive"

-- This is the proof that the kata requires.
-- | a + b = b + a
plusCommutes :: Natural a -> Natural b -> Equal (a :+: b) (b :+: a)
plusCommutes = error "TODO: plusCommutes"
