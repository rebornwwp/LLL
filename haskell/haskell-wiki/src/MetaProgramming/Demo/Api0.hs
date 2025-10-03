module MetaProgramming.Demo.Api0 where

get :: [String] -> IO String
get [] = pure "OK"
get [op, _] =
  case op of
    "title"  -> pure "Haskell in Depth"
    "year"   -> pure "2021"
    "rating" -> pure "Great"
    _        -> ioError (userError "Not implemented")
get _ = ioError (userError "Malformed request")

check :: IO ()
check = do
  b <- get []
  y <- get ["year", "7548"]
  putStrLn
    (if b == "OK" && y == "2021"
       then "OK"
       else "Wrong answer!")
