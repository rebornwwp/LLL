{-# LANGUAGE AllowAmbiguousTypes        #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE InstanceSigs               #-}
{-# LANGUAGE MultiParamTypeClasses      #-}
{-# LANGUAGE PolyKinds                  #-}
{-# LANGUAGE ScopedTypeVariables        #-}
{-# LANGUAGE TypeApplications           #-}

module TypeLevelProgramming.PhantomType where

import           Data.Kind  (Type)
import           Data.Proxy (Proxy (..))

{- | https://www.stevenleiva.com/posts/phantom_types
-}
-- Mile and Kilometer 没有data constructor，这样这两个参数在value的level层面是phantom的存在
-- 但是在type-level这两个参数是明显的存在的
data Mile

data Kilometer


-- a is phantom parameters，通过types传入额外的信息
newtype Distance a =
  Distance
    { unDistance :: Double
    }
  deriving (Num)


-- UnitName typeclass 通过 Proxy 感知到level level的PhantomType
-- 输入一个type-level的值，输出term-level的值
-- 增加对 u 的限制，u 只能是一个 Type， 不能是Type -> Type的形式 class UnitName (u :: Type) where
-- Kind variable k means any kind. k can be a Type, Type -> Type or others
class UnitName (u :: k) where
  unitName :: Proxy u -> String


-- 下面两个可以让 PhantomType可以在unitName上执行
instance UnitName Mile where
  unitName :: Proxy Mile -> String
  unitName _ = "Mi"

instance UnitName Kilometer where
  unitName :: Proxy Kilometer -> String
  unitName _ = "Km"


-- 此时 unit type variable 可以在下面的函数体中使用
-- 只是 在对 Distance做一层封装，获取到 Phantomtype
-- 下面可以让unitName可以在 Distance unit执行
instance UnitName unit => UnitName (Distance unit)
 where
  unitName _ = unitName (Proxy :: Proxy unit)


-- 与下面UnitName冲突所以注释掉
-- instance UnitName unit => Show (Distance unit)
--  where
--   show (Distance u) = show u ++ "°" ++ unitName (Proxy :: Proxy unit)

-- introduce a new unit, 这里的这种方式可以让代码易扩展
data Danwei

instance UnitName Danwei
 where
  unitName _ = "Danwei"

unit ::
     forall u. UnitName u
  => Distance u
  -> String
unit _ = unitName (Proxy :: Proxy u)

instance UnitName Distance where
  unitName :: Proxy Distance -> String
  unitName _ = "_unspecified unit_"


-- visible type application
-- read: forall {a}. Read a => String -> a
-- read @Int "42" 手动specify a required type(需要开启 TypeApplications)
-- 我可以看可以看到 read函数需要三个参数才能运行
-- 1. A type variable a of the Type kind—--We can provide it via type application with an @.
-- 2. Read a of the Constraint kind—--It is always injected by GHC.
-- 3. A String value—We provide it as usual.
-- TypeApplications: Type application allows us to provide a specific type at a use site.
-- TypeApplication的方式实现 UnitName
class UnitNameAlt u where
  unitNameAlt :: String

instance UnitNameAlt Mile where
  unitNameAlt :: String
  unitNameAlt = "Mi"

instance UnitNameAlt Kilometer where
  unitNameAlt :: String
  unitNameAlt = "Km"

instance UnitNameAlt Distance where
  unitNameAlt :: String
  unitNameAlt = "_unspecified unit_"

instance UnitNameAlt u => UnitNameAlt (Distance u) where
  unitNameAlt = unitNameAlt @u -- Type Application

instance UnitNameAlt u => Show (Distance u)
 where
  show (Distance t) = show t ++ "°" ++ unitNameAlt @u

unitAlt ::
     forall u. UnitNameAlt u
  => Distance u
  -> String
unitAlt _ = unitNameAlt @u


-- split line
addMilesToKilometers ::
     Distance Mile -> Distance Kilometer -> Distance Kilometer
addMilesToKilometers distanceInMiles distanceInKilometers =
  Distance
    (unDistance distanceInKilometers + unDistance distanceInMiles * 1.60934)

addKilometersToMiles :: Distance Kilometer -> Distance Mile -> Distance Mile
addKilometersToMiles distanceInKilometers distanceInMiles =
  Distance
    (unDistance distanceInMiles + unDistance distanceInKilometers * 0.621371)

class Add a b where
  addDistance :: Distance a -> Distance b -> Distance b

instance Add Mile Kilometer
 where
  addDistance = addMilesToKilometers

instance Add Kilometer Mile
 where
  addDistance = addKilometersToMiles

instance Add Mile Mile

 where
  addDistance = (+)

instance Add Kilometer Kilometer where
  addDistance = (+)

tenMiles = Distance 10 :: Distance Mile

tenKilometers = Distance 10 :: Distance Kilometer

a = addDistance tenMiles tenMiles


-- => Distance {unDistance = 20.0} :: Distance Mile
b = addDistance tenKilometers tenKilometers


-- => Distance {unDistance = 20.0} :: Distance Kilometer
c = addDistance tenMiles tenKilometers


-- => Distance {unDistance = 26.0934} :: Distance Kilometer
d = addDistance tenKilometers tenMiles
-- => Distance {unDistance = 16.21371} :: Distance Mile
