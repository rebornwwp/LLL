import Control.Applicative
import Control.Monad
import System.IO


hello_words i = mapM_ putStrLn $ replicate i "Hello World"

main :: IO ()
main = do
    n_temp <- getLine
    let n = read n_temp :: Int
    hello_worlds n
