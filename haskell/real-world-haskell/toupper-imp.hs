import System.IO
import Data.Char (toUpper)

mainloop :: Handle -> Handle -> IO ()
mainloop inh outh =
  do ineof <- hIsEOF inh
     if ineof
       then return () -- haskell 中return和<-是两个相反的操作
       else do inpStr <- hGetLine inh
               hPutStrLn outh (map toUpper inpStr)
               mainloop inh outh

main :: IO ()
main = do
  inh <- openFile "quux.txt" ReadMode
  outh <- openFile "out.txt" WriteMode
  mainloop inh outh
  hClose inh
  hClose outh

