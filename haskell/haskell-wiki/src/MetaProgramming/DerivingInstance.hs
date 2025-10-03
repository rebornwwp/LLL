{-# LANGUAGE DeriveAnyClass             #-}
{-# LANGUAGE DeriveGeneric              #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE GeneralisedNewtypeDeriving #-}

module MetaProgramming.DerivingInstance where

import           Data.Aeson   (ToJSON, encode)
import           GHC.Generics (Generic)


-- If something goes wrong, we can look at the code that was generated for us. GHC supports
-- the `-ddump-deriv` flag to dump all the generated instances.
-- ghci >>> :set -ddump-deriv 可以查看deriving机制自动生成代码
type Name1 = String

type Age1 = Int

data Student1 =
  Student1 Name1 Age1
  deriving (Eq)


-- deriving strategies
-- GHC supports the following strategies to derive instances:
--  `stock` strategy refers to specific type classes with deriving algorithms built into GHC.
--     Show
--  `anyclass` strategy allows us to derive empty instances. No methods are generated for them. This makes more sense if we have default implementations in type class definitions.
--     ToJSON  requires Generic So need DeriveGeneric and DeriveAnyClass
--  `newtype` strategy supports generating instances for newtype declarations. The code for those instances is the same as the code for the underlying types.
--     Num > Requires GeneralizedNewtypeDeriving
--  `via` strategy allows us to give an example of how the code should be generated. GHC then follows an example and generates code correspondingly. This strategy is the most recent one; it has been available since GHC 8.6.
newtype Age =
  Age
    { age :: Int
    }
  deriving (Show, Generic) -- stock
  deriving newtype (Num)
  deriving anyclass (ToJSON)

theAge :: Age
theAge = 33


-- 此方式将会有相关的warning错误需要注意
newtype AgeA =
  AgeA
    { ageA :: Int
    }
  deriving (Show, Generic, Num, ToJSON)

testMain :: IO ()
testMain = do
  print theAge
  print $ encode theAge

-- Generic and Generic1 with DeriveGeneric. We’ll get to these type classes in
-- the next section.
--  Functor with DeriveFunctor.
--  Foldable and Traversable with DeriveFoldable and DeriveTraversable,
-- respectively.
--  Typeable and Data from the Data.Typeable and Data.Data modules with
-- DeriveDataTypeable. These types provide one way to look at run-time representations
-- of Haskell values and an additional approach to generic programming,
-- different from what I present in this chapter. They are also used to
-- introduce dynamic types to Haskell (see Data.Dynamic for details).
--  Lift with DeriveLift to be used with the template-haskell package. More on
-- that later in this chapter.
