{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes       #-}

module Ch24.Exercise where

import           Control.Applicative
import           Control.Monad       (replicateM)
import           Data.Word
import           Text.Trifecta

data NumberOrString
  = NOSS String
  | NOSI Integer
  deriving (Eq, Show)

type Major = Integer

type Minor = Integer

type Patch = Integer

type Release = [NumberOrString]

type Metadata = [NumberOrString]

data SemVer =
  SemVer Major Minor Patch Release Metadata
  deriving (Show)

instance Eq SemVer where
  (SemVer ma mi pa re _) == (SemVer ma' mi' pa' re' _) =
    (ma, mi, pa, re) == (ma', mi', pa', re')

-- TODO: todo this
instance Ord SemVer where
  (SemVer ma mi pa re _) `compare` (SemVer ma' mi' pa' re' _) = undefined

parseInteger :: Parser Integer
parseInteger = read <$> some digit

parseNOS :: Parser NumberOrString
parseNOS = (NOSI <$> base10Integer) <|> (NOSS <$> some letter)

parsePositiveDigit :: Parser Char
parsePositiveDigit = oneOf "123456789"

parseZero :: Parser Char
parseZero = char '0'

parseDigit :: Parser Char
parseDigit = parseZero <|> parsePositiveDigit

parseDigits :: Parser String
parseDigits = many parseDigit

base10Integer :: Parser Integer
base10Integer = do
  x <- parseDigit
  xs <- parseDigits
  let res =
        if x == '0'
          then [x]
          else x : xs
  return $ read res

majorP :: Parser Integer
majorP = base10Integer

minorP :: Parser Integer
minorP = base10Integer

patchP :: Parser Integer
patchP = base10Integer

parseRelease :: Parser [NumberOrString]
parseRelease = try (char '-' *> parseNOS `sepBy` char '.') <|> pure []

parseMetadata :: Parser [NumberOrString]
parseMetadata = try (char '+' *> parseNOS `sepBy` char '.') <|> pure []

parseSemVer :: Parser SemVer
parseSemVer = do
  ma <- majorP
  _ <- char '.'
  mi <- minorP
  _ <- char '.'
  pa <- patchP
  rs <- parseRelease
  ms <- parseMetadata
  return $ SemVer ma mi pa rs ms

-----------------------------------------------------------
type NumberingPlanArea = Int -- aka area code

type Exchange = Int

type LineNumber = Int

data PhoneNumber =
  PhoneNumber NumberingPlanArea Exchange LineNumber
  deriving (Eq, Show)

digits :: Int -> Parser Int
digits n = read <$> replicateM n digit

parsePhone :: Parser PhoneNumber
parsePhone =
  PhoneNumber <$> parseNPA <* skipOptional separator <*> digits 3 <*
  skipOptional separator <*>
  digits 4
  where
    parseNPA =
      try (between (char '(') (char ')') (digits 3)) <|>
      try (string "1-" *> digits 3) <|>
      digits 3
    separator = oneOf " -"

--------------------------------------------------------------------
data IPAddress =
  IPAddress Word32
  deriving (Eq, Ord, Show)

stringToIPv4 :: String -> Word32
stringToIPv4 s =
  case result of
    Success (IPAddress x) -> x
    _                     -> 0
  where
    result = parseString parseIPv4 mempty s

parseIPv4 :: Parser IPAddress
parseIPv4 = do
  let skip = skipMany (char '.')
  (x1, x2, x3, x4) <-
    (,,,) <$> parseNumber <* skip <*> parseNumber <* skip <*> parseNumber <*
    skip <*>
    parseNumber
  return $ IPAddress $ x1 * 256 * 256 * 256 + x2 * 256 * 256 + x3 * 256 + x4

parseNumber :: Parser Word32
parseNumber = read <$> some digit

data IPAddress6 =
  IPAddress6 Word64 Word64
  deriving (Eq, Ord, Show)
