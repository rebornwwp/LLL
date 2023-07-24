module Main where

import           SQLParser          (ValueExpr (BinOp, Iden, NumLit, Parens, PrefOp),
                                     valueExpr0)
import qualified Test.HUnit         as H
import           Text.Parsec        (eof, parse, spaces)
import           Text.Parsec.String (Parser)

numLitTests :: [(String, ValueExpr)]
numLitTests = [("1", NumLit 1), ("54321", NumLit 54321)]

idenTests :: [(String, ValueExpr)]
idenTests = [("test", Iden "test"), ("_something3", Iden "_something3")]

operatorTests :: [(String, ValueExpr)]
operatorTests =
  map (\o -> (o ++ " a", PrefOp o (Iden "a"))) ["not", "+", "-"] ++
  map
    (\o -> ("a " ++ o ++ " b", BinOp (Iden "a") o (Iden "b")))
    [ "="
    , ">"
    , "<"
    , ">="
    , "<="
    , "!="
    , "<>"
    , "and"
    , "or"
    , "+"
    , "-"
    , "*"
    , "/"
    , "||"
    , "like"
    ]

parensTests :: [(String, ValueExpr)]
parensTests = [("(1)", Parens (NumLit 1))]

basicTests :: [(String, ValueExpr)]
basicTests = numLitTests ++ idenTests ++ operatorTests ++ parensTests

makeTest :: (Eq a, Show a) => Parser a -> (String, a) -> H.Test
makeTest parser (src, expected) =
  H.TestLabel src $
  H.TestCase $ do
    let gote = parse (spaces *> parser <* eof) "" src
    case gote of
      Left e    -> H.assertFailure $ show e
      Right got -> H.assertEqual src expected got

main :: IO ()
main = do
  putStrLn "Test suite not yet implemented"
  x <- H.runTestTT $ H.TestList $ map (makeTest valueExpr0) basicTests
  print x
