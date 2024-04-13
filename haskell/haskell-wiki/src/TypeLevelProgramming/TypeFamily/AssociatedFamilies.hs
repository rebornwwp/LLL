{-# LANGUAGE TypeFamilies #-}

module TypeLevelProgramming.TypeFamily.AssociatedFamilies where

import           Data.Map (Map)
import qualified Data.Map as Map (fromList)

-- Associated families work well with type classes.
class Graph g -- 1. g is a type variable for a graph representation.
  where
  type Vertex g -- 2. Associated type family: the type of vertices depends on the type of the graph.
  data Edge g -- 3. Associated data family: the data type for edges will get data constructors in instances.
  src, tgt :: Edge g -> Vertex g -- 4. Source and target of the given edge: types depend on a graph representation.
  outEdges :: g -> Vertex g -> [Edge g] -- 5. List of outgoing edges
  -- other methods

neighbors :: Graph g => g -> Vertex g -> [Vertex g]
neighbors g v = map tgt (outEdges g v)

-- isLoop :: (Graph g, Eq (Vertex g)) => g -> Edge g -> Bool
-- isLoop g e = src e == tgt e
newtype EdgesList =
  EdgesList [Edge EdgesList]

-- 一种graph的interface
instance Graph EdgesList where
  type Vertex EdgesList = Int
  data Edge EdgesList = MkEdge1 (Vertex EdgesList) (Vertex EdgesList)
  src = undefined
  tgt = undefined
  outEdges = undefined

g1 :: EdgesList
g1 = EdgesList [MkEdge1 0 1, MkEdge1 1 0]

newtype VertexMap =
  VertexMap (Map (Vertex VertexMap) [Vertex VertexMap])

instance Graph VertexMap where
  type Vertex VertexMap = String
  data Edge VertexMap = MkEdge2 Int (Vertex VertexMap)
                              (Vertex VertexMap)
  src = undefined
  tgt = undefined
  outEdges = undefined

g2 :: VertexMap
g2 = VertexMap (Map.fromList [("A", ["B"]), ("B", ["A"])])
