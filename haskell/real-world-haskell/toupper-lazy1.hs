import           Data.Char (toUpper)
import           System.IO

main :: IO ()
main =
  do
    inh <- openFile "quux.txt" ReadMode
    outh <- openFile "lazyout.txt" WriteMode
    inputStr <- hGetContents inh
    let result = processData inputStr
    hPutStr outh result
    hClose inh
    hClose outh
    str2action "start of the program"
    printitall
    str2action "Done"

processData :: String -> String
processData = map toUpper

str2action :: String -> IO ()
str2action input = putStrLn ("Data: " ++ input)

list2action :: [String] -> [IO ()]
list2action = map str2action

numbers :: [Int]
numbers = [1 .. 10]

strings :: [String]
strings = map show numbers

-- 将一个函数放在list中，等到我们需要的时候再执行函数
actions :: [IO ()]
actions = list2action strings

printitall :: IO ()
printitall = runall actions

runall :: [IO ()] -> IO ()
runall [] = return ()
runall (firstelem:remainingelems) =
  do firstelem
     runall remainingelems

