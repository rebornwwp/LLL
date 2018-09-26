import           Prelude         hiding ((&&))
import           Test.QuickCheck

-- 3-1 Bool
exOr, exOr', exOr'' :: Bool -> Bool -> Bool
exOr x y = (x || y) && not (x && y)

exOr' True x  = not x
exOr' False x = x

exOr'' True False = True
exOr'' False True = True
exOr'' _ _        = False

myNot :: Bool -> Bool
myNot True  = False
myNot False = True

prop_myNot :: Bool -> Bool
prop_myNot x = not x == myNot x

prop_exOrs, prop_exOrs' :: Bool -> Bool -> Bool
prop_exOrs x y = exOr x y == exOr' x y
prop_exOrs' x y = exOr x y == (x /= y)

max :: Integer -> Integer -> Integer
max x y = if x > y then x else y

(&&) :: Bool -> Bool -> Bool
(&&) True True = True
(&&) _ _       = False

nAnd :: Bool -> Bool -> Bool
nAnd True True = False
nAnd _ _       = True

-- Integer
threeEqual :: Integer -> Integer -> Integer -> Bool
threeEqual x y z = (x == y) && (y == z)

-- 类型的转换
-- fromInteger :: Integer -> Int
-- toInteger :: Int -> Integer

mystery :: Integer -> Integer -> Integer -> Bool
mystery x y z = not ((x == y) && (y == z))

threeDifferent :: Integer -> Integer -> Integer -> Bool
threeDifferent x y z = (x /= y) && (y /= z) && (z /= x)

fourEqual :: Integer -> Integer->Integer->Integer->Bool
fourEqual x y z a = (x == y) && (y == z) && (z == a)

prop_mystery :: Integer-> Integer->Integer->Bool
prop_mystery x y z = mystery x y z == not (threeEqual x y z)

-- 守卫
max', min' :: Integer -> Integer -> Integer
max' x y
  | x >= y = x
  | otherwise = y
min' x y = if x >= y then y else x

-- 字符和串
-- 字符与其数值编码之间的转换
-- fromEnum :: Char -> Int
-- toEnum :: Int -> Char

offset :: Int
offset = fromEnum 'A' - fromEnum 'a'

toUpper :: Char -> Char
toUpper ch = toEnum (fromEnum ch + offset)

isDigit :: Char -> Bool
isDigit ch = ('0' <= ch) && (ch <= '9')

isLower :: Char -> Bool
isLower ch = ('a' <= ch) && (ch <= 'z')

toUpper' :: Char -> Char
toUpper' ch = if isLower ch then toUpper ch else ch

charToNum :: Char -> Int
charToNum ch = if isDigit ch then fromEnum ch - fromEnum '0' else 0

onThereLines :: String -> String -> String -> String
onThereLines a b c = a ++ "\n" ++ b ++ "\n" ++ c

romanDigit :: Int -> String
romanDigit x = undefined

-- Float
-- (**) :: Float -> Float -> Float
-- (^) :: Float -> Integer -> Float
-- ceiling :: Float -> Integer

averageThree :: Integer -> Integer -> Integer -> Float
averageThree x y z = (x + y + z) / 3

howManyAboveAverage :: Integer -> Integer -> Integer -> Integer
howManyAboveAverage x y z = toInteger . length . filter (> average) . map fromInteger $ [x, y, z]
  where average = averageThree x y z

(&&&) :: Integer -> Integer -> Integer
(&&&) x y
  | x > y = x
  | otherwise = y

main :: IO()
main = do
  quickCheck prop_exOrs'
  quickCheck prop_exOrs
  quickCheck prop_myNot
  quickCheck prop_mystery

