{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE FlexibleInstances #-}

module Calc where

import ExprT
import Parser
import StackVM

-- exercise 1
eval :: ExprT -> Integer
eval (ExprT.Lit x) = x
eval (ExprT.Add expr1 expr2) = eval expr1 + eval expr2
eval (ExprT.Mul expr1 expr2) = eval expr1 * eval expr2

-- exercise 2
evalStr :: String -> Maybe Integer
evalStr = fmap eval . parseExp ExprT.Lit ExprT.Add ExprT.Mul

-- exercise 3
class Expr a where
  lit :: Integer -> a
  add :: a -> a -> a
  mul :: a -> a -> a

instance Expr ExprT where
  lit = ExprT.Lit
  add = ExprT.Add
  mul = ExprT.Mul

reify :: ExprT -> ExprT
reify = id

-- exercise 4
instance Expr Integer where
  lit = id
  add = (+)
  mul = (*)

instance Expr Bool where
  lit = (> 0)
  add = (||)
  mul = (&&)

newtype MinMax = MinMax Integer deriving (Eq, Show)

newtype Mod7 = Mod7 Integer deriving (Eq, Show)

instance Expr MinMax where
  lit = MinMax
  add (MinMax i1) (MinMax i2) = MinMax(max i1 i2)
  mul (MinMax i1) (MinMax i2) = MinMax(min i1 i2)

instance Expr Mod7 where
  lit = Mod7
  add (Mod7 x) (Mod7 y) = Mod7 ((x + y) `mod` 7)
  mul (Mod7 x) (Mod7 y) = Mod7 ((x * y) `mod` 7)

testExp :: Expr a => Maybe a
testExp = parseExp lit add mul "(3 * -4) + 5"

testInteger  = testExp :: Maybe Integer
testBool = testExp :: Maybe Bool
testMM = testExp :: Maybe MinMax
testSat = testExp :: Maybe Mod7

-- exercise 5
instance Expr Program where
  add e1 e2 = e1 ++ e2 ++ [StackVM.Add]
  mul e1 e2 = e1 ++ e2 ++ [StackVM.Mul]
  lit e1 = [PushI e1]

compile :: String -> Maybe Program
compile str = parseExp lit add mul str :: Maybe Program

main :: IO ()
main = do
  print $ eval (ExprT.Mul (ExprT.Add (ExprT.Lit 2) (ExprT.Lit 3)) (ExprT.Lit 4))
  print $ fmap eval $ parseExp ExprT.Lit ExprT.Add ExprT.Mul "2+3*3"
  print $ evalStr "2+3*3"
  print $ evalStr "2+3*"
  print $ reify $ mul (add (lit 2) (lit 3)) (lit 4)
  print testInteger
  print testBool
  print testMM
  print testSat
  print $ compile "2+3*3"
