#include <iostream>

// kernel function declation with __global__
__global__ void myKernel(void) {}

int main(void) {
  // kernel launch, run device code
  myKernel<<<1, 1>>>();
  // wait device code done
  cudaDeviceSynchronize();
  printf("Hello CUDA!\n");
  return 0;
}
