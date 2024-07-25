#include <cuda_runtime_api.h>

__managed__ unsigned int x;

// Print a managed variable
__global__ void PrintFoo() { printf("mFoo GPU: %d\n", x); }

int main() {
  x = 10;
  return 0;
}