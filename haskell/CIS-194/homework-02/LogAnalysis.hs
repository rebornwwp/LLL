module LogAnalysis where

import Log

-- exercise 1
result :: String -> [String] -> LogMessage
result messageType lineWords
  | messageType == "I" =
    LogMessage
      Info
      (read (head lineWords) :: TimeStamp)
      (unwords $ drop 1 lineWords)
  | messageType == "W" =
    LogMessage
      Warning
      (read (head lineWords) :: TimeStamp)
      (unwords $ drop 1 lineWords)
  | messageType == "E" =
    LogMessage
      (Error (read (head lineWords) :: Int))
      (read (lineWords !! 1) :: TimeStamp)
      (unwords $ drop 2 lineWords)
  | otherwise = Unknown (messageType ++ " " ++ unwords lineWords)

parseMessage :: String -> LogMessage
parseMessage s = result messageType information
  where
    lineWords = words s
    messageType = head lineWords
    information = tail lineWords

parse :: String -> [LogMessage]
parse s = map parseMessage $ lines s

-- exercise 2
instance Ord LogMessage where
  (LogMessage _ ts1 _) `compare` (LogMessage _ ts2 _) = ts1 `compare` ts2
  _ `compare` _ = error "compare error"

newTree :: LogMessage -> MessageTree
newTree a = Node Leaf a Leaf

insert :: LogMessage -> MessageTree -> MessageTree
insert (Unknown x) tree = tree
insert x Leaf = newTree x
insert x (Node left a right) =
  case (x <= a, left, right) of
    (True, _, _)     -> Node (insert x left) a right
    (False, _, _)    -> Node left a (insert x right)

-- exercise 3
build :: [LogMessage] -> MessageTree
build [] = Leaf
build xs = foldr insert Leaf xs

-- exercise 4
inOrder :: MessageTree -> [LogMessage]
inOrder Leaf = []
inOrder (Node left a right) = inOrder left ++ [a] ++ inOrder right

-- exercise 5
whatWentWrong :: [LogMessage] -> [String]
whatWentWrong = map (\(LogMessage _ _ s) -> s) . inOrder . build . filter conds 
  where
    conds :: LogMessage -> Bool
    conds (LogMessage (Error x) _ _) = x>=50
    conds _ = False

main :: IO ()
main = do
  print $ parseMessage "E 2 562 help help"
  print $ parseMessage "I 29 la la la"
  print $ parseMessage "This is not in the right format"
  testParse parse 10 "error.log"
  testWhatWentWrong parse whatWentWrong "error.log"
  mapM_ print $ parse ("I 5053 pci_id: con ing!\n" ++ 
    "E 20 4681 ehci 0xf43d000:15: regista14: [0xbffff 0xfed nosabled 00-02] Zonseres: brips byted nored)\n" ++
    "W 3654 e8] PGTT ASF! 00f00000003.2: 0x000 - 0000: 00009dbfffec00000: Pround/f1743colled\n" ++
    "I 4076 verse.'\n" ++
    "I 4764 He trusts to you to set them free,\n" ++
    "I 858 your pocket?' he went on, turning to Alice.\n" ++
    "I 898 would be offended again.\n" ++
    "I 3753 pci 0x18fff steresocared, overne: 0000 (le wailan0: ressio0/derveld fory: alinpu-all)\n" ++
    "I 790 those long words, and, what's more, I don't believe you do either!' And\n" ++
    "I 3899 hastily.\n" ++
    "I 2194 little creature, and held out its arms and legs in all directions, 'just\n" ++
    "I 1447 she was terribly frightened all the time at the thought that it might be\n" ++
    "I 1147 began ordering people about like that!'\n" ++
    "I 3466 pci_hcd beed VRAM=2)\n")
  print "============================================================================================================"
  mapM_ print $ (inOrder . build) [LogMessage Info 5053 "pci_id: con ing!",
    LogMessage Info 4681 "ehci 0xf43d000:15: regista14: [0xbffff 0xfed nosabled 00-02] Zonseres: brips byted nored)",
    LogMessage Warning 3654 "e8] PGTT ASF! 00f00000003.2: 0x000 - 0000: 00009dbfffec00000: Pround/f1743colled",
    LogMessage Info 4076 "verse.'",
    LogMessage Info 4764 "He trusts to you to set them free,",
    LogMessage Info 858 "your pocket?' he went on, turning to Alice.",
    LogMessage Info 898 "would be offended again.",
    LogMessage Info 3753 "pci 0x18fff steresocared, overne: 0000 (le wailan0: ressio0/derveld fory: alinpu-all)",
    LogMessage Info 790 "those long words, and, what's more, I don't believe you do either!' And",
    LogMessage Info 3899 "hastily.",
    LogMessage Info 2194 "little creature, and held out its arms and legs in all directions, 'just",
    LogMessage Info 1447 "she was terribly frightened all the time at the thought that it might be",
    LogMessage Info 1147 "began ordering people about like that!'",
    LogMessage Info 3466 "pci_hcd beed VRAM=2)"]
  print "============================================================================================================"
  mapM_ print $ whatWentWrong [LogMessage (Error 1) 5053 "pci_id: con ing!",
    LogMessage (Error 10) 4681 "ehci 0xf43d000:15: regista14: [0xbffff 0xfed nosabled 00-02] Zonseres: brips byted nored)",
    LogMessage (Error 50) 3654 "e8] PGTT ASF! 00f00000003.2: 0x000 - 0000: 00009dbfffec00000: Pround/f1743colled",
    LogMessage (Error 60) 4076 "verse.'",
    LogMessage (Error 90) 4764 "He trusts to you to set them free,",
    LogMessage Info 858 "your pocket?' he went on, turning to Alice.",
    LogMessage Info 898 "would be offended again.",
    LogMessage Info 3753 "pci 0x18fff steresocared, overne: 0000 (le wailan0: ressio0/derveld fory: alinpu-all)",
    LogMessage Info 790 "those long words, and, what's more, I don't believe you do either!' And",
    LogMessage Info 3899 "hastily.",
    LogMessage Info 2194 "little creature, and held out its arms and legs in all directions, 'just",
    LogMessage Info 1447 "she was terribly frightened all the time at the thought that it might be",
    LogMessage Info 1147 "began ordering people about like that!'",
    LogMessage Info 3466 "pci_hcd beed VRAM=2)"]
  