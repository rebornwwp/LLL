# haskell-wiki

## resource

[user_guide](https://ghc.gitlab.haskell.org/ghc/doc/users_guide/index.html)
[WHAT I WISH I KNEW WHEN LEARNING HASKELL](https://smunix.github.io/dev.stephendiehl.com/hask/index.html)
[typeclasses sitemap](https://typeclasses.com/sitemap)
[Extensions](https://typeclasses.com/ghc/extensions)
[haskell by example like golang by example](https://lotz84.github.io/haskellbyexample/)
[haskell](https://lotz84.github.io/haskell/)
[WilliamYao blog](https://williamyaoh.com/)
[FPComplete promote](https://www.fpcomplete.com/haskell/promote/)
[FPComplte learning material](https://www.fpcomplete.com/haskell/learn/)

### Monad

[Monad Laws](http://wiki.haskell.org/Monad_laws)

### Applicative

[basic](https://www.fpcomplete.com/haskell/tutorial/applicative-syntax/)

### Monad Transformer

1. https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.71.596&rep=rep1&type=pdf


TODO:

1. IOREF
2. typeFamily
2. free-applicative free-monad or free-functor???

## roadmap

Learn to read function definition syntax, sans any extensions

Learn to write and use basic ADTs to represent simple structures

Encode your own Maybe, Either, linked list, binary tree, and rose tree types and some simple functions that operate on those types.

Learn how record type syntax works

Learn how to use type synonyms, and what they do and do not provide for you.

Learn about deriving clauses - Not like, how they work, just when to use them.

Learn to read a function type signature

Learn to write recursive functions instead of loops

Learn how to use higher order functions on list to do most of what you can do in step #4

Learn why step 4 is better sometimes and when it makes sense to use either technique

Learn do notation and do some stuff in IO to make actual programs

Learn how to desugar do notation into a sequence of calls to (>>=)

Learn the monad laws. Don't go too deep here, just know what they are.

Learn Functor and Applicative

Learn how to use fmap, pure, and <*> to avoid defining too much stuff using do notation

Understand that steps 6 and 7 are all anyone actually means when they talk about learning to use monads

Understand, again, that all a monad is is something that implements (>>=) and return, and follows the laws.

Learn the laws again, and try to understand why breaking the laws would be really bad.

Use a bunch of stuff that has a monad instance in IO and get irritated about it. 1.You're not actually learning any skills in this step but it's still really valuable.

Learn about typeclasses

The syntax for declaring classes and instances

How to use 'minimal'

Study the implementations for Functor, applicative, and monad instances in base for the Either and Maybe types

Write your own monad instance for a type that combines the effects of State and Either

Learn about newtypes

Learn about the 'safe constructor' paradigm

Understand what a 'partial function' is

Learn about module imports/exports

Learn either stack or cabal

Make a project, install some dependencies

Install some global haskell tools or packages on your system

Learn how to use monad transformers so that you never have to roll your own ever again

Learn to use lens to access and manipulate record types inside a collection

Learn when and why to use bytestring, string, and text

Write a parser using Parsec, Megaparsec, or Attoparsec

Write a simple web server, CLI, or GUI app using the skills above.

You're now an intermediate Haskeller.

There is no set path to guru, but there should now be nothing in between you and learning to write an arbitrarily complex and idiomatic Haskell program.

There is a lot of stuff to learn past this point - a whole world. But it gets extremely non-linear past this point, with a lot of topics of varying complexity and utility, and it starts getting a lot less universally applicable.

## 一些总结

[文档](https://github.com/Dobiasd/articles/blob/master/from_oop_to_fp_-_inheritance_and_the_expression_problem.md) 
此文档中给出了一种类似面向对象，多个继承类基于一个基类，可以存储在同一个list中，函数式编程中如何将多个不同类型集成到同一类型并放到同一个同构的list中

[best practice](https://github.com/freckle/guides/blob/main/haskell-best-practices.md)

### how to export functions and types

https://sakshamsharma.com/2018/03/haskell-proj-struct/

``` haskell
module MyExports ( SomeTypeWithoutItsFxns -- 此方式的时候只有type被export, data constructor不会被export
                 , SomeOtherType(..) -- 所有都会被export
                 , something
                 , module MyMinorExports -- MyMinorExports中export的，也会在这里被export
                 , MyMajorExports.SomeType(..) -- 如果SomeType 和相关field function被export，这里也会export
                 , MyMinorExports.fxnToHandleType
                 ) where

import MyMinorExports
import MyMajorExports

data SomeTypeWithoutItsFxns = SomeTypeWithoutItsFxns { unexportedMember1 :: Int
                                                     , unexportedMember2 :: Bool
                                                     }

data SomeOtherType = SomeOtherType { member1 :: Int
                                   , member2 :: Bool
                                   }

something :: Int -> Bool -> SomeTypeWithoutItsFxns
something i b = SomeTypeWithoutItsFxns { unexportedMember1 = i
                                       , unexportedMember2 = b
                                       }
```
