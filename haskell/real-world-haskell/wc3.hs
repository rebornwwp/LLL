main = interact charCount
  where charCount input = (show . length . concat . lines) input ++ "\n"