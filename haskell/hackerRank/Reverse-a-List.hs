rev :: (Ord a) => [a] -> [a]
rev l = reverse l

rev' :: (Ord a) => [a] -> [a]
rev' []     = []
rev' (x:xs) = rev' (xs) ++ [x]
