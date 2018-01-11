maximum' :: (Ord a) => [a] -> a
maximum' [] = error "maximum of empty list"
maximum' [x] = x
maximum' (x:xs) = max x $ maximum' xs


replicate' :: (Num i, Ord i) => i -> a -> [a]
replicate' n x
   | n <= 0 = []
   | otherwise = x:replicate' (n-1) x


take' :: (Num i, Ord i) => i -> [a] -> [a]
take' n _
    | n <= 0 = []
take' _ [] = []
take' n (x:xs) = x:take' (n-1) xs


reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]

repeat' :: a -> [a]
repeat' x = x:repeat' x

-- use example: take' 3 $ repeat' 4


zip' :: [a] -> [a] ->[(a, a)]
zip' [] _ = []
zip' _ [] = []
zip' (x:xs) (y:ys) = (x, y):zip' xs ys


elem' :: (Eq a) => a -> [a] -> Bool
elem' n [] = False
elem' n (x:xs)
    | n == x = True
    | otherwise = elem' n xs


quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) = 
    let smallerList = quicksort [ a | a <- xs, a <= x]
        biggerList = quicksort [ a | a <- xs, a > x]
    in smallerList ++ [x] ++ biggerList


-- Curried functions
multThree :: (Num a) => a -> a -> a
multThree x y z = x*y*z

let multTwoWithNine = multThree 9
