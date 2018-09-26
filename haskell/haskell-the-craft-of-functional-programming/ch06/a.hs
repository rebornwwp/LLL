import           Data.List       (transpose)
import           Test.QuickCheck hiding (scale)

snd' :: (a, b) -> b
snd' (_, y) = y

sing :: a -> [a]
sing x = [x]

type Picture = [[Char]]

-- 镜子对称
flipH :: Picture -> Picture
flipH = reverse

-- 将一个图形放置于另外一个图形之上
above :: Picture -> Picture -> Picture
above = (++)

flipV :: Picture -> Picture
flipV pic = [reverse line | line <- pic]

beside :: Picture -> Picture -> Picture
beside picL picR = [l ++ r | (l, r) <- zip picL picR]

invertChar :: Char -> Char
invertChar ch = if ch == '.' then '#' else ch

invertLine :: [Char] -> [Char]
invertLine line = [invertChar ch | ch <- line]

invertColor :: Picture -> Picture
invertColor pic = [invertLine line | line <- pic]

prop_AboveFlipV :: Picture -> Picture -> Bool
prop_AboveFlipV pic1 pic2 = flipV (pic1 `above` pic2) == (flipV pic1) `above` (flipV pic2)

prop_AboveFlipH :: Picture -> Picture -> Bool
prop_AboveFlipH pic1 pic2 = flipH (pic1 `above` pic2) == (flipH pic1) `above` (flipH pic2)

propAboveBeside :: Picture -> Picture -> Picture -> Picture -> Bool
propAboveBeside nw ne sw se = (nw `beside` ne) `above` (sw `beside` se) == (nw `above` sw) `above` (ne `above` se)

superimposeChar :: Char -> Char -> Char
superimposeChar '.' '.' = '.'
superimposeChar _ _     = '#'

superimposeLine :: String -> String -> String
superimposeLine l1 l2 = [superimposeChar ch1 ch2 | (ch1, ch2) <- zip l1 l2]

superimpose :: Picture -> Picture -> Picture
superimpose pic1 pic2 = [superimposeLine l1 l2 | (l1, l2) <- zip pic1 pic2]

printPicture :: Picture -> IO ()
printPicture pic1 = putStr $ unlines pic1

rotate90 :: Picture -> Picture
rotate90 = flipV . transpose

rotateLeft90 :: Picture -> Picture
rotateLeft90 = rotate90 . rotate90 . rotate90

scaleLine :: String -> Int -> String
scaleLine s n = concat [replicate n ch | ch <- s]

scaleH :: Picture -> Int -> Picture
scaleH pic n = [scaleLine line n | line <- pic]

scaleV :: Picture -> Int -> Picture
scaleV pic n = concat [replicate n line | line <- pic]

scale :: Picture -> Int -> Picture
scale pic n
  | n > 0 = scaleV (scaleH pic n) n
  | otherwise = [""]

pic1 :: Picture
pic1 = [".##.", ".#.#", ".###", "####"]

pic2 :: Picture
pic2 = rotate90 pic1

pic3 :: Picture
pic3 = rotateLeft90 pic1

