import Control.Monad.Trans.State

getNextNr :: Int -> (Int, String)
getNextNr i = (i + 1, show i)

initial :: Int
initial = 0

functions :: [Int -> (Int, String)]
functions = replicate 5 getNextNr

chain :: [Int -> (Int, String)] -> (Int -> (Int, [String]))
chain [] = error "No empty lists plz"
chain [f] = \i -> let (ni, v) = f i in (ni, [v])
chain (f : fs) = \i ->
  let (ni, v) = f i
      (fi, vs) = chain fs ni
   in (fi, v : vs)

getNextNrS :: State Int String
getNextNrS = do
  -- Get the current state (our counter)
  current <- get
  -- Update the state
  put (current + 1)
  -- Produce the resulting value
  return (show current)

jacobDubbel :: State Int (String, String)
jacobDubbel = fmap (\x -> (x, x)) getNextNrS

runState' :: State a b -> a -> (b, a)
runState' s = runState s

data ThreeStrings = ThreeStrings String String String deriving (Show)

tr :: State Int ThreeStrings
tr = ThreeStrings <$> getNextNrS <*> getNextNrS <*> getNextNrS

main1 :: IO ()
main1 =
  let initial :: Int
      initial = 0

      functions :: [State Int String]
      functions = replicate 5 getNextNrS

      chained :: State Int [String]
      chained = sequence functions

      numbers = execState chained initial
   in print numbers

main :: IO ()
main = do
  print $ execState jacobDubbel 10
  print $ evalState jacobDubbel 10
  print $ execState getNextNrS 11
  print $ evalState getNextNrS 11
  print $ evalState tr 1
  main1