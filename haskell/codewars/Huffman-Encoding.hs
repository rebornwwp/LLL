module Huffman
    ( frequencies
    , encode
    , decode
    , Bit (..)
    ) where

{-
Motivation

Natural language texts often have a very high frequency of certain letters, in German for example, almost every 5th letter is an E, but only every 500th is a Q. It would then be clever to choose a very small representation for E. This is exactly what the Huffman compression is about, choosing the length of the representation based on the frequencies of the symbol in the text.

Algorithm

Let's assume we want to encode the word "aaaabcc", then we calculate the frequencies of the letters in the text:

Symbol	Frequency
a	4
b	1
c	2
Now we choose a smaller representation the more often it occurs, to minimize the overall space needed. The algorithm uses a tree for encoding and decoding:

  .
 / \
a   .
   / \
   b  c
Usually we choose 0 for the left branch and 1 for the right branch (but it might also be swapped). By traversing from the root to the symbol leaf, we want to encode, we get the matching representation. To decode a sequence of binary digits into a symbol, we start from the root and just follow the path in the same way, until we reach a symbol.

Considering the above tree, we would encode a with 0, b with 10 and c with 11. Therefore encoding "aaaabcc" will result in 0000101111.

(Note: As you can see the encoding is not optimal, since the code for b and c have same length, but that is topic of another data compression Kata.)

Tree construction

To build the tree, we turn each symbol into a leaf and sort them by their frequency. In every step, we remove 2 trees with the smallest frequency and put them under a weight. This weight gets reinserted and has the sum of the frequencies of both trees as new frequency. We are finished, when there is only 1 tree left.

(Hint: Maybe you can do it without sorting in every step?)

Goal

Write functions frequencies, encode and decode.

Bits are represented as a list of Z (zero) and O (one).
(Hint: You can assume that symbols can be ordered.)

Note: Frequency lists with just one or less elements should get rejected. (Because then there is no information we could encode, but the length.)
-}

import           Control.Arrow (first, second)
import           Data.List

data Bit = Z | O deriving (Eq, Show)

data Tree a = Empty
            | Node Int (Tree a) (Tree a)
            | Leaf a Int
            deriving (Show)

type Code a = [(a, [Bit])]

instance Eq (Tree a) where
  (==) a b = (weight a) == (weight b)

instance Ord (Tree a) where
  left >= right = (weight left) >= (weight right)
  left > right = (weight left) > (weight right)
  left < right = (weight left) < (weight right)
  left <= right = (weight left) <= (weight right)

empty :: Tree a
empty = Empty

weight :: Tree a -> Int
weight (Node n _ _) = n
weight (Leaf _ n)   = n

-- | Calculate symbol frequencies of a text.
frequencies :: Ord a => [a] -> [(a, Int)]
frequencies xs = [(c, length $ filter (== c) xs) | c <- nub xs]

-- | Encode a sequence using the given frequencies.
encode :: Ord a => [(a, Int)] -> [a] -> Maybe [Bit]
encode xs ys
  | length xs <= 1 = Nothing
  | length xs > 1 = if length ys == 0 then Just [] else Just $ foldl (\acc y -> acc ++ case lookup y codemaps of
                                                                        Just co -> co
                                                                        Nothing -> []) [] ys
  where codemaps = codewords $ head $ huffman $ sort $ treefy xs

-- | Decode a bit sequence using the given frequencies.
decode :: [(a, Int)] -> [Bit] -> Maybe [a]
decode xs ys
  | length xs <= 1 = Nothing
  | length xs > 1 = if length ys == 0 then Just [] else Just $ travel codetree ys
  where
    codetree = head $ huffman $ sort $ treefy xs

travel :: Tree a -> [Bit] -> [a]
travel tree = dcd tree
  where
    dcd (Leaf c _)   []     = [c]
    dcd (Leaf c _)   bs     = c : dcd tree bs
    dcd (Node _ l r) (b:bs) = dcd (if b == Z then l else r) bs
    dcd (Node _ _ _) []     = []

treefy :: [(a, Int)] -> [Tree a]
treefy = map (\x -> Leaf (fst x) (snd x))

huffman :: [Tree a] -> [Tree a]
huffman [t] = [t]
huffman (min1:min2:rest)
  = huffman newList
  where
    newList
      | length rest /= 0 = sort ((merge min1 min2) : rest)
      | otherwise = [merge min1 min2]
      where
        merge a b
          | a <= b = Node (sumTree) a b
          | otherwise = Node (sumTree) b a
          where
            sumTree = (weight a) + (weight b)

codewords :: Tree a -> Code a
codewords = code' []
  where code' _    Empty        = []
        code' bits (Leaf x _)   = [(x,bits)]
        code' bits (Node _ l r) = map (second (Z:)) (code' bits l) ++
                                  map (second (O:)) (code' bits r)

main :: IO ()
main = do
  print $ sort $ treefy $ frequencies "aaaabcc"
  print $ codewords $ head $ huffman $ sort $ treefy $ frequencies "aaaabcc"
  print $ codewords $ head $ huffman $ sort $ treefy $ frequencies "aaaabcc"
  let a = "aaaabcc"
  print $ encode (frequencies a) a
  print $ head $ huffman $ sort $ treefy $ frequencies "aaaabcc"


  print $ (case encode (frequencies a) a of
             Just x -> x
             Nothing -> [])
  print $ decode (frequencies a) (case encode (frequencies a) a of
                                    Just x -> x
                                    Nothing -> [])
  print $ encode [] "abc"
  print $ encode [] ""
  print $ encode [('a',1)] "a"
  print $ encode [('a',1)] ""

