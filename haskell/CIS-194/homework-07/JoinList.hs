module JoinList where

import           Data.Monoid

import           Sized

data JoinList m a = Empty
                   | Single m a
                   | Append m (JoinList m a) (JoinList m a)
                  deriving (Eq, Show)

-- exercise 1
(+++) :: Monoid m => JoinList m a -> JoinList m a -> JoinList m a
(+++) a b = Append (tag a <> tag b) a b

tag :: Monoid m => JoinList m a -> m
tag Empty          = mempty
tag (Single m _)   = m
tag (Append m _ _) = m

-- exercise 2
indexJ :: (Sized b, Monoid b) => Int -> JoinList b a -> Maybe a
indexJ _ Empty = Nothing
indexJ i (Single _ a) = if i == 0 then Just a else Nothing
indexJ i (Append m jl0 jl1)
  | i < 0 || i > rootSize = Nothing
  | i < leftSize          = indexJ (leftSize - i) jl0
  | otherwise             = indexJ (i - leftSize) jl1
  where
    leftSize = getSize . size . tag $ jl0
    rootSize = getSize . size $ m

(!!?) :: [a] -> Int -> Maybe a
[] !!? _        = Nothing
_ !!? i | i < 0 = Nothing
(x:xs) !!? 0    = Just x
(x:xs) !!? i    = xs !!? (i - 1)

jlToList :: JoinList m a -> [a]
jlToList Empty            = []
jlToList (Single _ a)     = [a]
jlToList (Append _ l1 l2) = jlToList l1 ++ jlToList l2

dropJ :: (Sized b, Monoid b) => Int -> JoinList b a -> JoinList b a
dropJ n (Single m a) = if n <= 0 then Single m a else Empty
dropJ n (Append m jl0 jl1)
  | n <= 0        = Append m jl0 jl1
  | n >= rootSize = Empty
  | n < leftSize  = dropJ n jl0 +++ jl1
  | otherwise     = dropJ (n - leftSize) jl1
  where
    rootSize = getSize . size $ m
    leftSize = getSize . size . tag $ jl0

takeJ :: (Sized b, Monoid b) => Int -> JoinList b a -> JoinList b a
takeJ n (Single m a) = if n > 0 then Single m a else Empty
takeJ n (Append m jl0 jl1)
  | n <= 0       = Empty
  | n > rootSize = Append m jl0 jl1
  | n < leftSize = takeJ n jl0
  | otherwise    = jl0 +++ takeJ (n - leftSize) jl1
  where
    rootSize = getSize . size $ m
    leftSize = getSize . size . tag $ jl0

-- exercise 3

-- exercise 4

jl =
 Append (Size 4)
   (Append (Size 3)
     (Single (Size 1) 'y')
     (Append (Size 2)
       (Single (Size 1) 'e')
       (Single (Size 1) 'a')))
   (Single (Size 1) 'h')

main = do
  print $ jlToList jl
  print $ (indexJ 3 jl) == (jlToList jl !!? 3)
  print $ jlToList (dropJ 2 jl) == drop 2 (jlToList jl)
  print $ jlToList (takeJ 2 jl) == take 2 (jlToList jl)
  print $ jlToList (takeJ (-1) jl) == take (-1) (jlToList jl)
  print $ jlToList (takeJ (6) jl) == take (6) (jlToList jl)
  print $ jlToList (takeJ (0) jl) == take (0) (jlToList jl)
