data Direction = LEFT | RIGHT | STRAIGHT deriving (Show, Eq)

data CartesianPoint = Point {x :: Double, y :: Double}
                      deriving (Show)

directionOf :: CartesianPoint -> CartesianPoint -> CartesianPoint -> Direction
directionOf a v b | sign > 0  = RIGHT
                  | sign < 0  = LEFT
                  | otherwise = STRAIGHT
            where sign = (x v - x a) * (y b - y a) - (y v - y a) * (x b - x a)

directionsOf :: [CartesianPoint] -> [Direction]
directionsOf [] = []
directionsOf [_] = []
directionsOf [_, _] = []
directionsOf (p1:p2:p3:rest)= directionOf p1 p2 p3 : directionsOf (p2 : p3 : rest)

main :: IO ()
main = do
  print $ directionOf (Point 0 1) (Point 0 0) (Point 1 0)
  let point = Point 1 2
  print $ x point
  print $ y point
  print $ directionsOf [Point 0 1, Point 0 0, Point 1 0, Point 3 4]
