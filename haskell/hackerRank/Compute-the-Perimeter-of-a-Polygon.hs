import           Control.Monad
import           Data.List

-- perimeter :: [(Int, Int)] -> Float
-- p


main = do
        n <- fmap (read::String->Int) getLine
        func <- forM [1..n] (\_->do fmap ((\[a, b]->(a,b)).map (read::String->Int).words) getLine :: IO (Int, Int))
        putStrLn func
