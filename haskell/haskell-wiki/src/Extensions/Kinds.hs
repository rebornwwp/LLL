{-# LANGUAGE AllowAmbiguousTypes #-}
{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE KindSignatures      #-}
{-# LANGUAGE TypeOperators       #-}

module Extensions.Kinds where

{-
the syntax for creating kinds is the same as the syntax
for creating new haskell types

`DataKinds` extensions

如果DataKinds未开启，将会导致错误
Prelude> :k MakeExample

<interactive>:1:1: error:
    Not in scope: type constructor or class ‘MakeExample’
    A data constructor of that name is in scope; did you mean DataKinds?

如果使用DataKinds之后的效果
This works because the DataKinds extension allows us to promote data types to the type-level. When we do this, the data type becomes a Kind, and all of the constructors become types with that Kind.

Prelude> :kind! MakeExample
MakeExample :: Example
= 'MakeExample

MakeExample is a value with tye Type `Example`
'MakeExample is a type with the Kind `Example`
-}
data Example =
  MakeExample

data ExampleColor
  = Red
  | Green
  | Blue

class ExampleClass (color :: ExampleColor) where
  sayColor :: String

instance ExampleClass 'Red
 where
  sayColor = "red"

instance ExampleClass 'Green
 where
  sayColor = "green"

instance ExampleClass 'Blue
 where
  sayColor = "blue"


-- >> (sayColor @Red, sayColor @Green, sayColor @Blue)
{-
-- instance ExampleClass Int where
--   sayColor = "int"
• Expected kind ‘ExampleColor’, but ‘Int’ has kind ‘*’
• In the first argument of ‘ExampleClass’, namely ‘Int’
  In the instance declaration for ‘ExampleClass Int’typecheck
-}

-- Example: Type level List
data List a
  = Empty
  | Cons a (List a)

{-
> :kind! Cons Red (Cons Green (Cons Blue Empty))
Cons Red (Cons Green (Cons Blue Empty)) :: List ExampleColor
= 'Cons 'Red ('Cons 'Green ('Cons 'Blue 'Empty))
-}

-- define infix type level operators
type a :+: b = 'Cons a b

infixr 6 :+:
{-
> :kind! Red :+: Green :+: Blue :+: Empty
Red :+: Green :+: Blue :+: Empty :: List ExampleColor
= 'Cons 'Red ('Cons 'Green ('Cons 'Blue 'Empty))
-}
{-
GHC.TypeLits provided several Kinds

> import GHC.TypeLits

Type-Level Naturals
ghci> :kind! 1
1 :: Natural
= 1

Type-Level Symbol
ghci> :kind! "Hello, World"
"Hello, World" :: Symbol
= "Hello, World"

Type-Level Lists
ghci> :kind! [1,2,3]
[1,2,3] :: [Natural]
= '[1, 2, 3]
-}
