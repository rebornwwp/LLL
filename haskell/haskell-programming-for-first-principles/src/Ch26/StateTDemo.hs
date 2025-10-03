module Ch26.StateTDemo where

newtype StateT s m a =
  StateT
    { runStateT :: s -> m (a, s)
    }

instance (Functor m) => Functor (StateT s m) where
  fmap f m = StateT $ \s -> fmap fas (runStateT m s)
    where
      fas (a, s) = (f a, s)

instance (Monad m) => Applicative (StateT s m) where
  pure a = StateT $ \s -> return (a, s)
  (StateT fab) <*> (StateT sma) =
    StateT $ \s -> do
      (f, s') <- fab s
      (a, s'') <- sma s'
      return (f a, s'')

instance (Monad m) => Monad (StateT s m) where
  return = pure
  sma >>= f =
    StateT $ \s -> do
      (a, s') <- runStateT sma s
      (a', s'') <- runStateT (f a) s'
      return (a', s'')
