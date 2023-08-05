module CodeWars1
  ( funcx
  ) where

import Control.Monad (void)
import Data.Char (isDigit, isLetter)
import Data.Functor (($>), (<$))
import Text.Parsec
  ( ParseError
  , (<|>)
  , anyToken
  , between
  , chainl1
  , char
  , choice
  , digit
  , eof
  , letter
  , many
  , many1
  , manyTill
  , oneOf
  , parse
  , satisfy
  , spaces
  , string
  )
import Text.Parsec.String (Parser)

funcx :: IO ()
funcx = print "hello"

data SimpleExpr
  = Num Integer
  | Var String
  | Add SimpleExpr SimpleExpr
  | Parens SimpleExpr
  deriving (Eq, Show)

myParser1 :: (a -> b -> c) -> Parser a -> Parser b -> Parser c
-- myParser1 ctor pa pb = do
--   a <- pa
--   b <- pb
--   return $ ctor a b
myParser1 ctor pa pb = ctor <$> pa <*> pb

lexemeD :: Parser a -> Parser a
lexemeD p = do
  x <- p
  spaces
  return x

lexemeA0 :: Parser a -> Parser a
lexemeA0 p = do
  x <- p <* spaces
  return x

lexemeA1 :: Parser a -> Parser a
lexemeA1 p = do
  p <* spaces

lexemeA :: Parser a -> Parser a
lexemeA p = p <* spaces

numD :: Parser SimpleExpr
numD = do
  n <- lexemeD $ many1 digit
  return $ Num $ read n

numA0 :: Parser SimpleExpr
numA0 = do
  n <- read <$> lexemeA (many1 digit)
  return $ Num n

numA1 :: Parser SimpleExpr
numA1 = do
  n <- (Num . read) <$> lexemeA (many1 digit)
  return n

numA2 :: Parser SimpleExpr
numA2 = do
  n <- Num <$> read <$> lexemeA (many1 digit)
  return n

numA2' :: Parser SimpleExpr
numA2' = do
  n <- (Num <$> read) <$> lexemeA (many1 digit)
  return n

numA2'' :: Parser SimpleExpr
numA2'' = do
  n <- numb
  return n
  where
    numb :: Parser SimpleExpr
    numb = Num <$> int
    int :: Parser Integer
    int = read <$> lexemeA (many1 digit)

numA2''' :: Parser SimpleExpr
numA2''' = do
  n <- int
  return n
  where
    int :: Parser SimpleExpr
    int = numF <$> lexemeA (many1 digit)
    numF :: String -> SimpleExpr
    numF = Num <$> read

numA3' :: Parser SimpleExpr
numA3' = (Num . read) <$> lexemeA (many1 digit)

numA3 :: Parser SimpleExpr
numA3 = Num . read <$> lexemeA (many1 digit)

integerA4 :: Parser Integer
integerA4 = read <$> lexemeA (many1 digit)

numA4 :: Parser SimpleExpr
numA4 = Num <$> integerA4

varD :: Parser SimpleExpr
varD =
  lexemeA $ do
    fc <- firstChar
    rest <- many nonFirstChar
    return $ Var (fc : rest)
  where
    firstChar = satisfy (\a -> isLetter a || a == '_')
    nonFirstChar = satisfy (\a -> isDigit a || isLetter a || a == '_')

varA0 :: Parser SimpleExpr
varA0 =
  lexemeA $ do
    fl <- firstChar
    rest <- many nonFirstChar
    return $ Var (fl : rest)
  where
    firstChar = letter <|> char '_'
    nonFirstChar = digit <|> firstChar

varA0' :: Parser SimpleExpr
varA0' =
  lexemeA $ do
    fl <- satisfy validFirstChar
    rest <- many (satisfy validNonFirstChar)
    return $ Var (fl : rest)
  where
    validFirstChar a = isLetter a || a == '_'
    validNonFirstChar a = validFirstChar a || isDigit a

varA1 :: Parser SimpleExpr
varA1 = do
  i <- iden
  return $ Var i
  where
    iden :: Parser String
    iden = lexemeA ((:) <$> firstChar <*> many nonFirstChar)
    firstChar = letter <|> char '_'
    nonFirstChar = digit <|> firstChar

varA2 :: Parser SimpleExpr
varA2 = Var <$> iden
  where
    iden :: Parser String
    iden = lexemeA ((:) <$> firstChar <*> many nonFirstChar)
    firstChar = letter <|> char '_'
    nonFirstChar = digit <|> firstChar

parensD :: Parser SimpleExpr
parensD = do
  void $ lexemeA $ char '('
  e <- simpleExprD
  void $ lexemeA $ char ')'
  return $ Parens e

parensA0 :: Parser SimpleExpr
parensA0 = Parens <$> (lexemeA (char '(') *> simpleExprD <* lexemeA (char ')'))
  where
    x :: Parser SimpleExpr
    x = lexemeA (char '(') *> simpleExprD

termD :: Parser SimpleExpr
termD = numD <|> varD <|> parensD

simpleExprD :: Parser SimpleExpr
simpleExprD = chainl1 termD op
  where
    op = do
      void $ lexemeA $ char '+'
      return Add

simpleExprA0 :: Parser SimpleExpr
simpleExprA0 = chainl1 termD op
  where
    -- op = lexemeA (char '+') *> return Add
    -- op = lexemeA (char '+') $> Add
    op = Add <$ lexemeA (char '+')

simpleExprA2 :: Parser SimpleExpr
simpleExprA2 = chainl1 termD (Add <$ lexemeA (char '+'))

lexeme :: Parser a -> Parser a
lexeme p = p <* spaces

identifier :: Parser String
identifier = lexeme ((:) <$> firstChar <*> many nonFirstChar)
  where
    firstChar = letter <|> char '_'
    nonFirstChar = digit <|> firstChar

integer :: Parser Integer
integer = read <$> lexeme (many1 digit)

symbol :: Char -> Parser ()
symbol c = void $ lexeme $ char c

betweenParens :: Parser a -> Parser a
-- betweenParens p = symbol '(' *> p <* symbol ')'
betweenParens = between (symbol '(') (symbol ')')

num :: Parser SimpleExpr
num = Num <$> integer

var :: Parser SimpleExpr
var = Var <$> identifier

parens :: Parser SimpleExpr
parens = Parens <$> betweenParens simpleExpr

term :: Parser SimpleExpr
term = num <|> var <|> parens

simpleExpr :: Parser SimpleExpr
simpleExpr = chainl1 term op
  where
    op = Add <$ lexemeA (char '+')

-- others
data Something
  = Type1
  | Type2
  | Type3
  deriving (Show, Eq)

something :: Parser Something
something =
  choice
    [Type1 <$ string "type1", Type2 <$ string "type2", Type3 <$ string "type3"]

alwaysX :: Parser Char
alwaysX = return 'x'

regularParse :: Parser a -> String -> Either ParseError a
regularParse p = parse p ""

parseWithEof :: Parser a -> String -> Either ParseError a
parseWithEof p = parse (p <* eof) ""

parseWithLeftOver :: Parser a -> String -> Either ParseError (a, String)
parseWithLeftOver p = parse ((,) <$> p <*> leftOver) ""
  where
    leftOver = manyTill anyToken eof

parseWithWSEof :: Parser a -> String -> Either ParseError a
parseWithWSEof p = parseWithEof (whiteSpace *> p)
  where
    whiteSpace = void $ many $ oneOf " \n\t"
