{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-name-shadowing #-}
{-# OPTIONS_HADDOCK not-home #-}

module ParsecParserExpr where

import           Control.Applicative  (Alternative (empty), (<$), (<$>), (<*),
                                       (<*>), (<|>))
import           Control.Monad        (void)
import           Text.Parsec          (Parsec, char, digit, eof, getState,
                                       letter, many, many1, oneOf, option,
                                       parse, putState, sepBy1, skipMany,
                                       skipMany1, space, spaces, string, try,
                                       (<?>))
import           Text.Parsec.Expr     (Assoc (AssocLeft),
                                       Operator (Infix, Postfix, Prefix),
                                       buildExpressionParser)
import           Text.Parsec.Language (emptyDef, haskellDef)
import           Text.Parsec.String   (Parser)
import qualified Text.Parsec.Token    as P
import           Text.Parsec.Token    (GenLanguageDef (reservedOpNames),
                                       TokenParser, makeTokenParser)

expr :: Parser Double
expr = buildExpressionParser table factor <?> "expression"

table =
  [ [prefixOp "-" negate]
  , [op "*" (*) AssocLeft, op "/" (/) AssocLeft]
  , [op "+" (+) AssocLeft, op "-" (-) AssocLeft]
  ]
  where
    op s f assoc =
      Infix
        (do reservedOp s
            return f
     <?> "operatorXXX")
        assoc
    prefixOp s f =
      Prefix
        (do reservedOp s
            return f <?> "prefix minus")

factor = parens1 expr <|> number <?> "simple expression"

lexer :: TokenParser ()
lexer = makeTokenParser haskellDef {reservedOpNames = ["*", "/", "+", "-"]}

whiteSpace = P.whiteSpace lexer

lexeme1 = P.lexeme lexer

symbol1 = P.symbol lexer

lexemeA0 :: Parser a -> Parser a
lexemeA0 p = do
  void $ many (oneOf "\n\t ")
  x <- p
  void $ many (oneOf "\n\t ")
  return x

number :: Parser Double
number = do
  x <- lexemeA0 (many1 digit)
  return (read x)

fpNumber :: Parser Double
fpNumber = P.float lexer


-- fpNumber :: Parser Double
-- fpNumber = read <$> parser
--   where
--     parser = (++) <$> number <*> (option "" $ (:) <$> char '.' <*> number)
natural = P.natural lexer

parens1 = P.parens lexer

semi = P.semi lexer

identifier = P.identifier lexer

reserved = P.reserved lexer

reservedOp = P.reservedOp lexer

naturalOrFloat = P.naturalOrFloat lexer

nof :: Parser Double
nof = do
  x <- naturalOrFloat
  case x of
    Left x  -> return $ fromIntegral x
    Right x -> return x

run :: Parser Double -> String -> Double
run p input =
  case parse p "" input of
    Right x -> x
    _       -> 0

runLex :: Parser Double -> String -> Double
runLex p =
  run
    (do whiteSpace
        x <- p
        eof
        return x)

runIO :: Show a => Parser a -> String -> IO ()
runIO p input =
  case parse p "" input of
    Right x  -> print x
    Left err -> print err

runLexIO :: Show a => Parser a -> String -> IO ()
runLexIO p =
  runIO
    (do whiteSpace
        x <- p
        eof
        return x)

exprX = buildExpressionParser tableX termX <?> "expression"

termX = parens1 exprX <|> natural <?> "simple expression"

tableX =
  [ [prefix "-" negate]
  , [binary "*" (*) AssocLeft, binary "/" (div) AssocLeft]
  , [binary "+" (+) AssocLeft, binary "-" (-) AssocLeft]
  ]

binary name fun assoc =
  Infix
    (do reservedOp name
        return fun)
    assoc

prefix name fun =
  Prefix
    (do reservedOp name
        return fun)

postfix name fun =
  Postfix
    (do reservedOp name
        return fun)

calc :: String -> Double
calc s = runLex expr s
