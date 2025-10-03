module FunctorApplicativeMonad.Monads.ContDemo where

-- https://hacklewayne.com/callcc-in-haskell-and-my-ultimate-monad
-- https://en.wikibooks.org/wiki/Haskell/Continuation_passing_style
-- https://free.cofree.io/2020/01/02/cps/ 这里通过案例来介绍此方式的使用
-- https://matt.might.net/articles/by-example-continuation-passing-style/ 通过不同语言来探讨cps
-- https://www.haskellforall.com/2012/12/the-continuation-monad.html
-- | 下面是函数形式
add :: Int -> Int -> Int
add x y = x + y

square :: Int -> Int
square x = x * x

-- 直接结果
pythagoras :: Int -> Int -> Int
pythagoras x y = add (square x) (square y)

add_cps :: Int -> Int -> (Int -> r) -> r
add_cps x y = \k -> k (add x y)

square_cps :: Int -> (Int -> r) -> r
square_cps x = \k -> k (square x)

pythagoras_cps :: Int -> Int -> (Int -> r) -> r
pythagoras_cps x y =
  \k ->
    square_cps x $ \x_squared ->
      square_cps y $ \y_squared -> add_cps x_squared y_squared $ k

-- 下面是封装成 Cont 的形式
newtype Cont r a =
  Cont
    { unCont :: (a -> r) -> r
    }

runCont :: Cont r a -> (a -> r) -> r
runCont c f = unCont c $ f

helloCont =
  let c = Cont ($ 1)
   in runCont c (+ 1)

instance Functor (Cont r) where
  fmap f (Cont c) = Cont $ \c' -> c $ \k -> c' (f k)

instance Applicative (Cont r) where
  pure x = Cont $ \c -> c x
  c1 <*> c2 = Cont $ \c -> runCont c1 $ \f -> runCont c2 $ \c2' -> c (f c2')

instance Monad (Cont r) where
  return = pure
  c >>= f = Cont $ \c1 -> runCont c $ \a -> runCont (f a) $ \c2 -> c1 c2

-- 第一版本的代码
myCallCC' :: ((a -> Cont r b) -> Cont r a) -> Cont r a
myCallCC' a2mb2ma =
  Cont $ \a2r ->
    let a2mb = \a1 -> Cont $ \b2r -> a2r a1
        ma = a2mb2ma a2mb
     in runCont ma $ \a2 -> a2r a2

-- 最终版本的代码
-- 先记住，可以帮助流程进行控制，执行这个逻辑之后，后续的continuation逻辑不会再执行
myCallCC :: ((a -> Cont r b) -> Cont r a) -> Cont r a
myCallCC a2mb2ma =
  Cont $ \a2r ->
    let a2mb = \a1 -> Cont $ \_ -> a2r a1
        ma = a2mb2ma a2mb
     in runCont ma undefined

quux :: Cont r Integer
quux =
  myCallCC $ \k -> do
    _ <- k 5
    return 25

-- 使用 Equational Reasoning 展开
-- step 1: 传入参数的带入
quux' =
  Cont $ \a2r ->
    let a2mb = \a1 -> Cont $ \b2r -> a2r a1
        ma =
          (\k -> do
             k 5
             return 25)
            a2mb
     in runCont ma $ \a2 -> a2r a2

-- step2: 执行ma中的替换
quux'' =
  Cont $ \a2r ->
    let a2mb = \a1 -> Cont $ \b2r -> a2r a1
        ma = do
          a2mb 5
          return 25
     in runCont ma $ \a2 -> a2r a2

-- step 3 a2mb的带入
quux''' =
  Cont $ \a2r ->
    let ma = do
          (\a1 -> Cont $ \b2r -> a2r a1) 5
          return 25
     in runCont ma $ \a2 -> a2r a2

-- step 4 ma中将 5替换下
quux'''' =
  Cont $ \a2r ->
    let ma = do
          Cont $ \b2r -> a2r 5
          return 25
     in runCont ma $ \a2 -> a2r a2

-- step 5 替换ma
quux''''' =
  Cont $ \a2r ->
    runCont
      (do Cont $ \b2r -> a2r 5
          return 25) $ \a2 -> a2r a2

-- step 6 ???
quux'''''' =
  Cont $ \a2r ->
    runCont
      (do Cont $ \_ -> a2r 5
          undefined)
      undefined

quuxResult' = runCont quux'''''' id

quuxResult = runCont quux id

quuxPrint = do
  let x = runCont quux id
  print x
