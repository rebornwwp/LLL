import qualified Data.Map as Map

data Shape = Circle Float Float Float | Rectangle Float Float Float Float deriving (Show)
-- record syntax and derived instances
data Person = Person { firstName   :: String
                     , lastName    :: String
                     , age         :: Int
                     , height      :: Float
                     , phoneNumber :: String
                     , flavor      :: String
                     } deriving (Eq, Show, Read)
data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
           deriving (Eq, Ord, Show, Read, Bounded, Enum)
-- type parameters
data Maybe a = Nothing | Just a

-- type synonyms
type Phone = String
type AssocList k v = [(k, v)]

-- 可以利用上面的得到新的函数
data LockerState = Taken | Free deriving (Show, Eq)
type Code = String
type LockerMap = Map.Map Int (LockerState, Code)

-- recursive data structures
infixr 5 :-:
data List a = Empty | a :-: (List a) deriving (Show, Read, Eq, Ord)

-- binary search tree
data Tree a = EmptyTree | Node a (Tree a) (Tree a) deriving (Show, Read, Eq)

surface :: Shape -> Float
surface (Circle _ _ r)          = pi * r ^ 2
surface (Rectangle x1 y1 x2 y2) = (abs $ x2 - x2) * (abs $ y1 - y2)

-- typeclass 就像是 interface。一个 typeclass 定义了一些行为(像是比较相不相等，比较大小顺序，能否穷举)而我们会把希望满足这些性质的型别定义成这些 typeclass 的 instance。typeclass 的行为是由定义的函数来描述。并写出对应的实作。当我们把一个型别定义成某个 typeclass 的 instance，就表示我们可以对那个型别使用 typeclass 中定义的函数。


main = do
  print $ surface $ Circle 10.0 10.0 10.0
  print $ map (Circle 10 20) [4,5,6,7]
  print $ 3 :-: 4 :-: 5 :-: Empty
