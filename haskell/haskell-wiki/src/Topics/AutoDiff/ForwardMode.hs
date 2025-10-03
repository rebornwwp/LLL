{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE RankNTypes   #-}

module Topics.AutoDiff.ForwardMode where

data Value a = Value
  { value :: a -- ^ value
  , grad  :: a -- ^ diff
  } deriving (Show)

instance (Num a) => Num (Value a)
 where
  (Value x x') + (Value y y') = Value (x + y) (x' + y')
  (Value x x') - (Value y y') = Value (x - y) (x' - y')
  (Value x x') * (Value y y') = Value (x * y) (x' * y + x * y')
  negate (Value x x')         = Value (negate x) (negate x')
  abs :: Num a => Value a -> Value a
  abs (Value x x')            = Value (abs x) (signum x * x')
  signum (Value x x')         = Value (signum x) 0
  fromInteger n               = Value (fromInteger n) 0

instance Fractional a => Fractional (Value a)
 where
  (Value x x') / (Value y y') = Value (x / y) ((x' * y - x * y') / (y * y))
  recip (Value x x')          = Value (recip x) (-x' / (x * x))
  fromRational x              = Value (fromRational x) 0


-- Floating 类型类实例：实现对数、指数、三角函数等
instance Floating a => Floating (Value a)
 where
  pi                 = Value pi 0
  exp (Value x x')   = Value (exp x) (exp x * x')
  log (Value x x')   = Value (log x) (x' / x)
  sin (Value x x')   = Value (sin x) (cos x * x')
  cos (Value x x')   = Value (cos x) (-sin x * x')
  tan (Value x x')   = Value (tan x) (x' / cos x ^ 2)
  asin (Value x x')  = Value (asin x) (x' / sqrt (1 - x ^ 2))
  acos (Value x x')  = Value (acos x) (-x' / sqrt (1 - x ^ 2))
  atan (Value x x')  = Value (atan x) (x' / (1 + x ^ 2))
  sinh (Value x x')  = Value (sinh x) (cosh x * x')
  cosh (Value x x')  = Value (cosh x) (sinh x * x')
  asinh (Value x x') = Value (asinh x) (x' / sqrt (x ^ 2 + 1))
  acosh (Value x x') = Value (acosh x) (x' / sqrt (x ^ 2 - 1))
  atanh (Value x x') = Value (atanh x) (x' / (1 - x ^ 2))

forwardDiff :: (Fractional a) => (Value a -> Value a) -> a -> Value a
forwardDiff f x = f (Value x 1)

maintest = do
  let v = forwardDiff (\x -> x ** 2 + x + 1 / x + 1) 2
  putStrLn $ "x = 2, f(x) = " ++ show (value v)
  putStrLn $ "x = , f'(x) = " ++ show (grad v)

-- | 一个 clever 的实现
data Expr
  = Var
  | Add Expr Expr
  | Mul Expr Expr
  | Neg Expr
  | Abs Expr
  | Signum Expr
  | FromInteger Integer
  deriving (Eq, Show)

instance Num Expr
 where
  (+)         = Add
  negate      = Neg
  (*)         = Mul
  abs         = Abs
  signum      = Signum
  fromInteger = FromInteger

eval :: Num b => Expr -> b -> b
eval Var b             = b
eval (Add e1 e2) b     = eval e1 b + eval e2 b
eval (Mul e1 e2) b     = eval e1 b * eval e2 b
eval (Neg e) b         = -eval e b
eval (Abs e) b         = abs (eval e b)
eval (Signum e) b      = signum (eval e b)
eval (FromInteger n) b = fromInteger n

derivative :: Expr -> Expr
derivative Var             = 1
derivative (Add e1 e2)     = derivative e1 + derivative e2
derivative (Mul e1 e2)     = derivative e1 * e2 + e1 * derivative e2
derivative (Neg e)         = -derivative e
derivative (Signum e)      = error ("signum of " ++ show e)
derivative (Abs e)         = error ("abs of " ++ show e)
derivative (FromInteger _) = 0

diff :: Num b => (forall a. Num a => a -> a) -> b -> b
diff f = eval $ derivative (f Var)
