module Codewars.Kata.TenMinuteWalk where

{-
You live in the city of Cartesia where all roads are laid out in a perfect
grid. You arrived ten minutes too early to an appointment, so you decided to
take the opportunity to go for a short walk. The city provides its citizens
with a Walk Generating App on their phones -- everytime you press the button
it sends you an array of one-letter strings representing directions to walk
(eg. ['n', 's', 'w', 'e']). You always walk only a single block in a
direction and you know it takes you one minute to traverse one city block,
so create a function that will return true if the walk the app gives you
will take you exactly ten minutes (you don't want to be early or late!)
and will, of course, return you to your starting point.
Return false otherwise.

Note: you will always receive a valid array containing a random assortment
of direction letters ('n', 's', 'e', or 'w' only). It will never give you
an empty array (that's not a walk, that's standing still!).
-}

isValidWalk :: [Char] -> Bool
isValidWalk walk
  | length walk11 == 10 = move walk11 == (0, 0)
  | otherwise = False
  where
    walk11 = take 11 walk
    moveMap :: Char -> (Int, Int)
    moveMap 'n' = (1, 0)
    moveMap 's' = (-1, 0)
    moveMap 'w' = (0, 1)
    moveMap 'e' = (0, -1)
    moveMap _   = (0, 0)
    move :: [Char] -> (Int, Int)
    move = foldl (\acc c-> let (x, y) = moveMap c in (fst acc + x, snd acc + y)) (0, 0)

main :: IO ()
main = do
  print $ isValidWalk "nswenswens"
  print $ isValidWalk "nswee"
  print $ isValidWalk ['n','s','n','s','n','s','n','s','n','s']
  print $ isValidWalk $ repeat 'n'
