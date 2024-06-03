module Ch28.BasicLibrary.Exercise where

-- difference List
newtype DList a =
  DL
    { unDL :: [a] -> [a]
    }

{-# INLINE empty #-}
empty :: DList a
empty = DL id

{-# INLINE singleton #-}
singleton :: a -> DList a
singleton = DL . (:)

{-# INLINE fromList #-}
fromList :: [a] -> DList a
fromList = DL . (++)

{-# INLINE toList #-}
toList :: DList a -> [a]
toList x = unDL x []

-- Prepend a single element to a dlist.
infixr `cons`

{-# INLINE cons #-}
cons :: a -> DList a -> DList a
cons x xs = DL ((x :) . unDL xs)

-- Append a single element to a dlist.
infixl `snoc`

{-# INLINE snoc #-}
snoc :: DList a -> a -> DList a
snoc xs x = DL $ unDL xs . (x :)

-- Append dlists.
{-# INLINE append #-}
append :: DList a -> DList a -> DList a
append xs ys = DL $ unDL xs . unDL ys
