intersperse :: a -> [[a]] -> [a]
intersperse _ [] = []
intersperse _ [xs] = xs
intersperse x (xs:xss) = xs ++ [x] ++ intersperse x xss

main :: IO ()
main = do
  print $ intersperse 1000 [[1,2,3], [2], [3,4,5], [0]]
  print $ intersperse ',' ["hello", "bar", "fjf"]
  print $ intersperse ',' []
  print $ intersperse ',' ["bar"]