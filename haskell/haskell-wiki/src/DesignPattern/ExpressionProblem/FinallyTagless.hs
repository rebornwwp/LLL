{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE GADTs                #-}
{-# LANGUAGE TypeSynonymInstances #-}

module DesignPattern.ExpressionProblem.FinallyTagless where


-- https://zhuanlan.zhihu.com/p/626910231
-- https://zhuanlan.zhihu.com/p/53810286
-- https://zhuanlan.zhihu.com/p/22231273?refer=marisa
data Exp
  = Lit Int
  | Add Exp Exp

eval :: Exp -> Int
eval (Lit n)   = n
eval (Add a b) = eval a + eval b


-- Finally Tagless
-- data Expr a where
--   Lita :: Int -> Expr Int
--   Adda :: Expr Int -> Expr Int -> Expr Int

-- | a -> expr
class Visitor a where
  int :: Int -> a
  add :: a -> a -> a

instance Visitor Int
 where
  int = id
  add = (+)

instance Visitor String
 where
  int     = show
  add a b = "(" ++ a ++ " + " ++ b ++ ")"

sampleAst :: Visitor m => m
sampleAst =
  add (add (int 114) (int 514)) (add (int 1926) (add (int 8) (int 17)))

evaluatedAst = sampleAst :: Int

dumpedAst = sampleAst :: String

class Visitor a =>
      SubVisitor a
  where
  sub :: a -> a -> a

instance SubVisitor Int
 where
  sub = (-)

instance SubVisitor String
 where
  sub l r = "(" ++ l ++ " - " ++ r ++ ")"

sampleAst' :: SubVisitor m => m
sampleAst' = sub (int 2) (int 1)

evaluatedAst' = sampleAst' :: Int

dumpedAst' = sampleAst' :: String


-- | 再包一层
newtype Eval a = Eval
  { runEval :: a
  }

instance Visitor (Eval Int)
 where
  int                   = Eval
  add (Eval x) (Eval y) = Eval (x + y)

newtype Pretty a = Pretty
  { runPretty :: String
  }

instance Visitor (Pretty a)
 where
  int                       = Pretty . show
  add (Pretty x) (Pretty y) = Pretty (x <> " + " <> y)

data Tree a
  = Leaf String a
  | Node String [Tree a]
  deriving (Show, Eq)

instance Visitor (Tree Int)
 where
  int x   = Leaf "val" x
  add x y = Node "add" [x, y]

-- >>> exp1
-- 3
exp1 :: Int
exp1 = runEval $ add (int 1) (int 2)


-- >>> exp2
-- "1 + 2"
exp2 :: String
exp2 = runPretty $ add (int 1) (int 2)


-- >>> exp3
-- Node "add" [Leaf "val" 2,Leaf "val" 3]
exp3 :: Tree Int
exp3 = add (int 2) (int 3)

maintest :: IO ()
maintest = do
  print evaluatedAst
  print dumpedAst
