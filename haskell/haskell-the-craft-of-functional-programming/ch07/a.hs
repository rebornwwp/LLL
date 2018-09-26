module Ch (Word) where

import           Data.Char (isAlpha, toLower)
import           Prelude   hiding (Word, getLine)

head' :: [a] -> a
head' (x:_) = x

tail' :: [a] -> [a]
tail' (_:xs) = xs

null' :: [a] -> Bool
null' []    = True
null' (_:_) = False

concat' :: [[a]] -> [a]
concat' []     = []
concat' (x:xs) = x ++ concat' xs

whitespace = ['\n', '\t', ' ']

getWord :: String -> String
getWord [] = []
getWord (x:xs)
  | elem x whitespace = []
  | otherwise = x : getWord xs

dropWord :: String -> String
dropWord [] = []
dropWord (x:xs)
  | elem x whitespace = (x : xs)
  | otherwise = dropWord xs

dropSpace :: String -> String
dropSpace [] = []
dropSpace (x:xs)
  | elem x whitespace = dropSpace xs
  | otherwise = x : xs

type Word = String

splitWord :: String -> [Word]
splitWord st = split (dropSpace st)

split :: String -> [Word]
split [] = []
split st = (getWord st) : split (dropSpace (dropWord st))

type Line = [Word]

getLine :: Int -> [Word] -> Line
getLine len [] = []
getLine len (w:ws)
  | length w <= len = w : restOfLine
  | otherwise = []
  where
    newlen = len - (length w + 1)
    restOfLine = getLine newlen ws

lineLen = 20

dropLine :: Int -> [Word] -> Line
dropLine len [] = []
dropLine len (w:ws)
  | length w <= len = dropLine newLen ws
  | otherwise = w : ws
  where
    newLen = len - (length w + 1)

splitLines :: [Word] -> [Line]
splitLines [] = []
splitLines ws = getLine lineLen ws : splitLines (dropLine lineLen ws)

fill :: String -> [Line]
fill = splitLines . splitWord

joinLine :: Line -> String
joinLine ws = line ++ replicate (lineLen - length line) ' '
  where line = unwords ws
-- joinLine []     = ""
-- joinLine [w]    = w
-- joinLine (w:ws) = w ++ " " ++ joinLine ws

joinLines :: [Line] -> String
joinLines []     = ""
joinLines (l:ls) = joinLine l ++ "\n" ++ joinLines ls

wc :: String -> (Int, Int, Int)
wc st = (length st, length ws, length ls)
  where
    ws = words st
    ls = lines st

wcFormat :: String -> (Int, Int, Int)
wcFormat st = (length formatSt, length formatWs, length formatLs)
  where
    formatSt = joinLines (fill st)
    formatWs = words formatSt
    formatLs = lines formatSt

isPalin :: String -> Bool
isPalin st = alphas == reverse alphas
  where
    alphas = [toLower ch | ch <- st, isAlpha ch]

subst :: String -> String -> String -> String
subst oldSub newSub st = f oldSub newSub subws
  where
    subws = split st
    f _ _ [] = ""
    f old sub (w:ws)
      | old == w = sub ++ if length ws == 0 then "" else " " ++ f old sub ws
      | otherwise = w ++ if length ws == 0 then "" else " " ++ f old sub ws

