{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE GADTs                     #-}
{-# LANGUAGE KindSignatures            #-}

module TypeLevelProgramming.GADTExample where

import           Control.Exception (Exception)
import           Data.Kind         (Type)


-- GADTs allow keeping and using information about types after constructing a value.
-- 动态类型 dynamical types
-- what is generalized?
data Dyn
  = SA String
  | CA Char
  | BA Bool

data DynValue a where
  S :: String -> DynValue String
  C :: Char -> DynValue Char
  B :: Bool -> DynValue Bool


-- 如果不使用GADT，下面的函数将会很难构建
getValue :: DynValue a -> a
getValue (B b) = b
getValue (C c) = c
getValue (S s) = s

printValue :: DynValue a -> IO ()
printValue (B b) = print b
printValue (C c) = print c
printValue (S s) = print s


-- >>> mapM_ printValue [S "hello", S "bye"]
-- 此方式下可以正常运行，但是对[S "hello", B True] 使用此函数将会错误
--

-- that there is no parameter in the WrappedDynValue type. 没有类型参数了
-- 将多种类型 DynValue String、DynValue Bool、DynValue Char 封装成同一种类型，此类型没有类型参数
-- The a type variable used in the Wrap constructor is traditionally called existential(存在变量)
-- existential 存在一个value种
data WrappedDynValue where
  Wrap :: DynValue a -> WrappedDynValue


-- existential type example
data SomeException =
  forall e. Exception e =>
            SomeException e


-- exstential type example with a GADT
data SomeExceptionGADT where
  SomeExceptionGADT :: Exception e => e -> SomeExceptionGADT

fromString :: String -> WrappedDynValue
fromString str
  | str `elem` ["y", "yes", "true"] = Wrap (B True)
  | str `elem` ["n", "no", "false"] = Wrap (B False)
  | length str == 1                 = Wrap (C $ head str)
  | otherwise                       = Wrap (S str)

printWDValue :: WrappedDynValue -> IO ()
printWDValue (Wrap dv) = printValue dv


-- >>> printWDValue (fromString "y")
-- >>> printWDValue (fromString "hello")
-- 下面其实是对[WrappedDynValue]做mapM_的操作
-- >>> mapM_ (printWDValue . fromString) ["y", "no", "xxx", "c"]

-- 上面例子的总结
-- We get additional control by keeping specific types as parameters to a GADT type constructor.
-- We can always get back to the original types and do whatever they support.
-- We can use *existential typing techniques* to build GADTs from other types and pass those wrapped types around until we need the power of original types.
-----------------------------------------------------------------

--  https://www.stevenleiva.com/posts/gadts
-- GADTs give us a new tool by which to communicate
-- from the term layer to the type layer. The data
-- constructors at the term layer can be used to
-- determine the type (at the type layer).

-- The ability of GADTs to convey information from
-- the term layer - via the data constructors -
-- to the type layer is how they change the game!
-- vanilla haskell
-- a closed data family,
data List a
  = Empty
  | Cons a (List a)

data ListG a where
  EmptyG :: ListG a
  ConsG :: a -> ListG a -> ListG a

data Term a where
  Lit :: a -> Term a
  Succ :: Term Int -> Term Int
  IsZero :: Term Int -> Term Bool
  If :: Term Bool -> Term a -> Term a -> Term a

eval :: Term a -> a
eval (Lit i) = i
eval (Succ t) = 1 + eval t
eval (IsZero i) = eval i == 0
eval (If b e1 e2) =
  if eval b
    then eval e1
    else eval e2

example :: Int
example = eval (Succ (Succ (Lit 3)))


-- using Constraints
data Exp a
  = (a ~ Int) =>
    LitInt a
  | (a ~ Bool) =>
    LitBool a
  | forall b. (b ~ Bool) =>
              LitIf (Exp b) (Exp a) (Exp a)

evalExp :: Exp a -> a
evalExp e =
  case e of
    LitInt i -> i
    LitBool b -> b
    LitIf b tr fl ->
      if evalExp b
        then evalExp tr
        else evalExp fl


-- data T a where
--   T1 :: Int -> T Int
--   T2 :: T a
--   T3 :: String -> T String
data T :: * -> * where
  T1 :: Int -> T Int
  T2 :: T a
  T3 :: String -> T String

f :: T a -> [Int]
f (T1 n) = [n]
f T2     = []
f (T3 _) = []
