{-# LANGUAGE AllowAmbiguousTypes        #-}
{-# LANGUAGE DataKinds                  #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE KindSignatures             #-}

module TypeLevelProgramming.DataKinds.TempKinds where

import           Data.Proxy   (Proxy (..))
import           GHC.TypeLits (KnownNat, KnownSymbol, Nat, Symbol, natVal,
                               symbolVal)


-- With DataKinds enabled, this line defines both the TempUnits data type with values F and C
-- and the TempUnits kind with types F ('F) and C ('C) belonging to it
-- 通过 这种方式，我们将 F C 进阶到 Type， TempUnits进阶到Kind
-- The DataKinds GHC extension promotes data type definitions to the level of types as
-- follows:
--  Type constructors become kind constructors.
--  Data constructors become type constructors.
-- the ' prefix is used to mention a type and not a value.
data TempUnits
  = F
  | C

newtype Temp (u :: TempUnits) =
  Temp Double
  deriving (Num, Fractional)

paperBurning :: Temp 'F
paperBurning = 451

absoluteZero :: Temp 'C
absoluteZero = -273.15

f2c :: Temp F -> Temp C
f2c (Temp f) = Temp ((f - 32) * 5 / 9)

class UnitName (u :: TempUnits) where
  unitName :: String

instance UnitName F where
  unitName :: String
  unitName = "F"

instance UnitName C where
  unitName :: String
  unitName = "C"

instance UnitName u => Show (Temp u) where
  show :: Temp u -> String
  show (Temp t) = show t ++ "XXX" ++ unitName @u

unit ::
     forall u. UnitName u
  => Temp u
  -> String
unit _ = unitName @u

printTemp ::
     forall u. UnitName u
  => Temp u
  -> IO ()
printTemp t = do
  putStrLn $ "Temperature: " ++ show t
  putStrLn $ "Units: " ++ unit t

testmain1 :: IO ()
testmain1 = do
  printTemp paperBurning
  printTemp absoluteZero


-- type level literals
-- Nat for natural numbers, such as 0, 1, 2,…—These literals become types under promotion.
-- Symbol for strings, such as "hello" and "bye"—These literals become types, too
-- :set -XDataKinds -XNoStarIsType
-- :kind 42
-- :kind Nat
-- :kind "hello"
-- :kind Symbol
-- :kind []
-- :kind [Int, String, Bool]
-- :kind '[Int, String, Bool]
--
-- For example, the Pointer 2 value of the Pointer 4 type corresponds to the pointer value 8.
newtype Pointer (align :: Nat) =
  Pointer Integer

zeroPtr :: Pointer n
zeroPtr = Pointer 0

inc :: Pointer align -> Pointer align
inc (Pointer p) = Pointer (p + 1)


-- 使用knownNat和natVal来实现align从type level到term level的转换, 在函数层面使用
-- The KnownNat type class defines the natVal method, which takes a type-level
-- natural literal to its term-level integer counterpart.
-- The natVal method takes Proxy (from Data.Proxy) as an argument. This
-- means that we are interested not in a value but in a type, namely, the align type variable.
ptrValue ::
     forall align. KnownNat align
  => Pointer align
  -> Integer
ptrValue (Pointer p) = p * natVal (Proxy :: Proxy align)

maybePtr ::
     forall align. KnownNat align
  => Integer
  -> Maybe (Pointer align)
maybePtr p
  | remainder == 0 = Just (Pointer quotient)
  | otherwise      = Nothing
  where
    (quotient, remainder) = divMod p (natVal (Proxy :: Proxy align))

newtype SuffixedString (suffix :: Symbol) =
  SS String

suffixed :: String -> SuffixedString suffix
suffixed s = SS s

asString ::
     forall suffix. KnownSymbol suffix
  => SuffixedString suffix
  -> String
asString (SS str) = str ++ "@" ++ symbolVal (Proxy :: Proxy suffix)
