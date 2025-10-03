module Fixit where

{-
The fix function can be defined as:

fix :: (a -> a) -> a
fix f = let x = f x in x
If we regard this as a language primitive, any recursive function can be written without using recursion. Write foldr' and reverse' as non-recursive functions that can be 'fixed' to foldr and reverse as follows:

foldr = fix foldr'
reverse = fix reverse'
For a more detailed explanation of the fix function, see http://en.wikipedia.org/wiki/Fixed-point_combinator

Note: foldr is lazy, so your foldr' should be lazy too.
-}

import Prelude hiding (reverse, foldr)


reverse' :: ([a] -> [a]) -> [a] -> [a]
reverse' f a = case a of
                    []     -> []
                    (x:xs) -> f xs ++ [x]

type Fr a b = (a -> b -> b) -> b -> [a] -> b

foldr' :: Fr a b -> Fr a b
foldr' _ _ init []     = init
foldr' f g acc  (x:xs) = x `g` f g acc xs
