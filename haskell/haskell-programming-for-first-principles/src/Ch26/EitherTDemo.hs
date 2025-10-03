module Ch26.EitherTDemo where

newtype EitherT e m a =
  EitherT
    { runEitherT :: m (Either e a)
    }

instance (Functor m) => Functor (EitherT e m) where
  fmap f ema = EitherT $ (fmap . fmap) f x
    where
      x = runEitherT ema

instance (Applicative m) => Applicative (EitherT e m) where
  pure x = EitherT (pure (pure x))
  f <*> a = EitherT y
    where
      fab = runEitherT f
      mma = runEitherT a
      x = (<*>) <$> fab
      y = x <*> mma

instance (Monad m) => Monad (EitherT e m) where
  return = pure
  v >>= f =
    EitherT $ do
      x <- runEitherT v
      case x of
        Right a -> runEitherT (f a)
        Left l  -> return $ Left l

swapEither :: Either e a -> Either a e
swapEither x =
  case x of
    Left l  -> Right l
    Right r -> Left r

swapEitherT :: (Functor m) => EitherT e m a -> EitherT a m e
swapEitherT x = EitherT (fmap swapEither (runEitherT x))

eitherT :: (Monad m) => (a -> m c) -> (b -> m c) -> EitherT a m b -> m c
eitherT fa fb e = do
  x <- runEitherT e
  case x of
    Left l  -> fa l
    Right r -> fb r
