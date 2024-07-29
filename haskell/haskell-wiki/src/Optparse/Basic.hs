{-# LANGUAGE GADTs #-}

module Optparse.Basic where

-- https://www.paolocapriotti.com/blog/2012/04/27/applicative-option-parser/
import           Debug.Trace (traceM)

data Option a =
  Option
    { optName   :: String
    , optParser :: String -> Maybe a
    }

instance Functor Option where
  fmap f (Option name p) = Option name (fmap f . p)

optMatches :: Option a -> String -> Bool
optMatches opt s = s == '-' : '-' : optName opt

data Parser a where
  NilP :: a -> Parser a
  ConsP :: Option (a -> b) -> Parser a -> Parser b

instance Functor Parser where
  fmap f (NilP x)         = NilP (f x)
  fmap f (ConsP opt rest) = ConsP (fmap (f .) opt) rest -- 但对option进行操作

instance Applicative Parser where
  pure = NilP
  NilP f <*> p         = fmap f p
  ConsP opt rest <*> p = ConsP (fmap uncurry opt) ((,) <$> rest <*> p)
  -- opt :: Option (a -> b -> c) 转变成 Option ((a,b)->c)
  -- 第二个参数也要改变成Option (a,b)类型
  -- opt :: Option (a -> b -> c)
  -- rest :: Parser a
  -- p :: Parser b
  -- fmap uncurry opt :: Option ((a, b) -> c)
  -- (,) <$> rest <*> p :: Parser (a, b)

-- TODO: NilP () 这样的用法, 需要看为啥这样做
option :: String -> (String -> Maybe a) -> Parser a
option name p = ConsP (fmap const (Option name p)) (NilP ())

xx :: String -> (String -> Maybe a) -> Option (b -> a)
xx name p = fmap const (Option name p)

optionR :: Read a => String -> Parser a
optionR name = option name p
  where
    p arg =
      case reads arg of
        [(r, "")] -> Just r
        _         -> Nothing

data User =
  User
    { userName :: String
    , userId   :: Integer
    }
  deriving (Show)

parser :: Parser User
parser = User <$> option "name" Just <*> optionR "id"

runParser :: Parser a -> [String] -> Maybe (a, [String])
runParser (NilP x) args = Just (x, args)
runParser (ConsP _ _) [] = Nothing
runParser p (arg:args) =
  case stepParser p arg args of
    Nothing -> Nothing
    Just (p', args') -> do
      runParser p' args'

stepParser :: Parser a -> String -> [String] -> Maybe (Parser a, [String])
stepParser p arg args =
  case p of
    NilP _ -> Nothing
    ConsP opt rest
      | optMatches opt arg ->
        case args of
          [] -> Nothing
          (value:args') -> do
            traceM
              ("parser: arg: " ++ arg ++ " " ++ value ++ " args: " ++ show args')
            f <- optParser opt value
            return (fmap f rest, args')
      | otherwise -> do
        traceM ("stepParser: arg: " ++ arg ++ " args: " ++ show args)
        (rest', args') <- stepParser rest arg args
        return (ConsP opt rest', args')

ex1 :: Maybe User
ex1 = fst <$> runParser parser ["--name", "fry", "--id", "1"]

{- Just (User {userName = "fry", userId = 1}) -}
ex2 :: Maybe User
ex2 = fst <$> runParser parser ["--id", "2", "--name", "bender"]

{- Just (User {userName = "bender", userId = 2}) -}
ex3 :: Maybe User
ex3 = fst <$> runParser parser ["--name", "leela"]
