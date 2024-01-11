module TAPL.Syntax where

data Term
  = TmTrue
  | TmFalse
  | TmIf Term Term Term
  | TmZero
  | TmSucc Term
  | TmPred Term
  | TmIsZero Term
  deriving (Show)

isnumericval :: Term -> Bool
isnumericval t =
  case t of
    TmZero    -> True
    TmSucc t1 -> isnumericval t1
    _         -> False

isval :: Term -> Bool
isval t =
  isnumericval t ||
  case t of
    TmTrue  -> True
    TmFalse -> True
    _       -> False

eval1 :: Term -> Either String Term
eval1 t =
  case t of
    TmIf TmTrue t2 t3 -> return t2
    TmIf TmFalse t2 t3 -> return t3
    TmIf t1 t2 t3 ->
      case eval1 t1 of
        Right TmTrue  -> eval1 t2
        Right TmFalse -> eval1 t3
        _             -> Left "Type error"
    TmSucc t1
      | isnumericval t1 -> TmSucc <$> eval1 t1
      | otherwise -> Left "type error"
    TmPred t1 -> undefined
    _ -> Left "Error"
