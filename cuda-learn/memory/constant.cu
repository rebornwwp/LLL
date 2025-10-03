#include <stdio.h>

// 广播机制：
// 如果所有线程访问相同的常量地址，constant memory 的性能接近寄存器。
// 不适合大量数据：
// Constant memory 的大小仅 64 KB，且多线程访问不同地址会导致性能下降。
// 与其他内存的对比：
// 共享内存适用于频繁更新的小型数据。
// 全局内存适用于大量读写的数据。
// 常量内存适用于小型只读常量数据。

constexpr int N = 256;
__constant__ float constData[N];
float data[N];

__device__ float devData;
float value = 3.14;

__device__ float* devPointer;
float* ptr;

// 定义常量内存
__constant__ float constant_value;

// GPU 内核函数
__global__ void add_constant(float* matrix, int size) {
  int idx = threadIdx.x + blockIdx.x * blockDim.x;
  while (idx < size) {
    matrix[idx] += constant_value;  // 使用 constant memory
    idx += blockDim.x * gridDim.x;
  }
}

int main() {
  // 将数据拷贝到常量内存
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
  printf("dev pointer sz: %ld\n", sz);  // 8
  return 0;
}