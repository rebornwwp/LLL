module Basic.SumTypesAndProductTypes where


-- M + N
data Sum
  = A
  | B

type Boola = Either () ()

false :: Boola
false = Left ()

true :: Boola
true = Right ()


-- productTypes
-- M * N
x :: (Integer, String)
x = (4, "hello")
