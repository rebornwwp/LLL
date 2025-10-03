module Exercise.A
  ( calc
  ) where

import           Debug.Trace          (trace)
import           Text.Parsec
import           Text.Parsec.Expr
import           Text.Parsec.Language (haskellDef)
import           Text.Parsec.String   (Parser)
import qualified Text.Parsec.Token    as P
import           Text.Parsec.Token    (TokenParser, makeTokenParser)

lexer :: TokenParser ()
lexer = makeTokenParser haskellDef

naturalOrFloat = P.naturalOrFloat lexer

symbol = P.symbol lexer

---------------------------------------------------------------------------
data Expr
  = Number Double
  | Neg Expr
  | Add Expr Expr
  | Minus Expr Expr
  | Multi Expr Expr
  | Divide Expr Expr
  deriving (Show)

nof :: Parser Expr
nof = do
  x <- naturalOrFloat
  case x of
    Left v  -> return $ Number $ fromIntegral v
    Right v -> return $ Number v

parens1 = P.parens lexer

whitespace = P.whiteSpace lexer

run :: Parser Expr -> String -> Maybe Expr
run p input =
  case parse p "" input of
    Right x  -> return x
    Left err -> trace (show err) Nothing

runLex :: Parser Expr -> String -> Maybe Expr
runLex p =
  run
    (do
       whitespace
       x <- p
       eof
       return x)

exprX :: Parser Expr
exprX = buildExpressionParser tableX termX <?> "expression"

termX :: Parser Expr
termX = parens1 exprX <|> nof <?> "simple expression"

tableX =
  [ [Prefix (try (char '-' >> notFollowedBy space) >> return Neg)]
  , [ Infix (symbol "*" >> return Multi) AssocLeft
    , Infix (symbol "/" >> return Divide) AssocLeft
    ]
  , [ Infix (symbol "+" >> return Add) AssocLeft
    , Infix (symbol "-" >> return Minus) AssocLeft
    ]
  ]

eval :: Expr -> Double
eval (Number x)   = x
eval (Neg x)      = negate (eval x)
eval (Add x y)    = eval x + eval y
eval (Minus x y)  = eval x - eval y
eval (Multi x y)  = eval x * eval y
eval (Divide x y) = eval x / eval y

calc :: String -> Double
calc s = do
  let expr = runLex exprX s
  maybe 0 eval expr

--   maybe 0 eval expr
--- >>> calc "( -7.42/7.83-5.98* -5.01/9.08* -8.59+8.80) "
-- -20.490663944447256
--- >>> calc "1-1"
--- >>> calc "1 -1"
--- >>> calc "1- 1"
--- >>> calc "1 - 1"
--- >>> calc "1- -1"
--- >>> calc "1 - -1"
--- >>> calc "1--1"
--- >>> calc "--1"
-- 0.0
-- 0.0
-- 0.0
-- 0.0
-- 2.0
-- 2.0
-- 1.0
-- Prelude.undefined
