# [Applicative functors notes](https://wiki.haskell.org/Applicative_functor)

basic

``` haskell
liftA2 :: Applicative f => (a -> b -> c) -> f a -> f b -> f c


-- monad style
do x <- fx
    y <- fy
    return (g x y)
-- can be written as bellow
liftM2 g fx fy
```
