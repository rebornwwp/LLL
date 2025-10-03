module Ch25.ComposeDemo where

import           Control.Applicative (Applicative (liftA2))
import           Control.Monad       (join)

newtype Compose f g a =
  Compose
    { getCompose :: f (g a)
    }
  deriving (Eq, Show)

instance (Functor f, Functor g) => Functor (Compose f g) where
  fmap f (Compose fga) = Compose $ (fmap . fmap) f fga

newtype One f a =
  One (f a)
  deriving (Eq, Show)

instance Functor f => Functor (One f) where
  fmap f (One fa) = One $ fmap f fa

instance (Applicative f, Applicative g) => Applicative (Compose f g) where
  pure x = Compose (pure (pure x))
  (Compose f) <*> (Compose a) = Compose (liftA2 (<*>) f a)

-- instance (Monad f, Monad g) => Monad (Compose f g) where
--   return = pure
--   (>>=) :: Compose f g a -> (a -> Compose f g b) -> Compose f g b
--   (>>=) = undefined
instance (Foldable f, Foldable g) => Foldable (Compose f g) where
  foldMap = undefined

instance (Traversable f, Traversable g) => Traversable (Compose f g) where
  traverse = undefined

newtype Identity a =
  Identity
    { runIdentity :: a
    }
  deriving (Eq, Show)

newtype IdentityT f a =
  IdentityT
    { runIdentityT :: f a
    }
  deriving (Eq, Show)

instance Functor Identity where
  fmap f (Identity a) = Identity (f a)

instance (Functor m) => Functor (IdentityT m) where
  fmap f (IdentityT fa) = IdentityT (fmap f fa)

instance Applicative Identity where
  pure = Identity
  (Identity f) <*> (Identity a) = Identity (f a)

instance (Applicative m) => Applicative (IdentityT m) where
  pure x = IdentityT (pure x)
  (IdentityT fab) <*> (IdentityT fa) = IdentityT (fab <*> fa)

instance Monad Identity where
  return = pure
  (Identity a) >>= f = f a

instance (Monad m) => Monad (IdentityT m) where
  return = pure
  -- (IdentityT ma) >>= f = IdentityT (ma >>= (runIdentityT . f))
  -- (IdentityT ma) >>= f
  --   -- version 1
  --   -- let aimb = join (fmap runIdentityT (fmap f ma))
  --   --  in IdentityT aimb
  --   -- version2: refactor
  --   -- IdentityT $ join (fmap (runIdentityT . f) ma)
  --   -- version3:
  --   -- IdentityT ((runIdentityT . f) =<< ma)
  --   --version4
  --  = IdentityT (ma >>= runIdentityT . f)
  m >>= f = IdentityT (runIdentityT m >>= runIdentityT . f)
  -- m (T m b)
  -- -> m (m b)
  -- -> m b
  -- -> T m b
