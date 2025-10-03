{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE RecursiveDo    #-}
{-# LANGUAGE TupleSections  #-}

module SafeHaskell
  ( main1
  ) where

-- import           System.IO.Unsafe
-- import           Unsafe.Coerce
-- bad1 :: String
-- bad1 = unsafePerformIO getLine
-- bad2 :: a
-- bad2 = unsafeCoerce 3.14 ()
-- -- Unsafe.Coerce: Can't be safely imported!
-- -- The module itself isn't safe.
justOnes :: Maybe [Int]
justOnes = do
  rec xs <- Just (1 : xs)
  return (map negate xs)

first :: a -> (a, Bool)
first = (, True)

second :: a -> (Bool, a)
second = (True, )

-- f :: t -> t1 -> t2 -> t3 -> (t, (), t1, (), (), t2, t3)
-- f = (, (), , (), (), , )
data D =
  D
    { a :: Int
    , b :: Int
    }

f :: D -> Int
f D {a, b} = a - b

-- Order doesn't matter
g :: D -> Int
g D {b, a} = a - b

main1 :: IO ()
main1
--   l <- justOnes
--   print $ head l
 = do
  print $ first 10
  print $ f $ D 10 20
  print $ g $ D 10 20
