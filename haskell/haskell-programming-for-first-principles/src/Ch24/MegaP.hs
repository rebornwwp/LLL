{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards   #-}

module Ch24.MegaP where

import           Control.Applicative        hiding (many, some)
import           Control.Monad
import           Data.Text                  (Text)
import qualified Data.Text                  as T
import           Data.Text.Encoding         (decodeUtf8Lenient)
import           Data.Void
import           Text.Megaparsec            hiding (State)
import           Text.Megaparsec.Char
import qualified Text.Megaparsec.Char.Lexer as L
import           Text.Megaparsec.Debug      (MonadParsecDbg (dbg))

type Parser = Parsec Void Text

-- scheme:[//[user:password@]host[:port]][/]path[?query][#fragment]
data Uri =
  Uri
    { uriScheme    :: Scheme
    , uriAuthority :: Maybe Authority
    }
  deriving (Eq, Show)

data Authority =
  Authority
    { authUser :: Maybe (Text, Text) -- (user, password)
    , authHost :: Text
    , authPort :: Maybe Int
    }
  deriving (Eq, Show)

data Scheme
  = SchemeData
  | SchemeFile
  | SchemeFtp
  | SchemeHttp
  | SchemeHttps
  | SchemeIrc
  | SchemeMailto
  deriving (Eq, Show)

pScheme :: Parser Scheme
pScheme =
  choice
    [ SchemeData <$ string "data"
    , SchemeFile <$ string "file"
    , SchemeFtp <$ string "ftp"
    , SchemeHttps <$ string "https"
    , SchemeHttp <$ string "http"
    , SchemeIrc <$ string "irc"
    , SchemeMailto <$ string "mailto"
    ]

pUri :: Parser Uri
pUri = do
  uriScheme <- pScheme <?> "valid scheme"
  void (char ':')
  uriAuthority <-
    optional $ do
      void (string "//")
      authUser <-
        optional . try $ do
          user <- T.pack <$> some alphaNumChar <?> "username"
          void (char ':')
          password <- T.pack <$> some alphaNumChar <?> "password"
          void (char '@')
          return (user, password)
      authHost <- T.pack <$> some (alphaNumChar <|> char '.') <?> "hostname"
      authPort <- optional (char ':' *> label "port number" L.decimal)
      return Authority {..}
  return Uri {..}

sc :: Parser ()
sc = L.space space1 (L.skipLineComment "//") (L.skipBlockComment "/*" "*/")
