module SQLParser
  ( ValueExpr(..)
  , valueExpr0
  ) where

import           Control.Monad      (guard)
import           Debug.Trace        (trace)
import           Text.Parsec        (between, char, digit, letter, many, many1,
                                     oneOf, spaces, try, (<|>))
import qualified Text.Parsec.Expr   as E
import           Text.Parsec.String (Parser)

data ValueExpr
  = StringLit String
  | NumLit Integer
  | Iden String
  | DIden String String -- a.b
  | Star
  | DStar String -- a.*
  | App String [ValueExpr]
  | PrefOp String ValueExpr
  | BinOp ValueExpr String ValueExpr
  | Case
      (Maybe ValueExpr) -- test
      [(ValueExpr, ValueExpr)] -- when branchs
      (Maybe ValueExpr) -- else value
  | Parens ValueExpr
  deriving (Eq, Show)

lexeme :: Parser a -> Parser a
lexeme p = p <* spaces

integer :: Parser Integer
integer = read <$> lexeme (many1 digit)

identifier :: Parser String
identifier = lexeme ((:) <$> firstChar <*> many nonFirstChar)
  where
    firstChar    = letter <|> char '_'
    nonFirstChar = digit <|> firstChar

symbol :: String -> Parser String
symbol s =
  try $
  lexeme $ do
    u <- many1 (oneOf "<>=+-^%/*!|")
    guard (s == u)
    return s

openParen :: Parser Char
openParen = lexeme $ char '('

closeParen :: Parser Char
closeParen = lexeme $ char ')'

keyword :: String -> Parser String
keyword k =
  try $ do
    i <- identifier
    guard (i == k)
    return k

parens :: Parser a -> Parser a
parens = between openParen closeParen

num :: Parser ValueExpr
num = NumLit <$> integer

iden :: Parser ValueExpr
iden = Iden <$> identifier

parensValue :: Parser ValueExpr -> Parser ValueExpr
parensValue val = Parens <$> parens val

term0 :: Parser ValueExpr
term0 = iden <|> num <|> parensValue valueExpr0

table =
  [ [prefix "-", prefix "+"]
  , [binary "^" E.AssocLeft]
  , [binary "*" E.AssocLeft, binary "/" E.AssocLeft, binary "%" E.AssocLeft]
  , [binary "+" E.AssocLeft, binary "-" E.AssocLeft]
  , [ binary "<=" E.AssocRight
    , binary ">=" E.AssocRight
    , binaryK "like" E.AssocNone
    , binary "!=" E.AssocRight
    , binary "<>" E.AssocRight
    , binary "||" E.AssocRight
    ]
  , [binary "<" E.AssocNone, binary ">" E.AssocNone]
  , [binary "=" E.AssocRight]
  , [prefixK "not"]
  , [binaryK "and" E.AssocLeft]
  , [binaryK "or" E.AssocLeft]
  ]
  where
    binary name assoc  = E.Infix (mkBinOp name <$ symbol name) assoc
    mkBinOp nm a b     = BinOp a nm b
    prefix name        = E.Prefix (PrefOp name <$ symbol name)
    binaryK name assoc = E.Infix (mkBinOp name <$ keyword name) assoc
    prefixK name       = E.Prefix (PrefOp name <$ keyword name)

valueExpr0 :: Parser ValueExpr
valueExpr0 = E.buildExpressionParser table term0
