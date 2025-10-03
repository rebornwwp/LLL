#include <cuda_runtime.h>

const int N = 33 * 1024;
const int threadsPerBlock = 256;

__global__ void inner_dot(float *a, float *b, float *c) {
  __shared__ float cache[threadsPerBlock];
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  int cacheIndex = threadIdx.x;
  float temp = 0;
  while (tid < N) {
    temp += a[tid] * b[tid];
    tid += blockDim.x * gridDim.x;
  }

  cache[cacheIndex] = temp;
  __syncthreads();

  int i = blockDim.x / 2;
  while (i != 0) {
    if (cacheIndex < i) {
      cache[cacheIndex] += cache[cacheIndex + i];
    }
    __syncthreads();  // 此时全部threads都会在这里pending
    i /= 2;
  }

  if (cacheIndex == 0) {
    c[blockIdx.x] = cache[0];
  }
}

__global__ void inner_dot_incorrect(float *a, float *b, float *c) {
  __shared__ float cache[threadsPerBlock];
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  int cacheIndex = threadIdx.x;
  float temp = 0;
  while (tid < N) {
    temp += a[tid] * b[tid];
    tid += blockDim.x * gridDim.x;
  }

  cache[cacheIndex] = temp;
  __syncthreads();

  int i = blockDim.x / 2;
  while (i != 0) {
    if (cacheIndex < i) {
      cache[cacheIndex] += cache[cacheIndex + i];
      __syncthreads();  // 这里一些threads能走到这里， 有些threads
                        // 走不到这个函数， 导致程序将会一直在等待中
    }
    i /= 2;
  }

  if (cacheIndex == 0) {
    c[blockIdx.x] = cache[0];
  }
}