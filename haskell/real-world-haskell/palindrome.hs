toPalindrome :: [a] -> [a]
toPalindrome xs = xs ++ reverse xs

isPalindrome :: [Integer] -> Bool
isPalindrome xs = xs == reverse xs

main = do
  print $ toPalindrome [1,2,3]
  print $ isPalindrome [1,2,3,2,1]
