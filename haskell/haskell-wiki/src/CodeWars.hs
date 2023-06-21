module CodeWars
  ( main
  ) where

import           Control.Monad      (void)
import           Data.Char          (isDigit, isLetter)
import           Text.Parsec        (ParseError, anyChar, anyToken, char,
                                     choice, digit, eof, many, many1, manyTill,
                                     parse, satisfy, spaces, string, try, upper,
                                     (<|>))
import           Text.Parsec.String (Parser)

data Expr
  = Add Expr Expr
  | Sub Expr Expr
  | Mul Expr Expr
  | Div Expr Expr
  | Term Integer

calc :: String -> Double
calc = undefined

regularParse :: Parser a -> String -> Either ParseError a
regularParse p = parse p ""

parseWithEof :: Parser a -> String -> Either ParseError a
parseWithEof p = parse (p <* eof) ""

parseWithLeftOver :: Parser a -> String -> Either ParseError (a, String)
parseWithLeftOver p = parse ((,) <$> p <*> leftOver) ""
  where
    leftOver = manyTill anyToken eof

x :: Either ParseError [Char]
x = regularParse (many1 digit) "1"

y :: Either ParseError [Char]
y = regularParse (many1 digit) "122"

main :: IO ()
main = do
  case xs of
    Left x  -> print $ "left" ++ show x
    Right x -> print $ "right" ++ show x

xs :: Either ParseError Char
xs = regularParse anyChar "0he"

num :: Parser Integer
num = do
  n <- many1 digit
  return $ read n

num1 :: Parser Integer
num1 = do
  n <- many digit
  return $ read n

var :: Parser String
var = do
  fc <- firstChar
  rest <- many nonFirstChar
  return (fc : rest)
  where
    firstChar = satisfy (\a -> isLetter a || a == '_')
    nonFirstChar = satisfy (\a -> isDigit a || isLetter a || a == '_')

data Parentheses =
  Parentheses Integer
  deriving (Eq, Show)

parens :: Parser Parentheses
parens
  -- spaces
  -- void $ char '('
 = do
  void $ lexeme $ char '('
  spaces
  e <- many1 digit
  spaces
  void $ char ')'
  spaces
  return $ Parentheses $ read e

data SingleAdd =
  SingleAdd Integer Integer
  deriving (Eq, Show)

add :: Parser SingleAdd
add = do
  spaces
  e1 <- many1 digit
  spaces
  void $ char '+'
  spaces
  e2 <- many1 digit
  spaces
  return $ SingleAdd (read e1) (read e2)

parseWithWhitespces :: Parser a -> String -> Either ParseError a
parseWithWhitespces p = parseWithEof wrapper
  where
    wrapper = do
      spaces
      p

lexeme :: Parser a -> Parser a
lexeme p = do
  x <- p
  spaces
  return x

data SimpleExpr
  = Num Integer
  | Var String
  | Adda SimpleExpr SimpleExpr
  | Parens SimpleExpr
  deriving (Eq, Show)

numE :: Parser SimpleExpr
numE = do
  n <- lexeme $ many1 digit
  return $ Num $ read n

varE :: Parser SimpleExpr
varE =
  lexeme $ do
    fc <- firstChar
    rest <- many nonFirstChar
    return $ Var (fc : rest)
  where
    firstChar = satisfy (\a -> isLetter a || a == '_')
    nonFirstChar = satisfy (\a -> isDigit a || isLetter a || a == '_')

parensE :: Parser SimpleExpr -> Parser SimpleExpr
parensE simpleExprImpl = do
  void $ lexeme $ char '('
  e <- simpleExprImpl
  void $ lexeme $ char ')'
  return $ Parens e

term5 :: Parser SimpleExpr
term5 = term simpleExpr

term :: Parser SimpleExpr -> Parser SimpleExpr
term simpleExprImpl = numE <|> varE <|> parensE simpleExprImpl

-- a+b+c -> a+(b+c)
addE :: Parser SimpleExpr
addE
  -- e0 <- numE
 = do
  e0 <- term5
  void $ lexeme $ char '+'
  -- e1 <- numE
  Adda e0 <$> simpleExpr

-- a+b+c -> (a+b)+c
simpleExpr :: Parser SimpleExpr
simpleExpr = do
  e <- term5
  maybeAddSuffix e
  where
    addSuffix e0 = do
      void $ lexeme $ char '+'
      e1 <- term5
      maybeAddSuffix (Adda e0 e1)
    maybeAddSuffix e = addSuffix e <|> return e

numOrVar :: Parser SimpleExpr
numOrVar = numE <|> varE

numOrVar' :: Parser SimpleExpr
numOrVar' = choice [numE, varE]
-- simpleExpr :: Parser SimpleExpr
-- simpleExpr = try addE <|> term5
