data BookInfo = Book Int String [String]
                deriving (Show)

data MagzineInfo = Magzine Int String [String]
                   deriving (Show)

myInfo = Book 9780135072455 "Algebra of Programming"
              ["Richard Bird", "Oege de Moor"]


-- 类型别名
type CustomerID = Int
type ReviewBody = String

data BetterReview = BetterReview BookInfo CustomerID ReviewBody
