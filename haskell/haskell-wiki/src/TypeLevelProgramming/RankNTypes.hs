{-# LANGUAGE RankNTypes #-}

module TypeLevelProgramming.RankNTypes where

-- 这里会有 a rigid type variable的错误
-- applyToFive :: forall a. (a -> a) -> Int
-- applyToFive f = f 5

applyToFive :: (forall a. a->a) -> Int
applyToFive f = f 5

-- arbitrary-rank polymorphism 任意秩多态性
processInts1 ::
     forall a. Num a
  => (a -> a)
  -> [Int]
  -> [Int]
processInts1 = undefined

f :: Double -> Double
f = undefined

x :: [Int]
x = processInts1 f [1, 2]

processInts2 ::
     (forall a. Num a =>
                  a -> a)
  -> [Int]
  -> [Int]
processInts2 f xs = undefined

-- (Int->Int) -> [Int] -> [Int]                            ===> rank 0, nonpolymorphic function
-- forall a. Num a => a -> a -> [Int] -> [Int]             ===> rank 1
-- (forall a. Num a => a -> a) -> [Int] -> [Int]           ===> rank 2
-- ((forall a.Num a => a -> Int) -> Int) -> [Int] -> [Int] ===> rank 3
-- note:
-- the RankNTypes GHC extension makes type inference impossible in general.
-- 类型推断将会变得有问题, 所以总是要使用顶层的type signature
-- 问题两种都是可行的吗? 为什么不用第一种呢?
newtype NumModifier =
  NumModifier
    { run :: forall a. Num a =>
                         a -> a
    }

-- 另外一种写法：(forall a. SomeClass a => <function over a>) -> <other arguments and result>
-- thus allowing us to apply a rank-2 polymorphic argument to them. As a result, we are limited to functions
-- that work for every SomeClass a value.
processInts :: NumModifier -> [Int] -> [Int]
processInts nm xs = map (run nm) xs

-- a rank-3 polymorphic function
-- the first argument (forall a. IO a -> IO a) -> IO b is rank-2 polymorphic.
-- We have an IO computation, forall a. IO a -> IO a—let’s call it an inner computation.
-- There is also an outer computation, (forall a. IO a -> IO a) -> IO b, which is able to run the inner computation inside it.
-- We have the mask function, which returns a result of an outer computation.
-- 1 We implement an outer computation, which does the following:
-- – Creates (or acquires somehow) some value of any type it needs in the IO monad
-- – Applies a given inner computation to that value (or any IO computation over it)
-- – Produces some final result of type b
-- 2 The mask function executes that outer computation by providing it some particular inner computation.
mask :: ((forall a. IO a -> IO a) -> IO b) -> IO b
mask f = undefined
-- rank-2 polymorphism with phantom types
-- mymap :: forall a b. (a -> b) -> [a] -> [b]
-- mymap _ []     = []
-- mymap f (x:xs) = (f x :: b) : mymap f xs
-- It is crucial to understand the main Haskell components of type-level programming: terms, types, and kinds.
-- Data constructors can be promoted to types and type constructors to kinds by the DataKinds GHC extension.
-- Use type families to describe generic interfaces to libraries and hide an implementation behind type class instances.
-- Use generalized algebraic data types (GADTs) to control values of different types under one GADT umbrella.
-- Learn the main ways to use higher-ranked polymorphism in industrial Haskell.
-- Help the compiler by providing explicit type signatures.
-- Ask the compiler for help with types.
