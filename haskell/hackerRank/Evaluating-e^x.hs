import           Control.Applicative
import           Control.Monad
import           System.IO


main :: IO ()
main = do
    n_temp <- getLine
    let n = read n_temp :: Int
    forM_ [1..n] $ \a0  -> do
        x_temp <- getLine
        let x = read x_temp :: Double
        print $ taylor x 9


taylor :: Double -> Integer -> Double
taylor x n
  | n < 0 = 0
  | n <= 9 = item x n + taylor x (n-1)
  | otherwise = 0

item :: Double -> Integer -> Double
item x n = product [x / fromIntegral k | k <- [1..n]]
