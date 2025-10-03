module Basic.Tricks where

import           Data.Function (fix)
import           RIO           (readMaybe)


-- f1 与 f2 相同
f1 = \x -> ($ x)

f2 = \x -> \k -> k x

f = flip f1


-- pattern guards haskell 2010才有的， haskell 98只支持 boolean 的形式
-- https://gitlab.haskell.org/haskell/prime/-/wikis/PatternGuards
-- https://web.archive.org/web/20170109011924/http://research.microsoft.com/en-us/um/people/simonpj/Haskell/guards.html
parseExtension :: String -> IO ()
parseExtension str
  | 'N':'o':str' <- str = print $ "xx" ++ str' ++ " " ++ str'
  | str `elem` ignores  = print $ "ignoe" ++ str
  | Just x <- Just str  = print $ "Just" ++ x
  | otherwise           = print $ "otherwise" ++ str
  where
    ignores = ["unsafe", "trustworthy", "safe"]


-- zipWith const 的使用, 通过后面的长度确定前面
x = zipWith const ([1, 2, 3] :: [Int]) ([1, 2] :: [Int])


-- 直接递归的方式
fact :: Int -> Int
fact n
  | n <= 0    = 1
  | otherwise = n * fact (n - 1)


-- | 通过 fix 来实现递归, fix可以：用于不显式递归调用自己的递归。不显式递归的情况下实现了递归
-- rec 是递归函数自身的引用
factorial :: Int -> Int
factorial = fix go
  where
    go rec n
      | n <= 0    = 1
      | otherwise = n * rec (n - 1)


-- 另外一种写法
factorial' :: Int -> Int
factorial' =
  let f =
        fix
          (\rec n ->
             if n <= 0
               then 1
               else n * rec (n - 1))
   in f

brokenFactorial :: (Integer -> Integer) -> Integer -> Integer
brokenFactorial =
  \rec ->
    (\n ->
       if n <= 0
         then 1
         else n * rec (n - 1))

factorial'' = fix brokenFactorial
          -- = fix (\rec -> (\n -> if n <= 0 then 1 else n * rec (n-1)))
          -- = fix (\rec n -> if n <= 0 then 1 else n * rec (n-1))

playgame =
  fix $ \loop -> do
    x <- getLine
    case readMaybe x :: Maybe Int of
      Nothing -> putStrLn "Parse error, expected Int" >> loop
      Just n  -> return n
    


-- TODO: 
--    1. https://github.com/quchen/articles/blob/master/loeb-moeb.md 还不知道怎回事