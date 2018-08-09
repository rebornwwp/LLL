module Codewars.Kata.AlternatingCase where

{-
altERnaTIng cAsE <=> ALTerNAtiNG CaSe

Define String.prototype.toAlternatingCase (or a similar function/method such as to_alternating_case/toAlternatingCase/ToAlternatingCase in your selected language; see the initial solution for details) such that each lowercase letter becomes uppercase and each uppercase letter becomes lowercase. For example:

toAlternatingCase "hello world" `shouldBe` "HELLO WORLD"
toAlternatingCase "HELLO WORLD" `shouldBe` "hello world"
toAlternatingCase "hello WORLD" `shouldBe` "HELLO world"
toAlternatingCase "HeLLo WoRLD" `shouldBe` "hEllO wOrld"
toAlternatingCase "12345"       `shouldBe` "12345"
toAlternatingCase "1a2b3c4d5e"  `shouldBe` "1A2B3C4D5E"
As usual, your function/method should be pure, i.e. it should not mutate the original string.
-}

import Data.Char (toLower, toUpper)

lowers = ['a'..'z']
uppers = ['A'..'Z']

toAlternatingCase :: String -> String
toAlternatingCase = map (\x -> if x `elem` lowers then toUpper x else if x `elem` uppers then toLower x else x)

