{-# LANGUAGE RoleAnnotations #-}

module TypeLevelProgramming.CoerceTypes where

import           Control.Monad.RWS (Product (Product), Sum (Sum, getSum))
import           Data.Coerce       (Coercible, coerce)

-- summary:
-- 通过coerce实现对一中数据类型的重新解析到另外一种数据类型
-- 并且haskell对类型参数（type parameter）进行了role的划分，此方式可以保证coerce的安全
-- 一般来说划分成representational就是安全的

-- 主要针对newtype关键字的使用，此关键字可以保证zero-cost，并且将一种类型的值重新解析成另外一种类型的值，并且可以无操作消耗的进行操作
-- coerce can be used to massage data from one type into
-- another without paying any runtime cost.
-- coerce :: Coercible a b => a -> b
-- coerce = undefined
slowSum :: [Int] -> Int
slowSum = getSum . mconcat . fmap Sum

fastSum :: [Int] -> Int
fastSum = getSum . mconcat . coerce

-- slowSum: O(n)
-- fastSum: O(0)
-- coerce transform [Int] into [Sum Int] in O(n) time
--
-- Coercible corresponds to representational equality
-- 三条laws：
-- reflexivity - coercible a a is true for any type a
-- Symmetry - Coercible a b implies Coercible b a
-- transitivity - given Coercible a b and Coercible b c we have Coercible a c
--
-- best way to transform a Sum a into a Product a
x :: Product Int
x = coerce (1867 :: Sum Int) :: Product Int

-- 举一个例子：
-- 比如 Map k v，在使用中由于k的ord属性会影响到内存中存储的位置，所以什么位置放什么都是确定好的
-- 此时我们可以通过k的 Ord 属性来确定内存里面的放置地方, 下面使用Reverse a 来实例化，Ord，这样就能影响
-- 在内存中的位置，并且此操作是zero-cost的， 此方式
newtype Reverse a =
  Reverse
    { getReverse :: a
    }
  deriving (Eq, Show)

instance Ord a => Ord (Reverse a) where
  compare (Reverse a) (Reverse b) = compare b a

-- Role system
-- as the type system ensures terms are used correctly,
-- and the kind system ensures types are logical,
-- the role system ensures coercions are safe.
--
-- Every type parameter for a given type constructor is assigned a role
-- 三种role
-- nominal—the everyday notion of type-equality in Haskell,
-- * corresponding to the a ∼ b constraint.
-- 例子：For example, Int is nominally equal only to itself.
--
-- * representational—as discussed earlier in this chapter; types a
-- and b are representationally equal if and only if it’s safe to
-- reinterpret the memory of an a as a b.
-- 例子:Sum a, we say that a is at role representational;
-- Either a b
--
-- * phantom—two types are always phantom-ly equal to one another.
-- 例子 data Proxy a = Proxy
-- haskell是通过编译器来推测role的
-- 首先所有的type parameter都会默认为phantom role
-- 然后 The type constructor (->) has two representational roles,
--      any type parameter applied to a (->) gets upgraded to representational
-- 最后 The type constructor (∼) has two nominal roles; any type
--      parameter applied to a (∼) gets upgraded to nominal. GADTs
--      and type families count as applying (∼).
-- 一般是编译器推测role，也可以手动设置role
-- 并且叫做: role signature
data BST v
  = Empty
  | Branch (BST v) v (BST v)

type role BST nominal
