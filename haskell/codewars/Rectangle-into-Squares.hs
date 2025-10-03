module Codewars.Kata.Rectangle where
{-
The drawing below gives an idea of how to cut a given "true" rectangle into squares ("true" rectangle meaning that the two dimensions are different).

alternative text

Can you translate this drawing into an algorithm?

You will be given two dimensions

a positive integer length (parameter named lng)
a positive integer width (parameter named wdth)
You will return an array or a string (depending on the language; Shell bash and Fortran return a string) with the size of each of the squares.

squaresInRect  5  3 `shouldBe` Just [3,2,1,1]
squaresInRect  3  5 `shouldBe` Just [3,2,1,1]
squaresInRect 20 14 `shouldBe` Just [14, 6, 6, 2, 2, 2]
Notes:

lng == wdth as a starting case would be an entirely different problem and the drawing is planned to be interpreted with lng != wdth. (See kata, Square into Squares. Protect trees! http://www.codewars.com/kata/54eb33e5bc1a25440d000891 for this problem). When the initial parameters are so that lng == wdth, the solution [lng] would be the most obvious but not in the spirit of this kata so, in that case, return None/nil/null/Nothing. Return {} with C++. In that case the returned structure of C will have its sz component equal to 0. Return the string "nil" with Bash and Fortran.
You can see more examples in "RUN SAMPLE TESTS".
-}
squaresInRect :: Integer -> Integer -> Maybe [Integer]
squaresInRect lng wdth
  | lng == wdth = Nothing
  | otherwise = Just (squares lng wdth)
  where
    squares :: Integer -> Integer -> [Integer]
    squares _ 0 = []
    squares 0 _ = []
    squares lng wdth
      | lng > wdth = wdth : squares wdth (lng - wdth)
      | wdth > lng = lng : squares lng (wdth - lng)
      | otherwise = lng : squares lng 0

main :: IO ()
main = do
  print $ squaresInRect 5 3
  print $ squaresInRect 3 5
  print $ squaresInRect 20 14
  print $ squaresInRect 20 20

