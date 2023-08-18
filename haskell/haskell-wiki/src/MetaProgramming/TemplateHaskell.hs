{-# LANGUAGE TemplateHaskell #-}

module MetaProgramming.TemplateHaskell
  ( hello
  ) where


-- When GHC compiles our code, it starts with parsing. As a result of parsing, it creates an
-- abstract syntax tree (AST). Template Haskell (TH) allows us to explore this tree and
-- generate new nodes.
------------------------------------------------
-- THE RISKS OF USING TEMPLATE HASKELL Template
-- Haskell is intimately tied to
-- the GHC internals. It was never standardized. There are always risks of breaking
-- code under GHC updates. As a rule, it’s better to avoid using Template
-- Haskell in production code.
------------------------------------------------
-- The [| … |] brackets are called Oxford brackets.
import Language.Haskell.TH

hello :: Q Exp
hello = [|putStrLn "Hello world"|]
