module MetaProgramming.Demo.Api1 where

import Text.Read (readMaybe)

data Rating
  = Bad
  | Good
  | Great
  deriving (Show)

data ServiceStatus
  = Ok
  | Down
  deriving (Show)

type BookID = Int

type HandlerAction a = IO a

type ReqHandler a = BookID -> HandlerAction a

data BookInfoAPIImpl =
  BookInfoAPIImpl
    { root   :: HandlerAction ServiceStatus
    , title  :: ReqHandler String
    , year   :: ReqHandler Int
    , rating :: ReqHandler Rating
    }

impl1 =
  BookInfoAPIImpl
    { root = pure Ok
    , title = const $ pure "Haskell in Depth"
    , year = const $ pure 2021
    , rating = const $ pure Great
    }

impl2 =
  BookInfoAPIImpl
    { root = pure Down
    , title = const notImplemented
    , year = const notImplemented
    , rating = const notImplemented
    }
  where
    notImplemented = ioError (userError "not implemented")

encode :: Show a => HandlerAction a -> IO String
encode m = show <$> m

type Request = [String]

route :: BookInfoAPIImpl -> Request -> Maybe (IO String)
route impl [] = pure $ encode $ root impl
route impl [op, bid'] = do
  bid <- readMaybe bid'
  case op of
    "title"  -> pure $ title impl bid
    "year"   -> pure $ encode $ year impl bid
    "rating" -> pure $ encode $ rating impl bid
    _        -> Nothing
route _ _ = Nothing

get :: BookInfoAPIImpl -> Request -> IO String
get impl xs =
  case route impl xs of
    Just m  -> m
    Nothing -> pure "Malformed request"

check :: BookInfoAPIImpl -> IO ()
check impl = do
  b <- get impl []
  answer <- get impl ["year", "7548"]
  putStrLn
    (if b == "Ok" && answer == "2021"
       then "OK"
       else "Wrong answer!")
