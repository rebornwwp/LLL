import System.Environment (getArgs)
import Data.List

-- 1
safeHead :: [a] -> Maybe a
safeHead [] = Nothing
safeHead xs = Just (head xs)

safeTail :: [a] -> Maybe [a]
safeTail [] = Nothing
safeTail xs = Just (tail xs)

safeLast :: [a] -> Maybe a
safeLast [] = Nothing
safeLast xs = Just (last xs)

safeInit :: [a] -> Maybe [a]
safeInit [] = Nothing
safeInit xs = Just (init xs)

-- 2
isWordTerminator :: Char -> Bool
isWordTerminator c = c == '\n' || c == '\r' || c == '\t' || c == ' '

splitWith :: (a -> Bool) -> [a] -> [[a]]
splitWith f xs =
  let (pre, suf) = break f xs
   in filter (not . null) $
      pre :
      case suf of
        (_:rest) -> splitWith f rest
        _ -> []

interactWith :: (String -> String) -> String -> String -> IO ()
interactWith function inputFile outputFile = do
  input <- readFile inputFile
  writeFile outputFile (function input)

transposeLine :: String -> String
transposeLine = unlines . transpose . lines

main :: IO ()
main = do
  print $ splitWith isWordTerminator "hello\nee e\r\r\nfd\tfdf\n\n\n\n\n"
  print $ transposeLine "hello\nworld\n"
  mainWith myFunction
  where
    mainWith function = do
      args <- getArgs
      case args of
        [input, output] -> interactWith function input output
        _ -> putStrLn "error: exactly two arguments needed"
    myFunction = unlines . map (head . words) . lines

