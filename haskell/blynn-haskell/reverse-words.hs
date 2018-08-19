import Data.Array

main' =
  interact $
  unlines .
  zipWith (++) ["Case #" ++ show t ++ ": " | t <- [1 ..]] .
  map solve . tail . lines

solve = unwords . reverse . words

solve' c ps =
  let m = length ps - 1
   in head
        [ show (i + 1) ++ " " ++ show (j + 1)
        | i <- [0 .. m - 1]
        , j <- [i + 1 .. m]
        , ps !! i + ps !! j == c
        ]

solve'' c ps =
  let n = length ps
      a = listArray (1, n) ps
   in head
        [ show i ++ " " ++ show j
        | i <- [1 .. n - 1]
        , j <- [i + 1 .. n]
        , a ! i + a ! j == c
        ]

f [] =[]
f (_c:_:_ps:s) = solve'' (read _c) (map read $ words _ps) : f s

main =
  interact $
  unlines .
  zipWith (++) ["Case #" ++ show t ++ ": " | t <- [1 ..]] . f . tail . lines
