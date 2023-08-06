{-# LANGUAGE ConstraintKinds      #-}
{-# LANGUAGE FlexibleContexts     #-}
{-# LANGUAGE FlexibleInstances    #-}
{-# LANGUAGE PolyKinds            #-}
{-# LANGUAGE TypeFamilies         #-}
{-# LANGUAGE UndecidableInstances #-}

module TypeLevelProgramming.TypeFamily.OpenAndCloseTypeSynonymFamilies where

import           GHC.Show      (showLitChar)
import           Unsafe.Coerce (unsafeCoerce)


-- Type synonym families
--   open (when it is allowed to add new instances everywhere, even in other modules)
--   closed (when there is a closed list of instances)

-- For example, we are porting an application to some other programming language with minimal types, say, Integer and String.
-- 比如这里需要移植一些数据类型到其他的编程语言中, 比如这里对Haskell的类型做简单化处理
-- declares the open type family
-- 此方式没有兜底方式，只能在已经定义好的类型转换中转换，不被支持的类型会编译错误
type family Simplify t


-- defining equations
-- 建立type level 定义映射关系
type instance Simplify Integer = Integer

type instance Simplify Int = Integer

type instance Simplify Double = Integer

type instance Simplify String = String

type instance Simplify Char = String

type instance Simplify Bool = String


-- :kind Simplify
-- :kind Simplify Bool
-- :kind! Simplify Bool

-- term-level 来处理数据转换
class Simplifier t where
  simplify :: t -> Simplify t


-- 实现转换的classtype
instance Simplifier Integer

 where
  simplify = id

instance Simplifier Int
 where
  simplify = fromIntegral

instance Simplifier Double
 where
  simplify = round

instance Simplifier String where
  simplify = id

instance Simplifier Bool
 where
  simplify = show

instance Simplifier Char
 where
  simplify = (: "")


-- declares the closed type family
-- 优点: 可以有一个 catchall instance，作为兜底
-- it’s okay to have the last instance correspond to all the other types.
-- Closed type synonym families give more information to the compiler, so it is more flexible to work with them.
type family Widen a
 where
  Widen Bool = Int
  Widen Int  = Integer
  Widen Char = String
  Widen t = String -- a catchall instance 匹配其他所有类型

class Widener a where
  widen :: a -> Widen a

instance Widener Bool
 where
  widen True  = 1
  widen False = 0

instance Widener Int
 where
  widen = fromIntegral

instance Widener Char
 where
  widen c = [c]

instance Widener Double
 where
  widen = show


-- ghci 中可以使用-interactive-print 来修改默认的print函数, 所以在使用中文时候会使用编码的方式展示
-- 这是 实现一个print的替代函数，透明的在ghci中使用
newtype UnescapingChar =
  UnescapingChar
    { unescapingChar :: Char
    }

instance Show UnescapingChar
 where
  showsPrec _ (UnescapingChar '\'') = showString "'\\''"
  showsPrec _ (UnescapingChar c) =
    showChar '\'' . showLitChar' c . showChar '\''
  showList cs =
    showChar '"' . showLitString' (map unescapingChar cs) . showChar '"'

showLitChar' :: Char -> ShowS
showLitChar' c s
  | c > '\DEL' = showChar c s
showLitChar' c s = showLitChar c s

showLitString' :: String -> ShowS
showLitString' [] s       = s
showLitString' ('"':cs) s = showString "\\\"" (showLitString' cs s)
showLitString' (c:cs) s   = showLitChar' c (showLitString' cs s)

type family ToUnescapingTF (a :: k) :: k
 where
  ToUnescapingTF Char       = UnescapingChar
  ToUnescapingTF (t b :: k) = (ToUnescapingTF t) (ToUnescapingTF b)
  ToUnescapingTF a          = a

class ToUnescaping a where
  toUnescaping :: a -> ToUnescapingTF a

instance Show a => ToUnescaping a
 where
  toUnescaping = unsafeCoerce

type UnescapingShow t = (ToUnescaping t, Show (ToUnescapingTF t))

ushow :: UnescapingShow t => t -> String
ushow = show . toUnescaping

uprint :: UnescapingShow t => t -> IO ()
uprint = putStrLn . ushow
