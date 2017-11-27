f :: Int -> [Int] -> [Int]
f n arr = [ x | x <- arr, x < n ]

-- This part handles the Input and Output and can be used as it is. Do not modify this part.
main :: IO ()
main = do
    val1 <- readLn
    val2 <- readLn
    let val3 = f val1 val2
    print val3
