{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ViewPatterns      #-}

module FunctorApplicativeMonad.Monads.WriterLib
  ( writerMain
  ) where

import           Control.Monad.Writer (MonadWriter (listen, pass, tell, writer),
                                       Writer, censor, listens, runWriter)
import           Data.Foldable        (traverse_)
import           Data.Text            (Text)
import qualified Data.Text            as T
import qualified Data.Text.IO         as TIO

logNumber :: Int -> Writer [String] Int
logNumber num = writer (num, ["Got number: " <> show num])

--do-sugar
{- | tell to write data to writer
-}
multWithLog :: Writer [String] Int
multWithLog = do
  a <- logNumber 3
  b <- logNumber 5
  tell ["multiplying " ++ show a ++ " and " ++ show b]
  c <- writer (10, ["hello"])
  return (a * b * c)

-- desugar 不推荐使用
multWithLog' :: Writer [String] Int
multWithLog' =
  logNumber 3 >>= \x -> logNumber 5 >>= \y -> tell ["hello"] >> return (x * y)

censorExample :: Writer [String] Int -> Writer [String] Int
censorExample = censor (const ["hello", "world"])

{- pass example start -}
deleteOn :: (Monoid w) => (w -> Bool) -> Writer w a -> Writer w a
deleteOn p m =
  pass $ do
    (a, w) <- listen m
    if p w
      then return (a, id)
      else return (a, const mempty)

-- Or pass alone
deleteOn' :: (Monoid w) => (w -> Bool) -> Writer w a -> Writer w a
deleteOn' p m =
  pass $ do
    a <- m
    return
      ( a
      , \w ->
          if p w
            then mempty
            else w)

logTwo :: Writer [String] ()
logTwo = do
  deleteOn ((> 5) . length . head) $ tell ["foo"]
  deleteOn ((> 5) . length . head) $ tell ["foobar"]

{- pass example end -}
writerMain :: IO ()
writerMain = do
  print "====================== Writer:"
  print $ runWriter (writer (10, ["hello world"]))
  print $ runWriter $ logNumber 1
  print $ runWriter multWithLog
  print $ runWriter (listen multWithLog) {- (a, w) -> ((a, w), w) -}
  print $ runWriter (listens length multWithLog) {- function apply to [String] -}
  print $ runWriter multWithLog'
  print $ runWriter logTwo
  print $ runWriter (censorExample multWithLog)

type SQL = Text

data ErrorMsg =
  WrongFormat Int Text
  deriving (Show)

genInsert :: Text -> Text -> Text
genInsert s1 s2 = "INSERT INTO items VALUES ('" <> s1 <> "','" <> s2 <> "');\n"

processLine :: (Int, Text) -> Writer [ErrorMsg] SQL
processLine (_, T.splitOn ":" -> [s1, s2]) = pure $ genInsert s1 s2
processLine (i, s)                         = tell [WrongFormat i s] >> pure ""

genSQL :: Text -> Writer [ErrorMsg] SQL
genSQL txt = T.concat <$> traverse processLine (zip [1 ..] $ T.lines txt)

testData :: Text
testData = "Pen:Bob\nGlass:Mary:10\nPencil:Alice\nBook:Bob\nBottle"

testGenSQL :: IO ()
testGenSQL = do
  let (sql, errors) = runWriter (genSQL testData)
  TIO.putStrLn "SQL:"
  TIO.putStr sql
  TIO.putStrLn "Errors:"
  traverse_ print errors
