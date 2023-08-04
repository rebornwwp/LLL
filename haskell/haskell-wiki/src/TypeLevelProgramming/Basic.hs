{-# LANGUAGE DataKinds            #-}
{-# LANGUAGE GADTs                #-}
{-# LANGUAGE TypeFamilies         #-}
{-# LANGUAGE TypeOperators        #-}
{-# LANGUAGE UndecidableInstances #-}
{-# OPTIONS_GHC -Wunticked-promoted-constructors #-}

module TypeLevelProgramming.Basic where


-- https://www.parsonsmatt.org/2017/04/26/basic_type_level_programming_in_haskell.html
-- https://serokell.io/blog/datakinds-are-not-what-you-think
-- 2016年版本之后的修改
data HigherKinded f a
  = Bare a
  | Wrapped (f a)


-- HigherKinded is a type that accepts a type of kind * -> *, and a type of kind *, and returns a type of kind *

-- * matches any type that has values

-- > :kind Void
data Void


-- In the same way that you can productively program at the value level with dynamic types, you can productively program at the type level with dynamic kinds. And * is basically that!

-- type level numbers
data ZeroA

data SuccA a

type OneA = SuccA ZeroA

type TwoA = SuccA OneA

type ThreeA = SuccA TwoA

type FourA = SuccA (SuccA (SuccA (SuccA ZeroA)))


-- kind safe type level number
data Nat
  = Zero
  | Succ Nat


-- 重点:

-- In plain Haskell
-- this definition introduces
-- a new type Nat with two value constructors,
-- Zero and Succ (which takes a value of type Nat).
-- With the DataKinds extension,
-- We get a new kind Nat,
-- which exists in a separate namespace.
-- And we get two new types:
--   a type constant 'Zero, which has the kind Nat,
--   and a type constructor 'Succ, which accepts a type of kind Nat.
-- It’s important to note that there are no values of type 'Zero. The only kind that can have types that can have values is *
-- 例如：length indexed Vector 引入list的长度到type system。

-- 可以帮助我们静态的避免的越界(out-of-bounds)错误

-- 不带haskell的inference
-- data Vector (n :: Nat) -- length index
--                                        a :: * -- the type of values containers in vecotr
--       where
-- 带上inference，可以省略一些代码
data Vector n a where
  VNil :: Vector 'Zero a
  VCons :: a -> Vector n a -> Vector ('Succ n) a

instance Show a => Show (Vector n a)
 where
  show VNil         = "VNil"
  show (VCons i as) = "VCons " ++ show i ++ " (" ++ show as ++ ")"


-- functions that operate on types are called type families

-- define type functions
-- There are two ways to write a type family:
-- open, where anyone can add new cases,
-- and closed, where all the cases are defined at once.
-- add function at at the value level
add :: Nat -> Nat -> Nat
add Zero n     = n
add (Succ n) m = add n (Succ m)


-- add function at the type level with closed type families
type family Add n m
 where
  Add 'Zero n     = n
  Add ('Succ n) m = 'Succ (Add n m)

append :: Vector n a -> Vector m a -> Vector (Add n m) a
append VNil xs           = xs
append (VCons a rest) xs = VCons a (append rest xs)


-- Heterogeneous Lists
data HList xs where
  HNil :: HList '[]
  HCons :: a -> HList as -> HList (a ': as)


-- instance Show (HList xs)
--  where
--   show HNil           = "HNil"
--   show (HCons x rest) = "_ ::: " ++ show rest
newtype s >> a =
  Named a
