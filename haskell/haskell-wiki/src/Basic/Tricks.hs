module Basic.Tricks where


-- f1 与 f2 相同
f1 = \x -> ($ x)

f2 = \x -> \k -> k x

f = flip f1


-- pattern guards haskell 2010才有的， haskell 98只支持 boolean 的形式
-- https://gitlab.haskell.org/haskell/prime/-/wikis/PatternGuards
-- https://web.archive.org/web/20170109011924/http://research.microsoft.com/en-us/um/people/simonpj/Haskell/guards.html
parseExtension :: String -> IO ()
parseExtension str
  | 'N':'o':str' <- str = print $ "xx" ++ str' ++ " " ++ str'
  | str `elem` ignores  = print $ "ignoe" ++ str
  | Just x <- Just str  = print $ "Just" ++ x
  | otherwise           = print $ "otherwise" ++ str
  where
    ignores = ["unsafe", "trustworthy", "safe"]
