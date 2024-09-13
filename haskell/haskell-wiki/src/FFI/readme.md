# introduction

## ccall

Purpose: ccall is the traditional way to call C functions in Haskell FFI. It is used when you know the exact function signature and name in C.

Headers: With ccall, the header files are not automatically included. You need to manage C headers manually if needed.

Naming Convention: The function name is used as-is in Haskell, and it assumes the symbol can be found by linking with the relevant C library.

Example:

`foreign import ccall "math.h sin" c_sin :: Double -> Double`

Here, the C function sin from math.h is imported. You need to ensure that the C library (like libm for math functions) is properly linked during compilation.

## capi

Purpose: capi (C API) is a newer extension that helps with calling C functions while automatically managing C header files. It is particularly useful when working with macros, inline functions, or more complex C APIs.

Headers: With capi, the necessary C headers are included automatically by the Haskell compiler. You don't need to manually specify them as you do with ccall.

Naming Convention: capi ensures that both functions and macros are handled correctly, as it uses the C API's declarations, not just the direct symbol name.

Example:

`foreign import capi "math.h sin" capi_sin :: Double -> Double`

In this example, the C API function sin is imported, and math.h is automatically included.
