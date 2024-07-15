#include <stdio.h>

constexpr int N = 256;
__constant__ float constData[N];
float data[N];

__device__ float devData;
float value = 3.14;

__device__ float* devPointer;
float* ptr;

int main() {
  cudaMemcpyToSymbol(constData, data, sizeof(data));
  cudaMemcpyFromSymbol(data, constData, sizeof(data));

  cudaMemcpyToSymbol(devData, &value, sizeof(float));

  cudaMalloc(&ptr, 256 * sizeof(float));
  cudaMemcpyToSymbol(devPointer, &ptr, sizeof(ptr));

  void* devptr = NULL;
  size_t sz;
  cudaGetSymbolAddress(&devptr, devPointer);
  cudaGetSymbolSize(&sz, devPointer);
  printf("dev pointer: %d\n", devptr);  // 8
  printf("dev pointer sz: %ld\n", sz);   // 8
  return 0;
}