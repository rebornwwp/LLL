main = do
  putStrLn "hello, what's your name?"
  a <- return "hello"
  name <- getLine
  line <- getLine
  print a

  putStrLn $ "Hey" ++ name ++ ", you rock!"
  if null line
      then return ()
      else do
          putStrLn $ reverseWords line
          main

reverseWords :: String -> String
reverseWords = unwords . map reverse . words

