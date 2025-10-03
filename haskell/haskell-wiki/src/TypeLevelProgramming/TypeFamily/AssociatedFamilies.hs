{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies          #-}

module TypeLevelProgramming.TypeFamily.AssociatedFamilies where


-- 定义一个 Convert 类型类，具有关联类型 Target
class Convert a where
  type Target a
  convert :: a -> Target a


-- 为不同类型定义实例，不同的 Target 类型
instance Convert Int
 where
  type Target Int = String
  convert x       = show x

instance Convert Bool
 where
  type Target Bool = Int
  convert True     = 1
  convert False    = 0


-- 定义一个 Container 类型类
class Container c where
    -- 关联类型，表示容器中存储的元素类型
  type Item c
  insert :: Item c -> c -> c
                                -- 向容器中插入元素
  getItems :: c -> [Item c] -- 获取容器中的所有元素


-- 实现一个具体的容器：ListContainer
data ListContainer =
  ListContainer [Int] -- 这个容器存储 Int 类型的元素

instance Container ListContainer where
  type Item ListContainer = Int -- 关联类型的具体实现
  insert x (ListContainer xs) = ListContainer (x : xs) -- 插入元素
  getItems (ListContainer xs) = xs -- 获取所有元素


-- 测试代码
main :: IO ()
main = do
  let container = ListContainer [] -- 创建一个空的 ListContainer
  let updatedContainer = insert 10 container -- 向容器中插入元素
  let items = getItems updatedContainer -- 获取容器中的所有元素
  print items -- 输出: [10]
