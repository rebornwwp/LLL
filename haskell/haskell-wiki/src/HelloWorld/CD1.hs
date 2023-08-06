module HelloWorld.CD1 where

data Dyn
  = S String
  | C Char
  | B Bool


-- data DynValue a where
--   S :: String -> DynValue String
--   C :: Char -> DynValue Char
--   B :: Bool -> DynValue Bool
getValue :: Dyn -> a
getValue (B b) = b
getValue (C c) = c
getValue (S s) = s
