module Optparse.Demo where

import           Control.Monad
import           Options.Applicative

data Sample =
  Sample
    { hello      :: String
    , quiet      :: Bool
    , enthusiasm :: Int
    }

-- 不同类型的parser 可以通过定义的Builders来创建
sample :: Parser Sample
sample =
  Sample <$>
  strOption (long "hello" <> metavar "TARGET" <> help "Target for the greeting") <*> {-regular options-}
  switch (long "quiet" <> short 'q' <> help "Whether to be quiet") <*> {-flag options-}
  option
    auto
    (long "enthusiasm" <>
     help "How enthusiastically to greet" <>
     showDefault <> value 1 <> metavar "INT")

maintest :: IO ()
maintest = execParser opts >>= greet
  where
    opts =
      info
        (sample <**> helper) {-options-}
        (fullDesc <>
         progDesc "Print a greeting for TARGET" <>
         header "hello - a test for optparse-applicative" {-header信息等信息-}
         )

greet :: Sample -> IO ()
greet (Sample h False n) = putStrLn $ "Hello, " ++ h ++ replicate n '!'
greet _                  = return ()

-- 定义`--hello xxx`的option parser
-- 相关修饰，通过 modifiers <> 操作来实现对相关属性的叠加，完成更复杂的功能
target :: Parser String
target =
  strOption
    (long "name" <>
     short 'n' <> metavar "TARGET" <> help "Target for the greeting")

-- 4种 options方式
-- 1. regular options
-- --name james, --name=james -njames, -n james
name :: Parser String
name =
  strOption
    (long "name" <>
     short 'n' <> metavar "NAME" <> value "james" <> help "input name")
  -- option
  --   auto
  --   (long "name" <>
  --    short 'n' <> metavar "NAME" <> value "james" <> help "input name")

-- 2. flags
-- -q -v
data Verbosity
  = Normal
  | Verbose

flagV :: Parser Verbosity
flagV =
  flag
    Normal
    Verbose
    (long "verbose" <> short 'v' <> help "Enable verbose mode")

-- boolean flags use switch
-- flag' 函数代表没有默认值的情况，比如--stdin的参数肯定是没有默认值的
{-| 3. arguments -}
-- arguments = argument str (metavar "FILE")
{-| 4. commands
例子： docker images ls
-}
start :: String -> IO ()
start x = print $ "start: " ++ x

stop :: IO ()
stop = print "stop..."

opts :: Parser (IO ())
opts =
  subparser
    (command "start" (info (start <$> argument str idm) idm) <>
     command "stop" (info (pure stop) idm))

maincommands :: IO ()
maincommands = join $ execParser (info opts idm)

-- 包含两种类型的其中一个， A OR B， 下面的方式就不被允许`--file "foo.txt" --stdin`
data Input
  = FileInput FilePath
  | StdInput

fileInput :: Parser Input
fileInput =
  FileInput <$>
  strOption
    (long "file" <> short 'f' <> metavar "FILENAME" <> help "Input file")

stdInput :: Parser Input
stdInput = flag' StdInput (long "stdin" <> help "Read from stdin")

input :: Parser Input
input = fileInput <|> stdInput
