main = do
  putStrLn "Enter just over half of a palindrome:"
  s <- getLine
  putStrLn (s ++ tail (reverse s))
