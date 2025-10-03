import           Text.Parsec
import           Text.Parsec.Expr
import           Text.Parsec.Language (emptyDef)
import           Text.Parsec.String   (Parser)
import qualified Text.Parsec.Token    as Token


-- Define expression data type
data Expr
  = Num Double
  | Add Expr Expr
  | Subtract Expr Expr
  | Multiply Expr Expr
  | Divide Expr Expr
  | Negate Expr
  deriving (Show)


-- Define a lexer based on default settings
lexer = Token.makeTokenParser emptyDef


-- Parse an integer or decimal number
number :: Parser Expr
number = do
  n <- Token.float lexer <|> fromInteger <$> Token.integer lexer
  return $ Num n


-- Handle parentheses
parens :: Parser Expr -> Parser Expr
parens = Token.parens lexer


-- Define the table of operators with precedence
operatorTable =
  [ [Prefix (Token.symbol lexer "-" >> return Negate)]
  , [ Infix (Token.symbol lexer "*" >> return Multiply) AssocLeft
    , Infix (Token.symbol lexer "/" >> return Divide) AssocLeft
    ]
  , [ Infix (Token.symbol lexer "+" >> return Add) AssocLeft
    , Infix (Token.symbol lexer "-" >> return Subtract) AssocLeft
    ]
  ]


-- Expression parser using the operator table
expression :: Parser Expr
expression = buildExpressionParser operatorTable term


-- Parse a term (either a number or a parenthesized expression)
term :: Parser Expr
term = parens expression <|> number


-- Evaluate the expression AST
eval :: Expr -> Double
eval (Num n)        = n
eval (Add a b)      = eval a + eval b
eval (Subtract a b) = eval a - eval b
eval (Multiply a b) = eval a * eval b
eval (Divide a b)   = eval a / eval b
eval (Negate a)     = -(eval a)


-- Main function to parse and evaluate an expression
calculate :: String -> Either ParseError Double
calculate input =
  fmap eval (parse (Token.whiteSpace lexer >> expression) "" input)


-- Example usage
main :: IO ()
main = do
  let expressions =
        ["1-1", "1 - -1", "6 + -(4)", "(2 / (2 + 3.33) * 4) - -6", "1--1"]
  mapM_
    (\expr -> do
       putStrLn $ "Expression: " ++ expr
       case calculate expr of
         Left err     -> print err
         Right result -> putStrLn $ "Result: " ++ show result)
    expressions
