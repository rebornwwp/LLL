module Codewars.Kata.LongestPalindrome where

{-
Longest Palindrome

Find the length of the longest substring in the given string s that is the same in reverse.

As an example, if the input was “I like racecars that go fast”, the substring (racecar) length would be 7.

If the length of the input string is 0, the return value must be 0.

Example:

"a" -> 1
"aab" -> 2
"abcde" -> 1
"zzbaabcd" -> 4
"" -> 0
-}

isPalindrome, isPalindrome' :: String -> Bool
isPalindrome s = s == reverse s
isPalindrome' = (==) <*> (reverse) -- 同时将传入第一个函数和第二个函数中

substrings :: String -> [String]
substrings [] = []
substrings (x:xs) = substrings' (x:xs) ++ substrings xs
  where
    substrings' :: String -> [String]
    substrings' []     = []
    substrings' (y:ys) = [y] : [ (y:s) | s <- substrings' ys]

longestPalindrome :: String -> Int
longestPalindrome "" = 0
longestPalindrome s = maximum $ map length $ filter isPalindrome $ substrings s



main :: IO ()
main = do
  print $ substrings "abcde"
  print $ isPalindrome "abc"
  print $ isPalindrome "aba"
  print $ longestPalindrome "zzbaabcd"
  print $ longestPalindrome "abcde"

