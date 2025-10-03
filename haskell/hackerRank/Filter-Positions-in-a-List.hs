f :: [Int] -> [Int]
f lst = [lst !! i | i <- [1 .. length lst], (mod i 2) == 1]

-- This part deals with the Input and Output and can be used as it is. Do not modify it.
main = do
  inputdata <- getContents
  mapM_ (putStrLn . show) . f . map read . lines $ inputdata
