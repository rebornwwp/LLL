{-# LANGUAGE ForeignFunctionInterface #-}

module FFI.Hello_FFI.Termios where

import           Foreign.C

foreign import ccall "termops.h set_icanon" set_icanon :: CInt -> IO ()

foreign import ccall "termops.h unset_icanon" unset_icanon :: CInt -> IO ()
