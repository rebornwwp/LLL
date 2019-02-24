module main where

minfree :: [Nat] -> Nat
minfree l = head ([0..] // l)

(//) :: Eq a => [a] -> [a] -> [a]
xs // ys = filter (\x -> x notelem ys) xs
