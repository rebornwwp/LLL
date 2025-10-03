#include <cstdio>
#include <iostream>

#define CUDACHECK(err)                     \
  do {                                     \
    cuda_check((err), __FILE__, __LINE__); \
  } while (false)
inline void cuda_check(cudaError_t error_code, const char* file, int line) {
  if (error_code != cudaSuccess) {
    fprintf(stderr, "CUDA Error %d: %s. In file '%s' on line %d\n", error_code,
            cudaGetErrorString(error_code), file, line);
    fflush(stderr);
    exit(error_code);
  }
}

#define CHECK_LAST_CUDA_ERROR()   \
  do {                            \
    checkLast(__FILE__, __LINE__) \
  } while (false)
inline void checkLast(const char* const file, const int line) {
  cudaError_t const err{cudaGetLastError()};
  if (err != cudaSuccess) {
    std::cerr << "CUDA Runtime Error at: " << file << ":" << line << std::endl;
    std::cerr << cudaGetErrorString(err) << std::endl;
    // We don't exit when we encounter CUDA errors in this example.
    // std::exit(EXIT_FAILURE);
  }
}

int main() {
  cudaError_t err1 = cudaPeekAtLastError();
  cudaError_t errSync = cudaGetLastError();
  cudaError_t errAsync = cudaDeviceSynchronize();
  CUDACHECK(err1);
  if (errSync != cudaSuccess)
    printf("Sync kernel error: %s\n", cudaGetErrorString(errSync));
  if (errAsync != cudaSuccess)
    printf("Async kernel error: %s\n", cudaGetErrorString(errAsync));

  printf("%s\n", cudaGetErrorName(err1));
}