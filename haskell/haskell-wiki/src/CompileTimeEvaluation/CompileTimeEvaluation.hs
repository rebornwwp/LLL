{-# LANGUAGE DataKinds              #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE ScopedTypeVariables    #-}
{-# LANGUAGE TypeApplications       #-}
{-# LANGUAGE TypeFamilies           #-}
{-# LANGUAGE TypeOperators          #-}
{-# LANGUAGE UndecidableInstances   #-}

module CompileTimeEvaluation.CompileTimeEvaluation where

-- Conclusion:
-- Compile-time evaluation in Haskell is easily achieved with Template Haskell.
-- Sometimes type families do a better job, but their performance is unreliable.
-- Functional dependencies are the most esoteric approach, but it also works 
-- in limited circumstances.
import           Data.Proxy   (Proxy (Proxy))
import           GHC.Natural  (Natural)
import           GHC.TypeLits (KnownNat, Nat, natVal, type (+), type (-))

fib :: Natural -> Natural
fib 0 = 0
fib 1 = 1
fib k = fib (k - 2) + fib (k - 1)


--  type checking performance 不稳定，
type family Fib (n :: Nat) :: Nat
 where
  Fib 0 = 0
  Fib 1 = 1
  Fib k = Fib (k - 2) + Fib (k - 1)


-- Function to print the Fibonacci number for a given type-level Nat
printFib ::
     forall n. KnownNat (Fib n)
  => Proxy n
  -> IO ()
printFib _ = putStrLn $ "Fib " ++ show (natVal (Proxy @(Fib n)))


-- Functional dependencies
class Fiba (n :: Nat) (r :: Nat) | n -> r

instance Fiba 0 0

instance Fiba 1 1

instance {-# OVERLAPPABLE #-} ( Fiba (k - 1) f1
                              , Fiba (k - 2) f2
                              , EQUALS r (f1 + f2)
                              ) =>
                              Fiba k r

class EQUALS (a :: Nat) (b :: Nat) | a -> b, b -> a

instance EQUALS a a

printFiba ::
     forall n f. (KnownNat n, KnownNat f, Fiba n f)
  => Proxy n
  -> IO ()
printFiba _ =
  putStrLn $
  "Fib " ++ show (natVal (Proxy @n)) ++ " = " ++ show (natVal (Proxy @f))
