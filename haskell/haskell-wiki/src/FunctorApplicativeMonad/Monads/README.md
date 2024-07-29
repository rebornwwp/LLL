# [notes](https://wiki.haskell.org/All_About_Monad)

[haskellreport](https://www.haskell.org/onlinereport/haskell2010/haskellch13.html#x21-19300013)

``` haskell
-- the type of monad m, m is a type constructor
-- call m is the monad type constructor
data m a = ...

-- return takes a value and embeds it in the monad.
return :: a -> m a

-- bind is a function that combines a monad instance m a with a computation
-- that produces another monad instance m b from a's to produce a new
-- monad instance m b
(>>=) :: m a -> (a -> m b) -> m b
```

## monad

a monad is a `type constructor`, a function called `return`, and a combinator function called `bind` or `>>=`

typeclass for monad

``` haskell
class Monad m where
    (>>=)  :: m a -> (a -> m b) -> m b
    return :: a -> m a

    --
    (>>) :: m a -> m b -> m b
```

type instance for Monad

``` haskell
data Maybe a = Nothing | Just a

instance Monad Maybe where
    Nothing  >>= f = Nothing
    (Just x) >>= f = f x
    return         = Just
```

### `do` notation

the do notation allows you to write monadic computations using a pseudo-imperative style with named variables.

``` haskell
-- we can also use do-notation to build complicated sequences
mothersPaternalGrandfather :: Sheep -> Maybe Sheep
mothersPaternalGrandfather s = do m  <- mother s
                                  gf <- father m
                                  father gf
-- 语法糖替换
x <- expr1

expr1 >>= \x -> ...

mothersPaternalGrandfather :: Sheep -> Maybe Sheep
mothersPaternalGrandfather s = mother s >>= (\m -> father m >>= (\m ->gf -> father gf))

```

### the monad laws

``` haskell
(return x) >>= f ==== f x
m >>= return ==== m
(m >>= f) >>= g ==== m >>= (\x -> f x >>= g)
```

## monadPlus

``` haskell
class (Monad m) => MonadPlus m where
    mzero :: m a
    mplus :: m a -> m a -> m a

instance MonadPlus Maybe where
    mzero             = Nothing
    Nothing `mplus` x = x
    x `mplus` _       = x
```

### laws

``` haskell
mzero >>= f == mzero
m >>= (\x -> mzero) == mzero
mzero `mplus` m == m
m `mplus` mzero == m
```

## misc

### functions

``` haskell
sequence :: (Traversable t, Monad m) => t (m a) -> m (t a)
sequence_ :: (Foldable t, Monad m) => t (m a) -> m ()
mapM :: (Traversable t, Monad m) => (a -> m b) -> t a -> m (t b)
mapM_ :: (Foldable t, Monad m) => (a -> m b) -> t a -> m ()
(=<<) :: Monad m => (a -> m b) -> m a -> m b
zipWithM :: Applicative m => (a -> b -> m c) -> [a] -> [b] -> m [c]
liftM :: Monad m => (a1 -> r) -> m a1 -> m r
```

### monad instances

* Identity
* Maybe
* Error
* List
* IO
* State
* Reader
* Writer
* Cont
