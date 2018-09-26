data Tree a = Empty | Node a (Tree a) (Tree a) deriving Show

height :: Tree a -> Integer
height Empty = 0
height (Node _ l r) = 1 + max (height l) (height r)

main :: IO ()
main = do
  let tree = Node "x" Empty (Node "y" Empty Empty)
  print $ height tree
