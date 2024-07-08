module StateLearn where

import           Control.Monad.State

postincrement :: (MonadState b m, Num b) => m b
postincrement = do
  x <- get
  put (x + 1)
  return x

predecrement :: (MonadState b m, Num b) => m b
predecrement = do
  x <- get
  put (x - 1)
  get

-- example 1
type GameValue = Int
type GameState = (Bool, Int)

playGame :: String -> State GameState GameValue
playGame [] = do
  (_, score) <- get
  return score
playGame (x:xs) = do
  (on, score) <- get
  case x of
    'a' | on -> put (on, score + 1)
    'b' | on -> put (on, score - 1)
    'c'      -> put(not on, score)
    _        -> put(on, score)
  playGame xs

startState = (False, 0)

-- example 2
type MyState = Int

valFromState :: MyState -> Int
valFromState s = -s

nextState :: MyState -> MyState
nextState x = x + 1

type MyStateMonad = State MyState

getNext :: MyStateMonad Int
getNext = state (\st -> let st' = nextState st in (valFromState st', st'))

inc3 :: MyStateMonad Int
inc3 = getNext >>= \x -> getNext >>= \y -> getNext >>= \z -> return z

inc3Sugared :: MyStateMonad Int
inc3Sugared = do
  x <- getNext
  y <- getNext
  z <- getNext
  return z

inc3DiscardedValues :: MyStateMonad Int
inc3DiscardedValues = getNext >> getNext >> getNext

inc3DiscardedValuesSugared :: MyStateMonad Int
inc3DiscardedValuesSugared = do
  getNext
  getNext
  getNext

inc3AlternateResult :: MyStateMonad Int
inc3AlternateResult = do
  getNext
  getNext
  getNext
  s <- get
  return (s*s)

-- advance state 3 times, ignoring computed value, and then once more
inc4 :: MyStateMonad Int
inc4 = do
  inc3AlternateResult
  getNext

-- fact Stact
factState :: State Int Int
factState =
  get >>= \x ->
    if x <= 1
      then return 1
      else (put (x - 1) >> (* x) <$> factState)

factorial :: Int -> Int
factorial = evalState factState

-- State fibonacci
fibsState :: State (Int, Int, Int) Int
fibsState =
  get >>= \(x1, x2, n) ->
    if n == 0
      then return x1
      else (put (x2, x1 + x2, n - 1) >> fibsState)

fibonacci :: Int -> Int
fibonacci n = evalState fibsState (0, 1, n)

main :: IO ()
main = do
  print "learn State monad"
  -- return 'X' :: State Int Char
  -- runState (return 'X') :: Int -> (Char, Int)
  -- initial state = 1 :: Int 这个很重要
  -- final value = 'X' :: Char
  -- final state = 1 :: Int
  -- result = ('X', 1) :: (Char, Int)
  print $ runState (return 'x') 1
  -- setting and accessing the State
  print $ runState get 1
  print $ runState (put 5) 1
  -- getting value and state
  print $ evalState get 1
  print $ execState get 1
  -- combinations
  print $
    runState
      (do put 5
          return 'X')
      1
  print $ runState postincrement 1
  print $ runState predecrement 1
  -- other functions
  print $ runState (modify (+ 1)) 1
  print $ runState (gets (+ 1)) 1
  print $ evalState (gets (+ 1)) 1
  print $ execState (gets (+ 1)) 1
  -- game
  print $ runState (playGame "caaaaaaa") startState
  print (evalState inc3 0)                         -- -3
  print (evalState inc3Sugared 0)                  -- -3
  print (evalState inc3DiscardedValues 0)          -- -3
  print (evalState inc3DiscardedValuesSugared 0)   -- -3
  print (evalState inc3AlternateResult 0)          -- 9
  print (evalState inc4 0)                         -- -4
  print $ factorial <$> [1..10]
  print $ fibonacci <$> [1..10]

