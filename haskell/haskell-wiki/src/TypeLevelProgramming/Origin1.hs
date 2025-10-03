module TypeLevelProgramming.Origin1 where

{-
version 1, 只使用data直接创建数据类型来表示颜色
问题：导致无法在编译阶段发现颜色编码问题，可能有超过255的风险
Origin2.hs重构
-}
data PolybarColorScheme = PolybarColorScheme
  { focusedWorkspaceText       :: String
  , focusedWorkspaceBackground :: String
  , visibleWorkspaceText       :: String
  , visibleWorkspaceBackground :: String
  }

polybarColorScheme =
  PolybarColorScheme
    { focusedWorkspaceText = "#dda0dd"
    , focusedWorkspaceBackground = "#2a2035"
    , visibleWorkspaceText = "#dda0dd"
    , visibleWorkspaceBackground = "#2a2035"
    }
