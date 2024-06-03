# functor laws

``` haskell
fmap (f . g) = fmap f . fmap g

fmap (f . g) x = fmap f (fmap g x)

Prelude> :t (fmap)
(fmap) :: Functor f => (a -> b) -> f a -> f b
Prelude> :t (fmap . fmap)
(fmap . fmap)
  :: (Functor f1, Functor f2) => (a -> b) -> f1 (f2 a) -> f1 (f2 b)

f1 (f2 a) ==> m (MaybeT a)
f1 (f2 b) ==> m (MaybeT b)

Prelude> :t ((<*>) <$>)
((<*>) <$>)
  :: (Applicative f1, Functor f2) =>
     f2 (f1 (a -> b)) -> f2 (f1 a -> f1 b)

f2 (f1 (a -> b)) -> f2 (f1 a -> f1 b) ==> m (Maybe (a -> b)) -> m (Maybe a -> Maybe b)

m a -> a  获取 a 可以在do suguar重使用 (<-), 


fmap :: Functor f => (a -> b) -> f a -> f b
liftA :: Applicative f => (a -> b) -> f a -> f b
liftM :: Monad m => (a -> r) -> m a -> m r
```
