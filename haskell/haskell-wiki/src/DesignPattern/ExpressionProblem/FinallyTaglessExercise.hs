{-# LANGUAGE RankNTypes #-}

module DesignPattern.ExpressionProblem.FinallyTaglessExercise where

import           Prelude hiding (and, or)

class Language r where
  here :: r (a, h) a
  before :: r h a -> r (any, h) a
  lambda :: r (a, h) b -> r h (a -> b)
  apply :: r h (a -> b) -> (r h a -> r h b)
  loop :: r h (a -> a) -> r h a
  int :: Int -> r h Int
  add :: r h Int -> r h Int -> r h Int
  -- | \x -> x - 1
  down :: r h Int -> r h Int
  -- | \x -> x + 1
  up :: r h Int -> r h Int
  mult :: r h Int -> r h Int -> r h Int
  -- greater than or equal
  gte :: r h Int -> r h Int -> r h Bool
  bool :: Bool -> r h Bool
  and :: r h Bool -> r h Bool -> r h Bool
  or :: r h Bool -> r h Bool -> r h Bool
  neg :: r h Bool -> r h Bool
  -- if true then return left term, else return right term
  ifte :: r h Bool -> r h a -> r h a -> r h a

type Term a = forall r h. Language r => r h a

newtype Eval h a = Eval
  { eval :: h -> a
  }

td1 :: Term Int
td1 = add (int 1) (int 1)

instance Language Eval
 where
  here        = Eval $ \(a, h) -> a
  before e    = Eval $ \(a, h) -> eval e h
  lambda e1   = Eval $ \h a -> eval e1 (a, h)
  apply e1 e2 = Eval $ \h -> (eval e1 h) (eval e2 h)
  loop f      = Eval $ \h -> fx (eval f h)
    where
      fx f   = f (fx f)
  int x      = Eval $ const x
  add e1 e2  = Eval $ \h -> eval e1 h + eval e2 h
  down e     = Eval $ \h -> eval e h - 1
  up e       = Eval $ \h -> eval e h + 1
  mult e1 e2 = Eval $ \h -> eval e1 h * eval e2 h
  gte e1 e2  = Eval $ \h -> eval e1 h >= eval e2 h
  bool e     = Eval $ const e
  and e1 e2  = Eval $ \h -> eval e1 h && eval e2 h
  or e1 e2   = Eval $ \h -> eval e1 h || eval e2 h
  neg e1     = Eval $ \h -> not (eval e1 h)
  ifte cond e1 e2 =
    Eval $ \h ->
      if eval cond h
        then eval e1 h
        else eval e2 h

interpret :: Term a -> a
interpret t = eval t ()
