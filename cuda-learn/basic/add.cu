#include <stdio.h>

__global__ void myKernel(void) {
  printf("Hello from block: %u, thread: %u\n", blockIdx.x, threadIdx.x);
}

int main() {
  constexpr int block_size = 2;
  constexpr int thread_size = 2;
  myKernel<<<block_size, thread_size>>>();
  cudaDeviceSynchronize();
  return 0;
}
