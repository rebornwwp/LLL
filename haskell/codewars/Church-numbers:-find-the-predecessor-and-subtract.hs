{-# LANGUAGE RankNTypes #-}

module Haskell.Codewars.Church where

{-
https://en.wikipedia.org/wiki/Lambda_calculus

functions for Church-numbers that are represented as

newtype Number = Nr (forall a. (a -> a) -> a -> a)

zero :: Number
zero = Nr (\ _ z -> z)

succ :: Number -> Number
succ (Nr a) = Nr (\ s z -> s (a s z))

one :: Number
one = succ zero
The goal of this little kata to implement

pred :: Nat -> Nat the predecessor function
and subt :: Nat -> Nat -> Nat for substraction
Such that

pred (Succ n) == n
pred Zero == Zero
which of course means that for m >= n we define n `subt` m := Zero.

You should do this kata only by using the functions from the import:

pair :: a -> b -> Pair a b creates a tupled pair
fst :: Pair a b -> a get's the first item of a pair
snd :: Pair a b -> b get's the second item of a pair
zero :: Number the church-representation of zero
succ :: Number -> Number the successor function
fold :: Number -> (a -> a) -> a -> a folds a number by:
fold s z Zero = z
fold s z (Succ n) = s (fold s z n)
add :: Number -> Number -> Number adds to numbers
mult :: Number -> Number -> Number multiplies to numbers
-}

import Prelude hiding (succ, pred, fst, snd)

pred :: Number -> Number
pred (Nr num) = Nr ((\ n -> \f -> \ x -> n (\ g -> \ h -> h (g f)) (\ u -> x) (\ u -> u)) num)

subt :: Number -> Number -> Number
subt a (Nr b) = b pred a

-- cannot be placed in Preloaded right now as there is a bug in the codewars system

newtype Pair a b = Pr (forall c . (a -> b -> c) -> c)

instance (Show a, Show b) => Show (Pair a b) where
  show (Pr p) = p (\ a b -> "(" ++ show a ++ "," ++ show b ++ ")")

pair :: a -> b -> Pair a b
pair f s = Pr (\ b -> b f s)

fst :: Pair a b -> a
fst (Pr p) = p (\ a _ -> a)

snd :: Pair a b -> b
snd (Pr p) = p (\ _ b -> b)

newtype Number = Nr (forall a. (a -> a) -> a -> a)

instance Show Number where
  show (Nr a) = a ("1+" ++) "0"

instance Eq Number where
  a == b = eval a == eval b

fold :: Number -> (a -> a) -> a -> a
fold (Nr n) s z = n s z

eval :: Number -> Integer
eval (Nr a) = a (+1) 0

zero :: Number
zero = Nr (\ _ z -> z)

succ :: Number -> Number
succ (Nr a) = Nr (\ s z -> s (a s z))

add :: Number -> Number -> Number
add (Nr a) = a succ

mult :: Number -> Number -> Number
mult (Nr a) b =  a (add b) zero
