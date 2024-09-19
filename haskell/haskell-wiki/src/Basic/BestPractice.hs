{-# LANGUAGE LambdaCase #-}

module Basic.BestPractice where

import           Control.Monad
import           System.Directory
import           System.FilePath


-- 这里是递归
findFilesRecursive :: FilePath -> IO [FilePath]
findFilesRecursive = listDirectoryFiles findFilesRecursive


-- 这里只是list一个dirctory的所有文件， go 就是上面的递归
listDirectoryFiles :: (FilePath -> IO [FilePath]) -> FilePath -> IO [FilePath]
listDirectoryFiles go topdir = do
  ps <-
    listDirectory topdir >>=
    mapM
      (\x -> do
         let dir = topdir </> x
         doesDirectoryExist dir >>= \case
           True -> go dir
           False -> return [dir])
  return $ concat ps
