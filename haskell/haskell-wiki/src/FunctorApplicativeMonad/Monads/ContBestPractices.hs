{-# LANGUAGE BangPatterns #-}

module FunctorApplicativeMonad.Monads.ContBestPractices where

-- https://en.wikibooks.org/wiki/Haskell/Continuation_passing_style#Example:_a_complicated_control_structure
import           Control.Monad.Cont (Cont, MonadCont (callCC), cont, runCont,
                                     when)
import           Data.Char          (digitToInt, intToDigit)

-- 使用案例， 使用Cont 进行普通版本与cps版本进行对比
fabnaccci :: Int -> Int
fabnaccci 0 = 0
fabnaccci 1 = 1
fabnaccci n = fabnaccci (n - 1) + fabnaccci (n - 2)

fabnaccciTail :: Int -> Int
fabnaccciTail n = go n 0 1
  where
    go !n' !x !y
      | n' == 0 = x
      | otherwise = go (n' - 1) y (x + y)

fabnaccciCps :: Int -> Cont r Int
fabnaccciCps 0 = return 0
fabnaccciCps 1 = return 1
fabnaccciCps n = do
  f1 <- fabnaccciCps (n - 1)
  f2 <- fabnaccciCps (n - 2)
  return (f1 + f2)

result1 = do
  let x = fabnaccci 5
  print x

result2 = do
  let x = fabnaccciTail 5
  print x

result3 = runCont (fabnaccciCps 5) print

-- Monad的组合例子
lengthCal :: [a] -> Cont r Int
lengthCal l = return (length l)

double :: Int -> Cont r Int
double n = return (n * 2)

demoResult :: IO ()
demoResult = runCont (lengthCal "hello" >>= double) print

-- Returns a string depending on the length of the name parameter.
-- If the provided string is empty, returns an error.
-- Otherwise, returns a welcome message.
whatsYourName :: String -> String
whatsYourName name =
  (`runCont` id) $
  callCC $ \exit -> do
    validateName name exit
    return $ "Welcome, " ++ name ++ "!"

validateName name exit = do
  when (null name) (exit "You forgot to tell me your name!")

--针对不同逻辑，进行不同的控制跳转
-- 这里如果返回int 使用exit2，如果返回是string，使用exit1来控制
fun :: Int -> String
fun n =
  (`runCont` id) $ do
    str <-
      callCC $ \exit1 -- define "exit1"
       -> do
        when (n < 10) (exit1 (show n))
        let ns = map digitToInt (show (n `div` 2))
        n' <-
          callCC $ \exit2 -- define "exit2"
           -> do
            when ((length ns) < 3) (exit2 (length ns))
            when ((length ns) < 5) (exit2 n)
            when ((length ns) < 7) $ do
              let ns' = map intToDigit (reverse ns)
              exit1 (dropWhile (== '0') ns') --escape 2 levels
            return $ sum ns
        return $ "(ns = " ++ (show ns) ++ ") " ++ (show n')
    return $ "Answer: " ++ str

-- 异常处理的时候
divExcpt :: Int -> Int -> (String -> Cont r Int) -> Cont r Int
divExcpt x y handler =
  callCC $ \ok -> do
    err <-
      callCC $ \notOk -> do
        when (y == 0) $ notOk "Denominator 0"
        ok $ x `div` y
    handler err
