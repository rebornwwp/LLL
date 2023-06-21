{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE GADTs                     #-}
{-# LANGUAGE KindSignatures            #-}

module GADTExample where

import           Data.Kind (Type)

-- vanilla haskell
data List a
  = Empty
  | Cons a (List a)

data ListG a where
  EmptyG :: ListG a
  ConsG :: a -> ListG a -> ListG a

data Term a where
  Lit :: a -> Term a
  Succ :: Term Int -> Term Int
  IsZero :: Term Int -> Term Bool
  If :: Term Bool -> Term a -> Term a -> Term a

eval :: Term a -> a
eval (Lit i) = i
eval (Succ t) = 1 + eval t
eval (IsZero i) = eval i == 0
eval (If b e1 e2) =
  if eval b
    then eval e1
    else eval e2

example :: Int
example = eval (Succ (Succ (Lit 3)))

-- using Constraints
data Exp a
  = (a ~ Int) =>
    LitInt a
  | (a ~ Bool) =>
    LitBool a
  | forall b. (b ~ Bool) =>
              LitIf (Exp b) (Exp a) (Exp a)

evalExp :: Exp a -> a
evalExp e =
  case e of
    LitInt i -> i
    LitBool b -> b
    LitIf b tr fl ->
      if evalExp b
        then evalExp tr
        else evalExp fl

-- data T a where
--   T1 :: Int -> T Int
--   T2 :: T a
--   T3 :: String -> T String
data T :: * -> * where
  T1 :: Int -> T Int
  T2 :: T a
  T3 :: String -> T String

f :: T a -> [Int]
f (T1 n) = [n]
f T2     = []
f (T3 _) = []
