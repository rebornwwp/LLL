{-# LANGUAGE DataKinds                 #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE KindSignatures            #-}

module TypeLevelProgramming.Origin3 where

{- | https://rebeccaskinner.net/posts/2021-08-25-introduction-to-type-level-programming.html
-}
import qualified Data.Map.Strict as Map
import           Data.Word
import           GHC.Base        (Symbol)
import           Text.Printf     (printf)

data RGB =
  RGB
    { rgbRed   :: Word8
    , rgbGreen :: Word8
    , rgbBlue  :: Word8
    }
  deriving (Show, Eq)

data PolybarColorScheme =
  PolybarColorScheme
    { focusedWorkspaceText       :: RGB
    , focusedWorkspaceBackground :: RGB
    , visibleWorkspaceText       :: RGB
    , visibleWorkspaceBackground :: RGB
    }

polybarColorScheme :: PolybarColorScheme
polybarColorScheme =
  PolybarColorScheme
    { focusedWorkspaceText = RGB 0xdd 0xa0 0xdd
    , focusedWorkspaceBackground = RGB 0x2a 0x20 0x35
    , visibleWorkspaceText = RGB 0xdd 0xa0 0xdd
    , visibleWorkspaceBackground = RGB 0x2a 0x20 0x35
    }

-- newtype ThemeInstance =
--   ThemeInstance
--     { getThemeInstance :: Map.Map String RGB
--     }
-- myTheme =
--   ThemeInstance . Map.fromList $
--   [("foreground", RGB 0x3a 0x20 0x35), ("background", RGB 0xdd 0xa0 0xdd)]
-- polybarColorScheme' :: ThemeInstance -> Maybe PolybarColorScheme
-- polybarColorScheme' (ThemeInstance theme) =
--   PolybarColorScheme <$> Map.lookup "foreground" theme <*>
--   Map.lookup "background" theme <*>
--   Map.lookup "foreground" theme <*>
--   Map.lookup "background" theme
-- 上面已经支持了RGB的颜色，但也有时候需要其他数据类型来表示的RGB, 所以引入IsColor 的typeclass
class IsColor a where
  toRGB :: a -> RGB

instance IsColor RGB where
  toRGB = id

-- 通过名字来表示颜色
data AliceBlue =
  AliceBlue

instance IsColor AliceBlue where
  toRGB = const $ RGB 0xF0 0xF8 0xFF

-- 函数可以传入 RGB与 AliceBlue两种类型, 具有IsColor的类型
toHex :: IsColor a => a -> String
toHex a =
  let (RGB r g b) = toRGB a
   in printf "%02x%02x%02x" r g b

-- 此方式不具有IsColor的特性
-- newtype ThemeInstance' colorType =
--   ThemeInstance'
--     { getThemeInstance' :: Map.Map String colorType
--     }
-- 问题1: 如果我们使用这样的方式，那么所有相关的函数，以及数据构造都会加入 IsColor colorType => ThemeInstance colorType的限制
-- 问题2: 此方式colorType具体只能是一种具体的数据类型，不能是两种数据类型的混合Map
-- solve: Existential Type
-- newtype ThemeInstance' colorType =
--   ThemeInstance'
--     { getThemeInstance' :: IsColor colorType =>
--                              Map.Map String colorType
--     }
-- An Existential Type is a type that we can create to hold values of several different types that all implement a particular typeclass.
data SomeColor =
  forall color. IsColor color =>
                SomeColor color

instance Show SomeColor where
  show = show . toRGB

instance IsColor SomeColor where
  toRGB (SomeColor color) = toRGB color

-- add Phantom Type
-- we have a ThemeInstance value and have defined the Theme kind,
newtype ThemeInstance (theme :: Theme) =
  ThemeInstance
    { getThemeInstance :: Map.Map String SomeColor
    }
  deriving (Show)

type Theme = [Symbol]

t :: ThemeInstance theme
t =
  ThemeInstance $
  Map.insert
    "red"
    (SomeColor $ RGB 255 0 0)
    (Map.singleton "blue" (SomeColor AliceBlue))

someRGB :: Word8 -> Word8 -> Word8 -> SomeColor
someRGB r g b = SomeColor $ RGB r g b
-- t' = ThemeInstance  $ Map.singleton "red" (someRGB 255 0 0)
