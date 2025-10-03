{-# LANGUAGE DeriveGeneric #-}

module HelloWorld.A where

import           Debug.Trace
import           GHC.Base       (VecElem (DoubleElemRep, Int16ElemRep))
import           GHC.Generics   (Generic)
import           HelloWorld.CD1

data UserTree a
  = Node a (UserTree a) (UserTree a)
  | Leaf
  deriving (Generic, Show)

instance (Serialize a) => Serialize (UserTree a)

main = do
  let xs = put True
  print (fst . get $ xs :: Bool)
  let ys = put (Leaf :: UserTree Bool)
  print (fst . get $ ys :: UserTree Bool)
  let zs = put (Node False Leaf Leaf :: UserTree Bool)
  print (fst . get $ zs :: UserTree Bool)

beeramid :: Double -> Double -> Int
beeramid total one = round (go 1 0) - 1
  where
    go n used =
      if used + n * n * one > total
        then n
        else go (n + 1) (used + n * n * one)

isMerge :: String -> String -> String -> Bool
isMerge (s:ss) (x:xs) (y:ys)
  | s == x =
    trace (":" ++ ss ++ "\n:" ++ xs ++ "\n:" ++ (y : ys)) isMerge ss xs (y : ys)
  | s == y = isMerge ss (x : xs) ys
  | otherwise = False
isMerge (s:ss) (x:xs) []
  | s == x = isMerge ss xs []
  | otherwise = False
isMerge (s:ss) [] (y:ys)
  | s == y = trace ss isMerge ss [] ys
  | otherwise = False
isMerge [] [] [] = True
isMerge _ _ _ = False
