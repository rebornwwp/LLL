data Move = Rock | Paper | Scissors
  deriving (Show, Eq)

type Tournament = ([Move], [Move])

outcome :: Move -> Move -> Integer
outcome Rock Scissors  = 1
outcome Paper Rock     = 1
outcome Scissors Paper = 1
outcome Rock Paper     = -1
outcome Paper Scissors = -1
outcome Scissors Rock  = -1
outcome _ _            = 0

tournamentOutcome :: Tournament -> Integer
tournamentOutcome (l1, l2) = sum $ zipWith outcome l1 l2

type Strategy = [Move] -> Move

-- 不变策略
rock, paper, scissors :: Strategy
rock _ = Rock
paper _ = Paper
scissors _ = Scissors

-- 循环选择
cycleStrategy :: Strategy
cycleStrategy moves =
  case (length moves) `rem` 3 of
    0 -> Rock
    1 -> Paper
    2 -> Scissors

-- 随机选择
randomStrategy :: Strategy
randomStrategy = undefined




tour = ([Rock, Rock, Paper], [Scissors, Paper, Rock])

tourResult = tournamentOutcome tour
