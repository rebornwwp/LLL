module Basic.Tricks where

-- f1 与 f2 相同
f1 = \x -> ($ x)

f2 = \x -> \k -> k x

f = flip f1
