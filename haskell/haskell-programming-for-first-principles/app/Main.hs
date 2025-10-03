module Main
  ( main
  ) where

import           Ch24.LLVML.Parser        (parseToplevel)
import           Control.Monad.Trans      (MonadIO (liftIO))
import           System.Console.Haskeline (defaultSettings, getInputLine,
                                           outputStrLn, runInputT)

process :: String -> IO ()
process line = do
  let res = parseToplevel line
  case res of
    Left err -> print err
    Right ex -> mapM_ print ex

main :: IO ()
main = runInputT defaultSettings loop
  where
    loop = do
      minput <- getInputLine "ready> "
      case minput of
        Nothing    -> outputStrLn "Goodbye"
        Just input -> (liftIO $ process input) >> loop
