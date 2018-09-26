module SplitLines where

isLineTerminator :: Char -> Bool
isLineTerminator c = c == '\n' || c == '\r'

splitLines :: String -> [String]
splitLines xs =
  let (pre, suf) = break isLineTerminator xs
   in pre :
      case suf of
        ('\r':'\n':rest) -> splitLines rest
        ('\r':rest) -> splitLines rest
        ('\n':rest) -> splitLines rest
        _ -> []

main = do
  print $ break isLineTerminator "hello\r\n\nworld\n"
  print $ splitLines "hello world\n\n fjdkfsdk\rfjdksjfksa\nhe"
