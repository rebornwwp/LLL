{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE OverloadedStrings #-}


import           Data.List
import           Data.List.Split
import           Data.Ord
import           Data.Vector     (fromList, (!))

-- minimum scalar product
f []             = []
f (_:xs:ys:rest) = solve (map read $ words xs) (map read $ words ys) : f rest

solve xs ys = show $ minimum [sum $ zipWith (*) xs p | p <- permutations ys]

-- sortOn Down is equal to (reverse . sort)
solve' xs ys = show . sum $ zipWith (*) (sort xs) (sortOn Down ys)

main1 =
  interact $
  unlines .
  zipWith (++) ["Case #" ++ show t ++ ": " | t <- [1 ..]] . f . tail . lines

-- alien language
main2 =
  interact $
  unlines . zipWith (++) ["Case #" ++ show t ++ ": " | t <- [1 ..]] . fInMain2 . lines

fInMain2 (_ldn:s) =
  let [_, d, _] = map read $ words _ldn
      (ds, ps) = splitAt d s
      match p = show . length $ filter (and . zipWith (flip elem) (parse p)) ds
   in map match ps

parse []      = []
parse ('(':s) = let (a, _:b) = break (== ')') s in a : parse b
parse (c:s)   = [c] : parse s

-- rope intranet
main3 =
  interact $
  unlines .
  zipWith (++) ["Case #" ++ show t ++ ": " | t <- [1 ..]] . fInMain3 . tail . lines

fInMain3 [] = []
fInMain3 (_n:s) = let
  (_abs, s1) = splitAt (read _n) s
  in solve3 (map (map read . words) _abs) : fInMain3 s1

solve3 _ws =
  let ws = fromList _ws
      m = length _ws - 1
   in show $
      length
        [ undefined
        | i <- [0 .. m - 1]
        , j <- [i + 1 .. m]
        , let ([a1, b1], [a2, b2]) = (ws ! i, ws ! j)
        , signum (a2 - a1) /= signum (b2 - b1)
        ]

-- file fix-it
main4 = interact $ unlines . zipWith (++)
  ["Case #" ++ show t ++ ": "| t <- [1..]] . fInMain4 . tail . lines

fInMain4 [] = []
fInMain4 (_nm:s) =
  let [n, m] = map read $ words _nm
      (ns, s1) = splitAt n s
      (ms, s2) = splitAt m s1
   in solve4 ns ms : fInMain4 s2

solve4 ns ms = show $ length (g ds ms) - length ds
  where ds = g [""] ns

g ds = union ds . concatMap (map (intercalate "/") . inits . splitOn "/")

