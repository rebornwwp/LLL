module TestA where

import           Data.Char          (isLetter)
import           Data.Data          (Data (dataTypeOf), TypeRep, Typeable,
                                     typeOf)
import           Data.List          (group, sort)
import qualified Data.Text          as T
import qualified Data.Text.IO       as TIO
import           System.Environment (getArgs)

main :: IO ()
main = do
  [fname] <- getArgs
  print fname
  text <- TIO.readFile fname
  let ws =
        map head $
        group $
        sort $
        map T.toCaseFold $
        filter (not . T.null) $
        map (T.dropAround $ not . isLetter) $ T.words text
  TIO.putStrLn $ T.unwords ws
