str2message :: String -> String
str2message input = "Data: " ++ input

str2messages :: String -> IO String
str2messages input = return $ "Data: " ++ input

str2action :: String -> IO ()
str2action = putStrLn . str2message

numbers :: [Int]
numbers = [1 .. 10]

main = do
  str2action "start of the program"
  mapM_ (str2action . show) numbers
  str2action "Done"
  getLine >>= str2action
  str2messages "hello" >>= str2action

