import Data.List (isPrefixOf, isInfixOf, isSuffixOf)

mySmartExample :: String -> Char
mySmartExample xs = if (not . null) xs
                      then head xs
                      else 'Z'

myOtherExample :: String -> Char
myOtherExample (x:_) = x
myOtherExample [] = 'Z'

main :: IO ()
main = do
  print $ "hello" ++ " " ++ "world"
  print $ [] ++ [1,2,3]
  print $ concat [[1,2,3], [2,3,4], [2,3,4]]
  print $ reverse "fpd"
  print $ and [True, False, True]
  print $ or [True, False, False]
  print $ all odd [1..10]
  print $ takeWhile odd [1,3,5,7,8,1,2,3]
  print $ dropWhile odd [1,3,5,7,8,1,2,3]
  print $ 1 `elem` [1..10]
  print $ 1 `notElem` [1..10]
  print $ ("foo" `isPrefixOf` "fooworld")
