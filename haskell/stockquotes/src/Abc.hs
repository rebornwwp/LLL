{-# LANGUAGE PatternSynonyms #-}

module Abc where

import           Control.Lens        (Lens', lens, (.=))
import           Control.Monad       (forM, forM_, void)
import           Control.Monad.State (MonadState (get), evalState, modify)
import           Data.Maybe          (Maybe (Nothing))
import           Prelude             hiding (init)
import           Text.Read           (look, readMaybe)

hello :: Bool -> String
hello x = "hello world"

hello2 :: Bool -> String
hello2 True  = "Hello!"
hello2 False = "hello"

while :: (Monad m) => m Bool -> m a -> m ()
while cond action = do
  c <- cond
  while (return c) $ do
    _ <- action
    while cond action

for :: (Monad m) => m a -> m Bool -> m b -> m c -> m ()
for init cond post action = do
  _ <- init
  while cond $ do
    _ <- action
    post

data Status =
  Status
    { _i      :: Int
    , _result :: Double
    }

class Default a where
  def :: a

instance Default Int
 where
  def = 0

instance Default Double
 where
  def = 0.0

instance Default Status
 where
  def = Status def def

x :: Int
x = def

i :: Lens' Status Int
i = lens _i (\s x -> s {_i = x})

result :: Lens' Status Double
result = lens _result (\s x -> s {_result = x})

sum :: [Double] -> Double
sum xs =
  flip evalState def $ do
    forM_ xs $ \x -> modify (\a -> a + x)
    get


-- sum' :: [Double] -> Int -> Double
-- sum' xs n = flip evalState def $ do
--     result .= 0
--     for (i .= 0) (liftM (< n) (access i)) (i += 1) $
--         i' <- access i
--         result += (xs !! i')
--     access result
doubleSumStr :: (Read a, Num a) => String -> Maybe a
doubleSumStr str =
  case readMaybe str of
    Just s  -> Just (2 * s)
    Nothing -> Nothing

doubleSumStr' :: (Num b, Read b) => String -> Maybe b
doubleSumStr' str = (2 *) <$> readMaybe str

doubleSumStr'' :: (Num b, Read b) => String -> Maybe b
doubleSumStr'' str = (*) <$> Just 2 <*> readMaybe str

type Name = String

type Phone = String

type Location = String

type PhoneNumbers = [(Name, Phone)]

type Locations = [(Phone, Location)]

locateByName :: PhoneNumbers -> Locations -> Name -> Maybe Location
locateByName phones locations name =
  lookup name phones >>= flip lookup locations

data F

data C

class MonadM m where
  return' :: a -> m a
  (>>=%) :: m a -> (a -> m b) -> m b
