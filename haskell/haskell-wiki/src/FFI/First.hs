{-# LANGUAGE ForeignFunctionInterface #-}

-- https://en.wikibooks.org/wiki/Haskell/FFI
import           Foreign
import           Foreign.C.Types

-- 调用 math.h 库的 sin 函数
foreign import ccall unsafe "math.h sin" c_sin :: CDouble -> CDouble

-- 随机函数是no pure function, 需要使用IO monad来进行包装
foreign import ccall unsafe "stdlib.h rand" c_rand :: IO CUInt

foreign import ccall "stdlib.h srand" c_srand :: CUInt -> IO ()

--  working with pointer, double gsl_frexp (double x, int * e)
-- foreign import ccall unsafe "gsl/gsl_math.h gsl_frexp" gsl_frexp
--   :: CDouble -> Ptr CInt -> IO CDouble
haskellSin :: Double -> Double
haskellSin = realToFrac . c_sin . realToFrac

maintest :: IO ()
maintest = do
  print $ haskellSin 10
  x <- c_rand
  print x
  c_srand 10
