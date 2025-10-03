module TreeByLevels where

{-
You are given a binary tree (not sorted, it doesn't matter in this kata. For ruby, it's represented by class TreeNode, defined like this:

class TreeNode
  attr_accessor :left
  attr_accessor :right
  attr_reader :value
end
For Haskell, it's represented by TreeNode type, which is defined like this:

data TreeNode a = TreeNode {
  left  :: Maybe (TreeNode a),
  right :: Maybe (TreeNode a),
  value :: a
  } deriving Show
Your task is to return the list with elements from tree sorted by levels, which means the root element goes first, then root children (from left to right) are second and third, and so on. Return empty list for empty tree (Nothing in case of Haskell and nil argument in case of ruby).

Example 1 - following tree:

                 2
            8        9
          1  3     4   5
Should return following list:

[2,8,9,1,3,4,5]
Example 2 - following tree:

                 1
            8        4
              3        5
                         7
Should return following list:

[1,8,4,3,5,7]
-}

import           Data.Maybe (catMaybes)

data TreeNode a = TreeNode
  { left  :: Maybe (TreeNode a)
  , right :: Maybe (TreeNode a)
  , value :: a
  } deriving (Show)

treeByLevels :: Maybe (TreeNode a) -> [a]
treeByLevels xs =
  case xs of
    Just ns -> oneLevel [ns]
    Nothing -> []
  where
    oneLevel :: [TreeNode a] -> [a]
    oneLevel [] = []
    oneLevel ts = map value ts ++ oneLevel nextLevel
      where
        nextLevel = catMaybes $ concatMap (\x -> [left x, right x]) ts

-- 只是形象的提供了what
-- f x = g (x) ++ f (z (x))

treeByLevels' :: Maybe (TreeNode a) -> [a]
treeByLevels' Nothing = []
treeByLevels' tree = tbf [tree]
    where
        tbf [] = []
        tbf xs = map nodeValue xs ++ tbf (concatMap leftAndRightNodes xs)
        nodeValue (Just (TreeNode _ _ a)) = a
        leftAndRightNode Nothing                              = []
        leftAndRightNodes (Just (TreeNode Nothing Nothing _)) = []
        leftAndRightNodes (Just (TreeNode Nothing b _))       = [b]
        leftAndRightNodes (Just (TreeNode a Nothing _))       = [a]
        leftAndRightNodes (Just (TreeNode a b _))             = [a,b]

main = do
  let tree =
        TreeNode
          (Just (TreeNode Nothing (Just (TreeNode Nothing Nothing 3)) 8))
          (Just
             (TreeNode
                Nothing
                (Just (TreeNode Nothing (Just (TreeNode Nothing Nothing 7)) 5))
                4))
          1
  print $ treeByLevels (Just tree)
