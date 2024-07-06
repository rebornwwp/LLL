module Basic.FunctionComposition where

-- 逻辑上，先执行f2,再执行f1
dot :: (b -> c) -> (a -> b) -> a -> c
dot f1 f2 = (.) f1 f2

dot' :: (b -> c) -> (a -> b) -> a -> c
dot' f1 f2 = f1 . f2

-- 给出一些基本变换，表明函数式类型
f1 :: String -> Maybe a
f1 = undefined

--查看下面两个的不同
ffmap :: Functor f => (a -> b) -> f a -> f b
ffmap f = fmap f

ffmap' :: Functor f => (b -> c) -> f (a -> b) -> f (a -> c)
ffmap' f = fmap (f .)

--下面两个对比就能看出差别
-- String =f1=> Maybe a =f(Functor的方式)=> Maybe b
f11 :: (a -> b) -> String -> Maybe b
f11 f = (fmap f) . (f1) {- 等同于 fmap f . f1 -}

-- String =f1=> Maybe a =f(函数再调用的方式)=> b
f12 :: (Maybe a -> b) -> String -> b
f12 f = fmap f f1

helper :: Int -> String
helper = show

helper1 :: String -> String
helper1 x = x ++ "XXXX"

dotConnect :: Int -> String
dotConnect = helper1 . helper

fx :: (a -> Int) -> a -> String
fx = (helper .)

fx' :: (a -> Int) -> a -> String
fx' = (.) helper

fid :: (a -> c) -> a -> c
fid = (id .)
