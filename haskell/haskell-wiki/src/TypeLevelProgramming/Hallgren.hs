{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE NoImplicitPrelude      #-}
{-# LANGUAGE UndecidableInstances   #-}

module TypeLevelProgramming.Hallgren where

{-
论文中给出了type组织value， class来组织type，通过对class的合理运用，可以在type level进行computation
具体是将type与value对应关系，相同代码反应到type-level上， 通过type-checker来执行结果，triggle的方式下面的例子是通过isOdd or isEven
-}

import           GHC.Base (undefined)
import           RIO      hiding (even, odd)

data Nat
  = Zero
  | Succ Nat

three = Succ (Succ (Succ Zero))

even Zero     = True
even (Succ n) = odd n

odd Zero     = False
odd (Succ n) = even n

data True

data False

data Zero

data Succ n

type Three = Succ (Succ (Succ Zero))

type Four = Succ Three


-- class Even n where
--   isEven :: n
-- class Odd n where
--   isOdd :: n
-- instance Even Zero
-- instance Odd n => Even (Succ n)
-- instance Even n => Odd (Succ n)
-- x = isEven :: Four
-- y = isOdd :: Three
--
--
-- class Even n b where
--   isEven :: n -> b
-- class Odd n b where
--   isOdd :: n -> b
-- instance Even Zero True
-- instance Odd Zero False
-- instance Odd n b => Even (Succ n) b
-- instance Even n b => Odd (Succ n) b
-- x = isEven (undefined :: Four) :: True
-- y = isOdd (undefined :: Three) :: True
class Even n b | n -> b where
  isEven :: n -> b

class Odd n b | n -> b where
  isOdd :: n -> b

instance Even Zero True

instance Odd Zero False

instance Odd n b => Even (Succ n) b

instance Even n b => Odd (Succ n) b

x = isEven (undefined :: Four) :: True

y = isOdd (undefined :: Three) :: True

z = isEven (undefined :: Three) :: False

class Add a b c | a b -> c where
  add :: a -> b -> c

instance Add Zero b b

instance Add a b c => Add (Succ a) b (Succ c)

class Mul a b c | a b -> c where
  mul :: a -> b -> c

instance Mul Zero b Zero

instance (Mul a b c, Add b c d) => Mul (Succ a) b d


-- Mixing static and dynamic computations
type One = Succ Zero

class Pow a b c | a b -> c where
  pow :: a -> b -> c

instance Pow a Zero One

instance (Pow a b c, Mul a c d) => Pow a (Succ b) d

class Pred a b | a -> b where
  pred :: a -> b

instance Pred (Succ n) n

class Power n where
  power :: Int -> n -> Int

instance Power Zero
 where
  power _ _ = 1

instance Power n => Power (Succ n)
 where
  power x n = x * power x (pred n)

zz = power 2 (mul (undefined :: Three) (undefined :: Three))
