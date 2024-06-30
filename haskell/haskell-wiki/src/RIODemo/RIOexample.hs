{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}

module RIODemo.RIOexample where

-- https://www.fpcomplete.com/haskell/library/rio/
import           Prelude   (putStrLn)
import           RIO
import           RIO.Time  (getCurrentTime)
import           System.IO (hPutStrLn, stderr)

mainrio :: IO ()
mainrio = do
  runSimpleApp $ logInfo "Hello World!"

type Name = String

main :: IO ()
main = do
  let name = "Alice"
  runRIO name $ do
    sayHello stderr
    sayGoodbye stderr

sayHello :: Handle -> RIO Name ()
sayHello h = do
  name <- ask
  liftIO $ hPutStrLn h $ "Hello, " ++ name

sayGoodbye :: Handle -> RIO Name ()
sayGoodbye h = do
  name <- ask
  liftIO $ hPutStrLn h $ "Goodbye, " ++ name

data App =
  App
    { appName   :: !String
    , appHandle :: !Handle
    }

maintest1 :: IO ()
maintest1 = do
  let app = App {appName = "Alice", appHandle = stderr}
  runRIO app $ do
    sayHello1
    sayGoodbye1

say :: String -> RIO App ()
say msg = do
  App _name h <- ask
  liftIO $ hPutStrLn h msg

sayHello1 :: RIO App ()
sayHello1 = do
  App name _h <- ask
  say $ "Hello, " ++ name

sayGoodbye1 :: RIO App ()
sayGoodbye1 = do
  App name _h <- ask
  say $ "Goodbye, " ++ name

-- `Has` type classes
class HasHandle env where
  getHandle :: env -> Handle

instance HasHandle Handle where
  getHandle = id

instance HasHandle App where
  getHandle = appHandle

main2 :: IO ()
main2 = do
  let app = App {appName = "Alice", appHandle = stderr}
  runRIO app $ do
    sayHello2
    sayTime2
    sayGoodbye2
  -- Also works!
  runRIO stdout sayTime2

say2 :: HasHandle env => String -> RIO env ()
say2 msg = do
  env <- ask
  liftIO $ hPutStrLn (getHandle env) msg

sayTime2 :: HasHandle env => RIO env ()
sayTime2 = do
  now <- getCurrentTime
  say2 $ "The time is: " ++ show now

sayHello2 :: RIO App ()
sayHello2 = do
  App name _h <- ask
  say2 $ "Hello, " ++ name

sayGoodbye2 :: RIO App ()
sayGoodbye2 = do
  App name _h <- ask
  say2 $ "Goodbye, " ++ name

--运行中将handle切换
switchHandle :: Handle -> RIO App a -> RIO App a
switchHandle h inner = do
  app <- ask
  let app' = app {appHandle = h}
  runRIO app' inner

main3 :: IO ()
main3 = do
  let app = App {appName = "Alice", appHandle = stderr}
  runRIO app $ do
    switchHandle stdout sayHello2
    sayTime2
-- lenses is to package together a getter and setter for a field in a data structure
-- 可以使用lenes来切换handle，这个需要看链接的文档就行了
