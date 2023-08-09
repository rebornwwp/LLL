{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE RoleAnnotations            #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE TypeFamilies               #-}

---
-- {-#LANGUAGE  #-}
module MetaProgramming.Corece where

import           Control.Monad.State (MonadIO, StateT)
import           Data.Coerce         (coerce)
import           Unsafe.Coerce       (unsafeCoerce)


-- 针对newtype数据的特殊使用方式，由于newtype的数据与实际表示的数据在runtime阶段是一样
newtype Age =
  Age Int
  deriving (Show)

toAges :: [Int] -> [Age]
toAges = map Age -- 两个其实是相同的，如果直接执行，将会导致编译器没法优化


-- If we have types that share the same run-time representation,
-- we can coerce between them.
toAgesCore :: [Int] -> [Age]
toAgesCore = coerce


-- coerce :: forall (k :: RuntimeRep) (a :: TYPE k) (b :: TYPE k).
-- Coercible a b => a -> b
-- 使用上面的方式ghc将会对 Coercible 进行instance操作，从而产生 coercible Age Int 的代码
-- 同时也会转换一个instance Coercible [Age] [Int], 有了这个之后就可以使用coerce函数了
--
-- We have Coercible (Student Int) (Student Age) lifted from Coercible Int
data Student ageType =
  Student String ageType

check :: Student Int -> Student Age
check = coerce

data Student1 ageType =
  Student1 String (Maybe ageType)

check1 :: Student1 Int -> Student1 Age
check1 = coerce


--这个情况不能使用
-- data Student2 m ageType =
--   Student2 String (m ageType)

-- check2 :: Student2 Maybe Int -> Student2 Maybe Age
-- check2 = coerce
type family Id t

type instance Id t = t

data Student3 ageType =
  Student3 String (Id ageType)

check3 :: Student3 Int -> Student3 Age
check3 = unsafeCoerce

-------------------------------------------
type role Student4 nominal

data Student4 ageType =
  Student4 String ageType

-------------------------------------------
-- 下面的数据类型，将使用 coerce 加入到代码的生成
newtype AgeN =
  AgeN Int
  deriving newtype (Eq, Ord)

newtype MyApp a =
  MyApp
    { runApp :: StateT Int IO a
    }
  deriving (Functor, Applicative, Monad, MonadIO)


-- 带有coerce的代码, 将会有编译器生成
-- instance Functor MyApp
--     fmap :: forall a b. (a -> b) -> MyApp a -> MyApp b
--     fmap = coerce (fmap :: (a -> b) -> StateT Int IO a -> StateT Int IO b)
---
type family Inspect t

type instance Inspect Int = Bool

type instance Inspect AgeN = Int

class Inspector a where
  inspect :: a -> Inspect a

instance Inspector Int
 where
  inspect n = n > 0
