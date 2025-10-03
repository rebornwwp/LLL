import           Control.Monad.State
import           Data.Foldable       (traverse_)

example :: (Integer, [Integer])
example =
  runState
    (do x <- get
        put $ x ++ [2, 3]
        stack <- get
        put (1 : stack)
        return 0)
    [4, 4, 5]

push :: Integer -> State [Integer] Integer
push n = state $ \s -> (n, n : s)

pop :: State [Integer] Integer
pop = state $ \(x:xs) -> (x, xs)

top :: State [Integer] Integer
top = state $ \(x:xs) -> (x, x : xs)

plus :: State [Integer] Integer
plus = do
  x <- pop
  y <- pop
  push $ x + y

mult :: State [Integer] Integer
mult = do
  x <- pop
  y <- pop
  push $ x * y

prog = do
  push 2
  push 5
  push 8
  x <- pop
  y <- pop
  push $ x - y
  mult
  pop

write :: String -> State [String] ()
write str = do
  strs <- get
  put (strs ++ [str])

plus' :: Integer -> Integer -> State [String] Integer
plus' x y = return $ x + y

mult' :: Integer -> Integer -> State [String] Integer
mult' x y = return $ x * y

ex7 :: (Integer, [String])
ex7 =
  runState
    (do x <- plus' 10 20
        write $ "10 + 20 => " ++ show x
        y <- mult' x 2
        write $ show x ++ "*2 => " ++ show y
        return y)
    []

main :: IO ()
main = do
  print example
  print $ runState prog []
  print $ runState prog [2, 3, 4]
  print ex7

addItem :: Int -> State Int ()
addItem n = do
  s <- get
  put $ s + n

addItem' :: Integer -> State Integer ()
addItem' n = modify (+ n)
