module Ch24.LLVML.Lexer where

import           Text.Parsec          (parse)
import           Text.Parsec.Language (emptyDef)
import           Text.Parsec.String   (Parser)
import qualified Text.Parsec.Token    as Tok

lexer :: Tok.TokenParser ()
lexer = Tok.makeTokenParser style
  where
    ops = ["+", "*", "-", ";"]
    names = ["def", "extern"]
    style =
      emptyDef
        { Tok.commentLine = "#"
        , Tok.reservedOpNames = ops
        , Tok.reservedNames = names
        }

integer :: Parser Integer
integer = Tok.integer lexer

float :: Parser Double
float = Tok.float lexer

identifier :: Parser String
identifier = Tok.identifier lexer

parens :: Parser a -> Parser a
parens = Tok.parens lexer

semiSep :: Parser a -> Parser [a]
semiSep = Tok.semiSep lexer

commaSep :: Parser a -> Parser [a]
commaSep = Tok.commaSep lexer

reserved :: String -> Parser ()
reserved = Tok.reserved lexer

reservedOp :: String -> Parser ()
reservedOp = Tok.reservedOp lexer

-- p pa inp =
--   case parse pa "" inp of
--     Left err  -> "err: " ++ show err
--     Right ans -> "ans: " ++ show ans
