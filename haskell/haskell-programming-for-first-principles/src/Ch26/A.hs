module Ch26.A where

import           Control.Monad             (guard)
import           Control.Monad.Trans       (MonadTrans (lift))
import           Control.Monad.Trans.Maybe (MaybeT (MaybeT))

getValidPassphrase :: MaybeT IO String
getValidPassphrase = do
  let x = lift getLine
  s <- x
  guard (isValid s) -- MonadPlus 类型类使我们能够使用 guard.
  return s

isValid :: String -> Bool
isValid = undefined

askPassphrase :: MaybeT IO ()
askPassphrase = do
  lift $ putStrLn "输入新密码:"
  value <- getValidPassphrase
  lift $ putStrLn ("储存中..." ++ value)

getValidPassphrase' :: MaybeT IO String
getValidPassphrase' = do
  s <- lift getLine
  return s

getPassphrase'' :: IO (Maybe String)
getPassphrase'' = do
  s <- getLine
  if isValid s
    then return $ Just s
    else return Nothing
