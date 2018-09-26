{-# OPTIONS_GHC -fdefer-type-errors #-} -- Enable deferred type
                                        -- errors at module level

x :: IO ()
x = print 3

y :: Char
y = '0'

z :: Int
z = 0 + 12

main :: IO ()
main = do
    x
