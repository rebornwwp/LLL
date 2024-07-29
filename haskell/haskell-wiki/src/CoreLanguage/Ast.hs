{-# LANGUAGE OverloadedStrings #-}

module CoreLanguage.Ast where

type Name = String

type IsRec = Bool

recursive :: IsRec
recursive = True

nonRecursive :: IsRec
nonRecursive = False

type Alter a = (Int, [a], Expr a)

type CoreAlt = Alter Name

data Expr a
  = EVar Name -- Variables
  | ENum Int -- Numbers
  | EConstr Int Int -- Constru tor tag arity
  | EAp (Expr a) (Expr a) -- Appliations
  | ELet
      IsRec -- boolean with True = recursive,
      [(a, Expr a)] -- Definitions
      (Expr a) -- Body of let(rec)
  | ECase
      (Expr a) -- Expression to scrutinise
      [Alter a] -- Alternatives
  | ELam [a] (Expr a) -- Lambda abstrations
  deriving (Show)

type CoreExpr = Expr Name

-- variable name: 对应的right hand sides of
-- 只提取 variable name
bindersOf :: [(a, b)] -> [a]
bindersOf defns = [name | (name, rhs) <- defns]

-- 只提取 right-hand sides
rhssOf :: [(a, b)] -> [b]
rhssOf defns = [rhs | (name, rhs) <- defns]

isAtomicExpr :: Expr a -> Bool
isAtomicExpr (EVar _) = True
isAtomicExpr (ENum _) = True
isAtomicExpr _        = False

-- a Core-language program is just a list of supercombinator definitions:
-- program level 1
type CoreProgram = Program Name

-- program level 2
type Program a = [ScDefn a]

-- A supercombinator definition contains the name of the supercombinator,
-- its arguments and its body
type ScDefn a = (Name, [a], Expr a)

type CoreScDefn = ScDefn Name

-- 上面的表示可以将源代码转变成 CoreProgram的结构体：
-- main = double 21 ;
-- double x = x+x
-- [("main", [], (EAp (EVar "double") (ENum 21))),
-- ("double", ["x"], (EAp (EAp (EVar "+") (EVar "x")) (EVar "x")))
-- ]
{-|
一些预定义函数
I x = x ;
K x y = x ;
K1 x y = y ;
S f g x = f x (g x) ;
ompose f g x = f (g x) ;
twice f = compose f f;
-}
preludeDefs :: CoreProgram
preludeDefs =
  [ ("I", ["x"], EVar "x")
  , ("K", ["x", "y"], EVar "x")
  , ("K1", ["x", "y"], EVar "y")
  , ( "S"
    , ["f", "g", "x"]
    , EAp (EAp (EVar "f") (EVar "x")) (EAp (EVar "g") (EVar "x")))
  , ("compose", ["f", "g", "x"], EAp (EVar "f") (EAp (EVar "g") (EVar "x")))
  , ("twice", ["f"], EAp (EAp (EVar "compose") (EVar "f")) (EVar "f"))
  ]

pprint :: CoreProgram -> String
pprint = undefined

pprExpr :: CoreExpr -> String
pprExpr (ENum n)    = show n
pprExpr (EVar v)    = v
pprExpr (EAp e1 e2) = pprExpr e1 ++ " " ++ pprAExpr e2

pprAExpr :: CoreExpr -> String
pprAExpr e =
  if isAtomicExpr e
    then pprExpr e
    else "(" ++ pprExpr e ++ ")"

mkMultiAp :: Int -> CoreExpr -> CoreExpr -> CoreExpr
mkMultiAp n e1 e2 = foldl EAp e1 (take n e2s)
  where
    e2s = e2 : e2s

data Iseq
  = INil
  | IStr String
  | IAppend Iseq Iseq
  | IIndent Iseq
  | INewline

iNil :: Iseq -- The empty iseq
iNil = INil

iStr :: String -> Iseq -- Turn a string into an iseq
iStr str = IStr str

iAppend :: Iseq -> Iseq -> Iseq -- Append two iseqs
iAppend seq1 seq2 = IAppend seq1 seq2

iNewline :: Iseq -- New line with indentation
iNewline = IStr "\n"

iIndent :: Iseq -> Iseq -- Indent an iseq
iIndent seq = seq

iDisplay :: Iseq -> String -- Turn an iseq into a string
flatten :: [Iseq] -> String
flatten []                       = ""
flatten (INil:seqs)              = flatten seqs
flatten (IStr s:seqs)            = s ++ (flatten seqs)
flatten (IAppend seq1 seq2:seqs) = flatten (seq1 : seq2 : seqs)

iDisplay seq = flatten [seq]

iConcat :: [Iseq] -> Iseq
iInterleave :: Iseq -> [Iseq] -> Iseq
pprExpr' :: CoreExpr -> Iseq
pprExpr' (EVar v) = iStr v
pprExpr' (EAp e1 e2) =
  (pprExpr' e1) `iAppend` (iStr " ") `iAppend` (pprAExpr' e2)
pprExpr' (ELet isrec defns expr) =
  iConcat
    [ iStr keyword
    , iNewline
    , iStr " "
    , iIndent (pprDefns defns)
    , iNewline
    , iStr "in "
    , pprExpr expr
    ]
  where
    keyword =
      if not isrec
        then "let"
        else "letrec"

pprDefns :: [(Name, CoreExpr)] -> Iseq
pprDefns defns = iInterleave sep (map pprDefn defns)
  where
    sep = iConcat [iStr ";", iNewline]

pprDefn :: (Name, CoreExpr) -> Iseq
pprDefn (name, expr) = iConcat [iStr name, iStr " = ", iIndent (pprExpr expr)]
