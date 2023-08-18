{-# LANGUAGE TemplateHaskell #-}

module MetaProgramming.TemplatehaskellTest where


-- 是能在外部使用
import           MetaProgramming.TemplateHaskell

testmain :: IO ()
testmain = $hello
