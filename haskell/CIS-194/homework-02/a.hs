module Main where

func :: Int -> String -> String
func n s =
  case (n, s) of
    (1, "he") -> "hello"
    (2, "he") -> "ee"
    (_, _) -> "no"

main :: IO ()
main = do
  print $ func 1 "he"