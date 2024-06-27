{-# LANGUAGE BangPatterns  #-}
{-# LANGUAGE DeriveGeneric #-}

module Basic.Lazy where

import           Control.DeepSeq
import           Data.Foldable      (foldl')
import           Debug.Trace
import           GHC.Generics       (Generic)
import           UnliftIO.Exception (pureTry)

-- https://www.fpcomplete.com/haskell/tutorial/all-about-strictness/
-- laziness: values are only computed when they’re needed
-- strict: values 在不需要的时候也会被计算, 如下c 语言 seven计算其实并不需要,
-- in strict languages, you can use closures(闭包) to make things lazy
-- #include <stdio.h>
-- int add(int x, int y) {
--   return x + y;
-- }
-- int main() {
--   int five = add(1 + 1, 1 + 2);
--   int seven = add(1 + 2, 1 + 3);
--   printf("Five: %dn", five);
--   return 0;
-- }
--
-- maintest 函数中使用 Bang! 符号来使得代码strict 化， 每个值都需要求值
-- bang! 是语法糖，是seq的语法糖, bang! 符号是更常用的语法
add :: Int -> Int -> Int
add !x !y = x + y

maintest :: IO ()
maintest = do
  let !five = add (1 + 1) (1 + 2)
      !seven = add (1 + 2) (1 + 3)
  putStrLn $ "Five: " ++ show five

add' :: Int -> Int -> Int
add' x y =
  let part1 = seq x part2
      part2 = seq y answer
      answer = x + y
   in part1

-- Or more idiomatically
add'' :: Int -> Int -> Int
add'' x y = x `seq` y `seq` x + y

-- part1 is an expression which will tell you the value of part2, after it evaluates x
-- part2 is an expression which will tell you the value of answer, after it evaluates y
-- answer is just x + y
-- 下面是maintest的 seq 版本
maintest' :: IO ()
maintest' = do
  let five = add (1 + 1) (1 + 2)
      seven = add (1 + 2) (1 + 3)
  five `seq` seven `seq` putStrLn ("Five: " ++ show five)

-- trace
maintrace :: IO ()
maintrace = do
  let five = trace "five" (add (1 + 1) (1 + 2))
      seven = trace "seven" (add (1 + 2) (1 + 3))
  putStrLn $ "Five: " ++ show five

maintrace' :: IO ()
maintrace' = do
  let !five = trace "five" (add (1 + 1) (1 + 2))
      !seven = trace "seven" (add (1 + 2) (1 + 3))
  putStrLn $ "Five: " ++ show five

-- bottom: undefined
mainbottom :: IO ()
mainbottom = do
  let five = add (1 + 1) (1 + 2)
      seven = add (1 + 2) undefined -- (1 + 3)
  putStrLn $ "Five: " ++ show five

mainbottom' :: IO ()
mainbottom' = do
  let five = add (1 + 1) (1 + 2)
      !seven = add (1 + 2) undefined -- (1 + 3)
  putStrLn $ "Five: " ++ show five

data RunningTotal =
  RunningTotal
    { sum   :: Int
    , count :: Int
    }

printAverage :: RunningTotal -> IO ()
printAverage (RunningTotal sum count)
  | count == 0 = error "Need at least one value!"
  | otherwise = print (fromIntegral sum / fromIntegral count :: Double)

-- | A fold would be nicer... we'll see that later
printListAverage :: [Int] -> IO ()
printListAverage = go (RunningTotal 0 0)
  where
    go rt [] = printAverage rt
    go (RunningTotal sum count) (x:xs) =
      let rt = RunningTotal (sum + x) (count + 1)
       in go rt xs

-- | A fold would be nicer... we'll see that later
printListAverage' :: [Int] -> IO ()
printListAverage' = go (RunningTotal 0 0)
  where
    go rt [] = printAverage rt
    go (RunningTotal !sum !count) (x:xs) =
      let rt = RunningTotal (sum + x) (count + 1)
       in go rt xs
    -- alternative solution
    go' rt [] = printAverage rt
    go' (RunningTotal sum count) (x:xs) =
      let !sum' = sum + x
          !count' = count + 1
          rt = RunningTotal sum' count'
       in go' rt xs

-- stack ghci --ghci-options '+RTS -s'
-- ctrl+c will see
-- Leaving GHCi.
--    1,892,547,048 bytes allocated in the heap
--      937,516,544 bytes copied during GC
--      196,750,808 bytes maximum residency (11 sample(s))
--        5,431,848 bytes maximum slop
--              413 MiB total memory in use (0 MB lost due to fragmentation)
mainlazy :: IO ()
mainlazy = printListAverage [1 .. 1000000]

-- 下面的版本会使用更少的memory
-- Leaving GHCi.
--    1,823,061,816 bytes allocated in the heap
--      401,972,624 bytes copied during GC
--      100,342,208 bytes maximum residency (8 sample(s))
--        3,618,368 bytes maximum slop
--              210 MiB total memory in use (0 MB lost due to fragmentation)
mainstrict :: IO ()
mainstrict = printListAverage' [1 .. 1000000]

-- Leaving GHCi.
--    2,073,300,312 bytes allocated in the heap
--      411,760,184 bytes copied during GC
--      102,572,536 bytes maximum residency (8 sample(s))
--        3,599,880 bytes maximum slop
--              215 MiB total memory in use (0 MB lost due to fragmentation)
--
--  providing an NFData type class the defines how to reduce a value to normal form
instance NFData RunningTotal where
  rnf (RunningTotal sum count) = sum `deepseq` count `deepseq` ()

printAverage''' :: RunningTotal -> IO ()
printAverage''' (RunningTotal sum count)
  | count == 0 = error "Need at least one value!"
  | otherwise = print (fromIntegral sum / fromIntegral count :: Double)

-- | A fold would be nicer... we'll see that later
printListAverage''' :: [Int] -> IO ()
printListAverage''' = go (RunningTotal 0 0)
  where
    go rt [] = printAverage rt
    go (RunningTotal sum count) (x:xs) =
      let rt = RunningTotal (sum + x) (count + 1)
       in rt `deepseq` go rt xs

maindeepseq :: IO ()
maindeepseq = printListAverage''' [1 .. 1000000]

-- 最简单的方式
-- We can use this not only to avoid space leaks (as we’re doing here),
-- but also to avoid accidentally including exceptions inside thunks within a value
data RunningTotal' =
  RunningTotal'
    { sum'   :: Int
    , count' :: Int
    }
  deriving (Generic)

instance NFData RunningTotal'

-- use strictness annotations
data RunningTotal'' =
  RunningTotal''
    { sum''   :: !Int
    , count'' :: !Int
    }
  deriving (Generic)

printAverage'''' :: RunningTotal -> IO ()
printAverage'''' (RunningTotal sum'' count)
  | count == 0 = error "Need at least one value!"
  | otherwise = print (fromIntegral sum'' / fromIntegral count :: Double)

-- | A fold would be nicer... we'll see that later
printListAverage'''' :: [Int] -> IO ()
printListAverage'''' = go (RunningTotal 0 0)
  where
    go rt [] = printAverage rt
    go (RunningTotal sum count) (x:xs) =
      let rt = RunningTotal (sum + x) (count + 1)
       in go rt xs

mainstrictnessannotation :: IO ()
mainstrictnessannotation = printListAverage'''' [1 .. 1000000]

-- 使用lazy的建议
-- unless you know that you want laziness for a field, make it strict.
-- Making your fields strict helps in a few ways:
-- Avoids accidental space leaks, like we’re doing here
-- Avoids accidentally including bottom values
-- When constructing a value with record syntax, GHC will give you an error if you forget a strict field. It will only give you a warning for non-strict fields.
--
-- 提供了 $! (seq)操作来 force evalution
mysum :: [Int] -> Int
mysum list0 = go list0 0
  where
    go [] total     = total
    go (x:xs) total = go xs $! total + x -- 强迫total+x求值，来防止space leak

mainmysum :: IO ()
mainmysum = print $ mysum [1 .. 1000000]

-- 提供了 $!! (deepseq) 来实现force evaluation，其目的是将值`(total + x, count + 1)`从WHNF(weak head normal form)求值到normal form
average :: [Int] -> Double
average list0 = go list0 (0, 0)
  where
    go [] (total, count)     = fromIntegral total / count
    go (x:xs) (total, count) = go xs $!! (total + x, count + 1)

mainaverage :: IO ()
mainaverage = print $ average [1 .. 1000000]

average' :: [Int] -> Double
average' list0 = go list0 (0, 0)
  where
    go [] (total, count)     = fromIntegral total / count
    go (x:xs) (total, count) = go xs $! force (total + x, count + 1) --此方式与`$!!`一样

-- 性能对比
data Foo =
  Foo Int
  deriving (Show)

data Bar =
  Bar !Int
  deriving (Show)

newtype Baz =
  Baz Int
  deriving (Show)

mainFUCK :: IO ()
mainFUCK = do
  print $ foldl' (\(Foo total) x -> Foo (total + x)) (Foo 0) [1 .. 1000000]
  print $ foldl' (\(Bar total) x -> Bar (total + x)) (Bar 0) [1 .. 1000000]
  print $ foldl' (\(Baz total) x -> Baz (total + x)) (Baz 0) [1 .. 1000000]

mainff :: IO ()
mainff = do
  print $
    pureTry $
    case Foo undefined of
      Foo _ -> "Hello World"
  print $
    pureTry $
    case Bar undefined of
      Bar _ -> "Hello World"
  print $
    pureTry $
    case Baz undefined of
      Baz _ -> "Hello World"
