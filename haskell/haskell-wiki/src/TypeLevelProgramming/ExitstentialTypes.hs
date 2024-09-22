{-# LANGUAGE KindSignatures       #-}
{-# LANGUAGE RankNTypes           #-}
{-# LANGUAGE TypeApplications     #-}
{-# LANGUAGE UndecidableInstances #-}

module TypeLevelProgramming.ExitstentialTypes where

import           Control.Applicative (asum)
import           Data.Data           (Typeable, cast)
import           Data.Kind           (Constraint, Type)
import           Data.Maybe          (fromMaybe)


-- Existential Types
-- This a type exists only within the context of the Any data constructor; it is existential.
-- 这里 类型变量 a 只存在 data constructor中，在type constructor中并不存在，此时a被叫做existential, 并且严格执行这样的方式
data Any =
  forall a. Any a


-- GADT 定义existential type的方式
data AnyA where
  AnyA :: a -> AnyA

x = [Any 5, Any "string"]


-- 此为一个eliminator函数，可以消除 Any 类型
-- Existential types can be eliminated (consumed) via continuationpassing. An eliminator is a rank-2 function
-- which takes an existential type and a continuation that can produce a value regardless of what it gets
-- elimAny is a Rank-2 function
-- 这里传入函数的输入a类型，由 Any中的值决定
elimAny :: (forall a. a -> r) -> Any -> r
elimAny f (Any a) = f a


-- 这里也是一个exitential type 但是这里 Show t是一个constraint
data HasShow where
  HasShow :: Show t => t -> HasShow

elimHasShow :: (forall a. Show a => a -> r) -> HasShow -> r
elimHasShow f (HasShow a) = f a


-- Dynamic Types
-- The Typeable class
-- provides type information at runtime, and allows for dynamic
-- casting via cast :: (Typeable a, Typeable b) => a -> Maybe b.
-- 通过这样能像python那样动态类型的编译
data Dynamic where
  Dynamic :: Typeable t => t -> Dynamic

elimDynamic :: (forall a. Typeable a => a -> r) -> Dynamic -> r
elimDynamic f (Dynamic a) = f a

fromDynamic :: Typeable a => Dynamic -> Maybe a
fromDynamic = elimDynamic cast

liftD2 ::
     forall a b r. (Typeable a, Typeable b, Typeable r)
  => Dynamic
  -> Dynamic
  -> (a -> b -> r)
  -> Maybe Dynamic
liftD2 d1 d2 f = fmap Dynamic . f <$> fromDynamic @a d1 <*> fromDynamic @b d2

pyPlus :: Dynamic -> Dynamic -> Dynamic
pyPlus a b =
  fromMaybe (error "bad types for pyPlus")
    $ asum
        [ liftD2 @String @String a b (++)
        , liftD2 @Int @Int a b (+)
        , liftD2 @String @Int a b $ \strA intB -> strA ++ show intB
        , liftD2 @Int @String a b $ \intA strB -> show intA ++ strB
        ]


-- dynamically typed languages are merely strongly typed languages with a single type.
--
--Generalized Constraint Kinded Existentials
-- 上面的 HasShow 和 Dynamic其实具有相同的数据样子，其实可以在kind层级对kind进行constraint
data Has (c :: Type -> Constraint) where
  Has :: c t => t -> Has c

type HasShow' = Has Show

type Dynamic' = Has Typeable


-- 类型的多个typeclass的 constraint
-- 错误方式：将会有错误
-- type MonoidAndEq a = (Monoid a, Eq a)
-- xx = Has [True] :: Has MonoidAndEq
-- 如下正确使用方式是：constraint synonym
class (Monoid a, Eq a) =>
      MonoidEq a

instance (Monoid a, Eq a) => MonoidEq a

isMempty :: (Monoid a, Eq a) => a -> Bool
isMempty a = a == mempty

foo = Has [True] :: Has MonoidEq
