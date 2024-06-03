module Ch26.MaybeTDemo where

newtype MaybeT m a =
  MaybeT
    { runMaybeT :: m (Maybe a)
    }

instance (Functor m) => Functor (MaybeT m) where
  fmap f (MaybeT a) =
    let res = (fmap . fmap) f a
     in MaybeT res

instance (Applicative m) => Applicative (MaybeT m) where
  pure x = MaybeT (pure (pure x))
  (MaybeT fab) <*> (MaybeT mma) = MaybeT $ y
    where
      x = (<*>) <$> fab
      y = x <*> mma

instance (Monad m) => Monad (MaybeT m) where
  return = pure
  MaybeT ma >>= f =
    MaybeT $ do
      v <- ma
      case v of
        Nothing -> return Nothing
        Just x  -> runMaybeT (f x)
