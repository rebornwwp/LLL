module Ch26.Exercise where

import           Control.Monad.Identity    (Identity)
import           Control.Monad.Reader
import           Control.Monad.State       (StateT (StateT, runStateT))
import           Control.Monad.Trans.Maybe (MaybeT (runMaybeT))

-- import           Control.Monad.Trans.Reader
rDec :: Num a => Reader a a
rDec = reader $ (-) 1

x :: [Integer]
x = fmap (runReader rDec) [1 .. 10]

rShow :: Show a => ReaderT a Identity String
-- rShow = reader show
rShow = ReaderT $ return . show

y = runReader rShow 1

y' = fmap (runReader rShow) [1 .. 10]

rPrintAndInc :: (Num a, Show a) => ReaderT a IO a
rPrintAndInc =
  ReaderT
    (\s -> do
       putStrLn $ "Hi: " ++ show s
       return $ s + 1)

z = runReaderT rPrintAndInc 1

z' = traverse (runReaderT rPrintAndInc) [1 .. 10]

sPrintIncAccum :: (Num a, Show a) => StateT a IO String
sPrintIncAccum =
  StateT
    (\s -> do
       putStrLn $ "Hi" ++ show s
       return (show s, s + 1))

z1 = runStateT sPrintIncAccum 10

z1' = mapM (runStateT sPrintIncAccum) [1 .. 5]

-- fix code
isValid :: String -> Bool
isValid v = '!' `elem` v

maybeExcite :: MaybeT IO String
maybeExcite = do
  v <- lift getLine
  guard $ isValid v
  return v

doExcite :: IO ()
doExcite = do
  putStrLn "say something excite!"
  excite <- runMaybeT maybeExcite
  case excite of
    Nothing -> putStrLn "MOAR EXCITE"
    Just e  -> putStrLn ("Good, was very excite: " ++ e)
