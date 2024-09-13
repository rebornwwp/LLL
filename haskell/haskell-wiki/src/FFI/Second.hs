{-# LANGUAGE CApiFFI #-}

module FFI.Second where


-- https://en.wikibooks.org/wiki/Haskell/FFI
import           Foreign         (Ptr)
import           Foreign.C.Types


-- 调用 math.h 库的 sin 函数
foreign import capi unsafe "math.h sin" c_sin :: CDouble -> CDouble


-- 随机函数是no pure function, 需要使用IO monad来进行包装
foreign import capi unsafe "stdlib.h rand" c_rand :: IO CUInt

foreign import capi "stdlib.h srand" c_srand :: CUInt -> IO ()


-- Using capi, to automatically include sys/select.h and handle the macro
foreign import capi "sys/select.h FD_SET" c_fd_set :: CInt -> Ptr () -> IO ()


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


-- export function so that a foreign code can call haskell code
triple :: Int -> Int
triple x = 3 * x

foreign export ccall triple :: Int -> Int
