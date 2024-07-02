module Basic.Hello where

moveZeros :: [Int] -> [Int]
moveZeros is = go is [] []
  where
    go (x:xs) notZeros zeros =
      if x /= 0
        then go xs (notZeros ++ [x]) zeros
        else go xs notZeros (x : zeros)
    go [] notZeros zeros = notZeros ++ zeros
