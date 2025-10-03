{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE OverloadedStrings #-}

module Ch24.Hisp.Parser where

import           Ch24.Hisp.LispVal     (LispVal (Atom, Bool, List, Nil, Number, String))
import           Control.Applicative   hiding (many)
import           Data.Functor.Identity (Identity)
import qualified Data.Text             as T
import           Text.Parsec           (ParseError, char, digit, eof, letter,
                                        many, many1, noneOf, oneOf, parse,
                                        sepBy, try)
import qualified Text.Parsec.Language  as Lang
import           Text.Parsec.Text      (Parser)
import qualified Text.Parsec.Token     as Tok

lexer :: Tok.GenTokenParser T.Text () Identity
lexer = Tok.makeTokenParser style

style :: Tok.GenLanguageDef T.Text () Identity
style =
  Lang.emptyDef
    { Tok.commentStart = "{-"
    , Tok.commentEnd = "-}"
    , Tok.commentLine = "--"
    , Tok.opStart = Tok.opLetter style
    , Tok.opLetter = oneOf ":!#$%%&*+./<=>?@\\^|-~"
    , Tok.identStart = letter <|> oneOf "-+/*=|&><"
    , Tok.identLetter = digit <|> letter <|> oneOf "?+=|&-/"
    , Tok.reservedOpNames = ["'", "\""]
    }

Tok.TokenParser {Tok.parens = m_parens, Tok.identifier = m_identifier} =
  Tok.makeTokenParser style

reservedOp :: T.Text -> Parser ()
reservedOp op = Tok.reservedOp lexer $ T.unpack op

parseExpr :: Parser LispVal
parseExpr =
  parseReserved <|> parseNumber <|> try parseNegNum <|> parseAtom <|> parseText <|>
  parseQuote <|>
  parseSExpr

parseAtom :: Parser LispVal
parseAtom = do
  p <- m_identifier
  return $ Atom . T.pack $ p

parseText :: Parser LispVal
parseText = do
  reservedOp "\""
  p <- many1 $ noneOf "\""
  reservedOp "\""
  return $ String . T.pack $ p

parseNumber :: Parser LispVal
parseNumber = do
  ds <- many1 digit
  return $ Number . read $ ds

parseNegNum :: Parser LispVal
parseNegNum = do
  _ <- char '-'
  ds <- many1 digit
  return $ Number . negate . read $ ds

parseList :: Parser LispVal
parseList = do
  ls <- many parseExpr `sepBy` (char ' ' <|> char '\n')
  return $ List . concat $ ls

parseSExpr :: Parser LispVal
parseSExpr = do
  x <- m_parens (many parseExpr `sepBy` (char ' ' <|> char '\n'))
  return $ List . concat $ x

parseQuote :: Parser LispVal
parseQuote = do
  reservedOp "\'"
  x <- parseExpr
  return $ List [Atom "quote", x]

parseReserved :: Parser LispVal
parseReserved = do
  (reservedOp "Nil" >> return Nil) <|> (reservedOp "#t" >> return (Bool True)) <|>
    (reservedOp "#f" >> return (Bool False))

------- put it all
contents :: Parser a -> Parser a
contents p = do
  Tok.whiteSpace lexer
  r <- p
  eof
  return r

readExpr :: T.Text -> Either ParseError LispVal
readExpr = parse (contents parseExpr) "<stdin>"

readExprFile :: T.Text -> Either ParseError LispVal
readExprFile = parse (contents parseList) "<file>"

p pa inp =
  case parse pa "" inp of
    Left err  -> "err: " ++ show err
    Right ans -> "ans: " ++ show ans
