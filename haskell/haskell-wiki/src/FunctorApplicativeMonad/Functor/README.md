# [note](https://wiki.haskell.org/Functor)

The `Functor` typeclass represents the mathematical functor: a mapping between categories in the context of category theory. In practice a `functor` represents a type that can be mapped over.

``` haskell
class Functor f where
    fmap :: (a -> b) -> f a -> f b
    (<$) :: a -> f b -> f a

    ($>) :: f a -> b -> f b
    (<$>) :: (a -> b) -> f a -> f b
```

## Functor Laws

``` haskell
-- Functors must preserve identity morphisms
fmap id = id

-- Functors preserve composition of morphisms
fmap (f . g)  ==  fmap f . fmap g
```
