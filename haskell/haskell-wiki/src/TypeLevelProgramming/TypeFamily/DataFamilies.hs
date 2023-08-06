{-# LANGUAGE TypeFamilies #-}

module TypeLevelProgramming.TypeFamily.DataFamilies where


-- we define new data types for every instance. Data families are always open. There is no closed variant.
-- Data families provide a unified interface to different data representations.
data family XList a


-- or use newtype
-- 一种Type可以具有多种data constructor，一种类型参数对应一种data constructor的关系， 这里是
-- () -> XListUnit Integer
-- Bool -> XBits Integer Integer
-- 如果是regular haskell，一种数据类型只对用一种data constructor
-- 思考：data family， 表示不同的数据表示具有某一相同的数据性质
data instance  XList () = XListUnit Integer

data instance  XList Bool = XBits Integer Integer


-- XListUnit and XBits are data constructors that create values of XList () and XList Bool, respectively
class XListable a where
  xempty :: XList a
  xcons :: a -> XList a -> XList a
  xheadMay :: XList a -> Maybe a

instance XListable ()
 where
  xempty                 = XListUnit 0
  xcons () (XListUnit n) = XListUnit (n + 1)
  xheadMay (XListUnit 0) = Nothing
  xheadMay _             = Just ()

instance XListable Bool
 where
  xempty = XBits 0 0
  xcons b (XBits bits n) =
    XBits
      (bits * 2 +
       if b
         then 1
         else 0)
      (n + 1)
  xheadMay (XBits bits n)
    | n <= 0    = Nothing
    | otherwise = Just (odd bits)

testXList :: (Eq a, XListable a) => a -> Bool
testXList a = xheadMay (xcons a xempty) == Just a
-- >>> testXList ()
-- True
-- >>> testXList True
-- True
-- >>> testXList False
-- True
