module Codewars.G964.Johnann where

{-
John and his wife Ann have decided to go to Codewars.

On first day Ann will do one kata and John - he wants to know how it is working - 0 kata.

Let us call a(n) the number of katas done by Ann at day n. We have a(0) = 1 and in the same manner j(0) = 0 (or a(1) = 1 and j(1) = 0 for languages that have arrays with indices beginning at 1).

They have chosen the following rules:

On day n the number of katas done by Ann should be n minus the number of katas done by John at day t, t being equal to the number of katas done by Ann herself at day n - 1.
On day n the number of katas done by John should be n minus the number of katas done by Ann at day t, t being equal to the number of katas done by John himself at day n - 1.
Whoops! I think they need to lay out a little clearer exactly what there're getting themselves into!

Could you write:

1) two functions ann and john (parameter n) giving the list of the numbers of katas Ann and John should take on the first n days (see first examples below)?
2) The total number of katas taken by ann function sum_ann(n) and john function sum_john(n) - on the first n days?
The functions in 1) are not tested in Fortran and not tested in Shell.

Examples:

john(11) -->  [0, 0, 1, 2, 2, 3, 4, 4, 5, 6, 6]
ann(6) -->  [1, 1, 2, 2, 3, 3]

sum_john(75) -->  1720
sum_ann(150) -->  6930
Shell Note:

sumJohnAndAnn has two parameters:

first one : n (number of days, $1)

second one : which($2) ->

1 for getting John's sum
2 for getting Ann's sum.
See "Sample Tests".

Note:

Keep an eye on performance.
-}

anns :: [Integer]
anns = 1 : [fromIntegral x - johns !! (fromIntegral $ anns !! (x - 1)) | x <- [1 ..]]

johns :: [Integer]
johns = 0 : [fromIntegral x - anns !! (fromIntegral $ johns !! (x - 1)) | x <- [1 ..]]

annAux :: [Int]
annAux = 1 : zipWith (-) [1..] (map (johnAux !!) annAux)

johnAux :: [Int]
johnAux = 0 : zipWith (-) [1 ..] (map (annAux !!) johnAux)

ann :: Int -> [Integer]
ann n = take n anns

john :: Int -> [Integer]
john n = take n johns

sumAnn :: Int -> Integer
sumAnn n = sum (ann n)
sumJohn :: Int -> Integer
sumJohn n = sum (john n)

main = do
  print $ take 11 johns
  print $ take 6 anns
  print $ sumAnn 150
  print $ sumJohn 75
