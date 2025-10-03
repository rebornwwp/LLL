module Codewars.G964.Fibkind where

{-
Be u(n) a sequence defined by u(1) = u(2) = 1 and by the table below up to u(23):

index	1	2	3!	4!	5	6	7	?8	9	10	11	12
u	1	1	[2]	[3]	3	(4)	(5)	?5	6	6	6	8
index	??13	14	15	16	17	18	19	20	21	22	23	...
u	8	8	10	9	10	11	11	12	12	12	12	...
How is the term at index 8 calculated?

Let us look the terms at indexes 7 and 6. We have u(7) = 5 and u(6) = 4 (with parentheses). These two numbers tell us that we have to go backwards to index 8 - 5 = 3 and to index 8 - 4 = 4 so to index 3 and 4 (with exclamation marks).

We have u(3) = 2 and u(4) = 3 (with square brackets) hence u(8) = 2 + 3 = 5.

Another example: let us calculate the term at index 13. At indexes 12 and 11 we have 8 and 6. Going backwards of 8 and 6 from 13 we get indexes 5 and 7. u(5) = 3 and u(7) = 5 so u(13) = 3 + 5 = 8.

Task

0) Express u(n) as a function of n, u(n -1), u(n - 2). (not tested).
1) Given two numbers n, k (integers > 2) write the function length_sup_u_k(n, k) or lengthSupUK or length-sup-u-k returning the number of terms u(i) >= k with i from 1 inclusive to n inclusive. If we look above we can see that between u(1) and u(23) we have four u(i) greater or equal to 12: length_sup_u_k(23, 12) => 4
2) Given n (integer > 2)return the number of times where a term of u is less than its predecessor up to and including u(n). Call this last function comp(n)
Examples:

u(900) => 455 (not tested)
u(90000) => 44337 (not tested)

length_sup_u_k(23, 12) => 4
length_sup_u_k(50, 10) => 35
length_sup_u_k(500, 100) => 304

comp(23) => 1 (since only u(16) < u(15))
comp(100) => 22
comp(200) => 63
Note: Shell

Shell tests only lengthSupUk
-}

fibos = 1 : 1 : map (\i -> fibos !! (i - fibos !! (i - 1)) + fibos !! (i - fibos !! (i - 2))) [2 ..]

fibos' = 1 : 1 : go 2
  where
    go n = fibos' !! (n - fibos' !! (n - 1)) + fibos' !! (n - fibos' !! (n - 2)) : go (n + 1)

lengthSupUK :: Int -> Int -> Int
lengthSupUK n k = length . filter (>= k) $ take n fibos'

comp :: Int -> Int
comp n = length $ filter (\(i, j) -> (i > j)) $ zip (take n fibos) (drop 1 (take n fibos))

main = do
  print $ take 23 fibos
  print $ take 23 fibos'
  print $ lengthSupUK 23 12
  print $ lengthSupUK 50 12
  print $ lengthSupUK 500 100
  print $ comp 23
  print $ comp 100
  print $ comp 200

