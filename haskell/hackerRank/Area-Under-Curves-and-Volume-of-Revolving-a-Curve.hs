import           Text.Printf (printf)

-- This function should return a list [area, volume].
solve :: Int -> Int -> [Int] -> [Int] -> [Double]
solve l r a b =
    let func = algebraicFunc a b
        interval = 0.001
        doubleL = fromIntegral l
        doubleR = fromIntegral r
        sampleNumbers = [doubleL, doubleL+interval..doubleR-interval]
    in [sum $ map ((*interval) . abs . func) sampleNumbers, sum $ map (circleAreaInterval . func) sampleNumbers]

algebraicFunc :: [Int] -> [Int] -> Double -> Double
algebraicFunc as bs x = sum [fromIntegral a * x ^ b | (a, b) <- zip as bs]

circleAreaInterval :: Double -> Double
circleAreaInterval r =  pi * r ^ 2 * 0.001

--Input/Output.
main :: IO ()
main = getContents >>= mapM_ (printf "%.1f\n"). (\[a, b, [l, r]] -> solve l r a b). map (map read. words). lines

