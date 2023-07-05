{-# LANGUAGE OverloadedStrings  #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# OPTIONS_GHC -Wno-orphans #-}

module EnumEqMain where

import           EnumEq             (Direction (East, North, South, West),
                                     Turn (TAround, TLeft, TNone, TRight),
                                     orientMany, rotateMany, rotateManySteps)

import           System.Environment (getArgs)

import           Fmt                (Buildable (..), fmt, fmtLn, nameF,
                                     unwordsF, (+||), (||+))


-- used for IO and read
deriving instance Read Direction

deriving instance Read Turn

instance Buildable Direction
 where
  build North = "N"
  build East  = "E"
  build South = "S"
  build West  = "W"

instance Buildable Turn
 where
  build TNone   = "--"
  build TLeft   = "<-"
  build TRight  = "->"
  build TAround = "||"

rotateFromFile :: Direction -> FilePath -> IO ()
rotateFromFile dir fname = do
  f <- readFile fname
  let turns = map read $ lines f
      finalDir = rotateMany dir turns
      dirs = rotateManySteps dir turns
  fmtLn $ "Final direction: " +|| finalDir ||+ ""
  fmt $ nameF "Intermediate directions" (unwordsF dirs)

orientFromFile :: FilePath -> IO ()
orientFromFile fname = do
  f <- readFile fname
  let dirs = map read $ lines f
  fmt $ nameF "All turns" (unwordsF $ orientMany dirs)

mainEnumEq :: IO ()
mainEnumEq
--   args <- getArgs
 = do
  let args = ["-r", "/home/user/workspace/hid-examples/data/turns.txt", "North"]
  case args of
    ["-r", fname, dir] -> rotateFromFile (read dir) fname
    ["-o", fname] -> orientFromFile fname
    _ -> putStrLn "Usage: locator -o filename\nlocator -r filename direction"
