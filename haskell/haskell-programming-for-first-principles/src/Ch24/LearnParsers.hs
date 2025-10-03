{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Ch24.LearnParsers where

import           Control.Applicative
import           Control.Monad       (void)
import           Data.ByteString     (ByteString)
import           Data.Map            (Map)
import qualified Data.Map            as M
import           Data.Ratio          ((%))
import           Data.String         (IsString)
import           Data.Text           (Text)
import           Data.Void           (Void)
import           Test.Hspec
import           Text.Megaparsec     (ParsecT)
import           Text.RawString.QQ
import           Text.Trifecta

stop :: Parser a
stop = unexpected "stop"

one :: Parser Char
one = char '1'

-- read a single character '1', then die
one' :: Parser b
one' = one >> stop

oneTwo :: Parser Char
oneTwo = char '1' >> char '2'

oneTwo' = oneTwo >> stop

testParse :: Parser Char -> IO ()
testParse p = print $ parseString p mempty "12"

parseFraction :: Parser Rational
parseFraction = do
  numerator <- decimal
  void $ char '/'
  denominator <- decimal
  case denominator of
    0 -> fail "Denominator cannot be zero"
    _ -> return (numerator % denominator)

badFraction :: IsString s => s
badFraction = "1/0"

alsoBad = "10"

shouldWork = "1/2"

shouldAlsoWork = "2/1"

yourfunction :: Parser Integer
yourfunction = do
  x <- integer
  return $ x

type NumberOrString = Either Integer String

a = "blah"

b = "123"

c = "123blah789"

parseNos :: Parser NumberOrString
parseNos = do
  skipMany (oneOf "\n ")
  v <- (Left <$> integer) <|> (Right <$> some letter)
  skipMany (oneOf "\n ")
  return v

eitherOr :: String
eitherOr =
  [r|


  123
abc
456
def


|]

pNL :: [Char] -> IO ()
pNL s = putStrLn ('\n' : s)

mainTest :: IO ()
mainTest = do
  print $ parseString (some parseNos) mempty eitherOr

-----------------------------------------------------
-- parse INI  config file
headerEx :: ByteString
headerEx = "[blah]"

newtype Header =
  Header String
  deriving (Eq, Ord, Show)

parseBracketPair :: Parser a -> Parser a
parseBracketPair p = char '[' *> p <* char ']'

parseHeader :: Parser Header
parseHeader = parseBracketPair (Header <$> some letter)

assignmentEx :: ByteString
assignmentEx = "woot=1"

type Name = String

type Value = String

type Assignments = Map Name Value

parseAssignment :: Parser (Name, Value)
parseAssignment = do
  name <- some letter
  _ <- char '='
  val <- some (noneOf "\n")
  skipEOL
  return (name, val)

skipEOL :: Parser ()
skipEOL = skipMany (oneOf "\n")

parseAssignment' :: Parser (Name, Value)
parseAssignment' = do
  name <- some letter
  _ <- char '='
  val <- some (noneOf "\n")
  return (name, val)

commentEx :: ByteString
commentEx = "; last modifjdjfakjadfkjk"

skipComments :: Parser ()
skipComments =
  skipMany
    (do _ <- char ';' <|> char '#'
        skipMany (noneOf "\n")
        skipEOL)

sectionEx' :: ByteString
sectionEx' =
  [r|
; ignore me
[states]
Chris=Texas
|]

sectionEx'' :: ByteString
sectionEx'' =
  [r|
; comment
[section]
host=wikipedia.org
alias=claw
[whatisit]
red=intoothandclaw
|]

data Section =
  Section Header Assignments
  deriving (Eq, Show)

newtype Config =
  Config (Map Header Assignments)
  deriving (Show, Eq)

skipWhitespace :: Parser ()
skipWhitespace = skipMany (char ' ' <|> char '\n')

parseSection :: Parser Section
parseSection = do
  skipWhitespace
  skipComments
  h <- parseHeader
  skipEOL
  assignments <- some parseAssignment
  return $ Section h (M.fromList assignments)

rollup :: Section -> Map Header Assignments -> Map Header Assignments
rollup (Section h a) m = M.insert h a m

parseIni :: Parser Config
parseIni = do
  sections <- some parseSection
  let mapOfSections = foldr rollup M.empty sections
  return (Config mapOfSections)

maybeSuccess :: Result a -> Maybe a
maybeSuccess (Success x) = Just x
maybeSuccess _           = Nothing

mainTest1 :: IO ()
mainTest1 =
  hspec $ do
    describe "Assignment Parsing" $
      it "can parse a simple assignment" $ do
        let m = parseByteString parseAssignment mempty assignmentEx
            r' = maybeSuccess m
        print m
        r' `shouldBe` Just ("woot", "1")
    describe "INI parsing" $
      it "Can parse multiple sections" $ do
        let m = parseByteString parseIni mempty sectionEx''
            r' = maybeSuccess m
            sectionValues =
              M.fromList [("alias", "claw"), ("host", "wikipedia.org")]
            whatisitValues = M.fromList [("red", "intoothandclaw")]
            expected' =
              Just
                (Config
                   (M.fromList
                      [ (Header "section", sectionValues)
                      , (Header "whatisit", whatisitValues)
                      ]))
        print m
        r' `shouldBe` expected'

------------------------------------------
-- character and token parser
-- lexer :: Stream Char -> Stream Token
-- parser :: Stream Token -> AS
p' :: Parser [Integer]
p' =
  some $ do
    i <- token (some digit)
    return $ read i

-------------------------------------------
