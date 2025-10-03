{-# OPTIONS_GHC -fno-warn-orphans #-}
module Party where

import Data.Monoid
import Data.Tree

import Employee

-- exercise 1
glCons :: Employee -> GuestList -> GuestList
glCons emp@(Emp {empFun = ef}) (GL lst gf) = GL (emp:lst) (ef+gf)

instance Monoid GuestList where
  mempty = GL [] 0
  mappend (GL emps1 fun1) (GL emps2 fun2) = GL (emps1 ++ emps2) (fun1 + fun2)

moreFun :: GuestList -> GuestList -> GuestList
moreFun gl1 gl2 = if gl1 > gl2 then gl1 else gl2

-- exercise 2
treeFold :: (a -> [b] -> b) -> b -> Tree a -> b
treeFold f init (Node {rootLabel = rl, subForest = sf}) = f rl (map (treeFold f init) sf)

combineGLs :: Employee -> [GuestList] -> GuestList
combineGLs = undefined


-- exercise 3
nextLevel :: Employee -> [(GuestList, GuestList)] -> (GuestList, GuestList)
nextLevel boss bestLists = (maximumS withBossL, maximumS withoutBossL)
  where
    withoutBossL = map fst bestLists
    withoutSubBoss = map snd bestLists
    withBossL = map (glCons boss) withoutSubBoss

maximumS :: (Monoid a, Ord a) => [a] -> a
maximumS [] = mempty
maximumS lst = maximum lst

-- exercise 4
maxFun :: Tree Employee -> GuestList
maxFun tree = uncurry max res
  where
    res = treeFold nextLevel (mempty, mempty) tree

-- exercise 5
computeOutput :: String -> String
computeOutput = formatGL . maxFun . read

formatGL :: GuestList -> String
formatGL (GL lst fun) = "Total fun: " ++ show fun ++ "\n" ++ unlines employees
  where
    employees = map (\(Emp {empName = name}) -> name) lst

main :: IO ()
main = readFile "company.txt" >>= putStrLn . computeOutput
