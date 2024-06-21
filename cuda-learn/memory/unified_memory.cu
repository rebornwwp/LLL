#include <math.h>

#include <iostream>

// https://developer.nvidia.com/blog/unified-memory-cuda-beginners/
// https://developer.nvidia.com/blog/unified-memory-in-cuda-6/
// https://docs.nvidia.com/cuda/cuda-c-programming-guide/index.html?highlight=cudaMemPrefetchAsync#unified-memory-programming
// TODO: read doc
// 是怎么样做数据migration的
// 替换cudamalloc的注意的点
// 编程模式到底改变了些什么？
// TODO:
// https://github.com/NVIDIA-developer-blog/code-samples/tree/master/posts/unified-memory
// TODO: https://developer.nvidia.com/blog/unified-memory-in-cuda-6/
// Example: CPU/GPU Shared Linked Lists
// Example: Eliminate Deep Copies
// UVA and UM

// This approach breaks down the barrier between host memory and
// device memory so that you can have one array that is (or at least appears to
// be) accessible from both host and device

// system requirement: a GPU with compute capability not less than 3.0 and a
// 64-bit version of either Linux

//  the Pascal GPU architecture is the first with hardware support for virtual
//  memory page faulting and migration, via its Page Migration Engine

// benefit:
//   Simpler Programming and Memory Model
//   Performance Through Data Locality

// An important point is that a carefully tuned CUDA program that uses streams
// and cudaMemcpyAsync to efficiently overlap execution with data transfers may
// very well perform better than a CUDA program that only uses Unified Memory.

__global__ void init(int n, float *x, float *y) {
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  for (int i = index; i < n; i += stride) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }
}

__global__ void add(int n, float *x, float *y) {
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  for (int i = index; i < n; i += stride) {
    y[i] = x[i] + y[i];
  }
}

void main_init_in_host() {
  int N = 1 << 20;
  float *x, *y;

  // Allocate Unified Memory -- accessible from CPU or GPU
  cudaMallocManaged(&x, N * sizeof(float));
  cudaMallocManaged(&y, N * sizeof(float));

  // initialize x and y arrays on the host
  for (int i = 0; i < N; i++) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }

  // Launch kernel on 1M elements on the GPU
  int blockSize = 256;
  int numBlocks = (N + blockSize - 1) / blockSize;
  add<<<numBlocks, blockSize>>>(N, x, y);

  cudaDeviceSynchronize();

  // Check for errors (all values should be 3.0f)
  float maxError = 0.0f;
  for (int i = 0; i < N; i++) maxError = fmax(maxError, fabs(y[i] - 3.0f));
  std::cout << "Max error: " << maxError << std::endl;

  // Free memory
  cudaFree(x);
  cudaFree(y);
}

void main_init_in_kernel() {
  int N = 1 << 20;
  float *x, *y;

  // Allocate Unified Memory -- accessible from CPU or GPU
  cudaMallocManaged(&x, N * sizeof(float));
  cudaMallocManaged(&y, N * sizeof(float));

  int blockSize = 256;
  int numBlocks = (N + blockSize - 1) / blockSize;
  // initialize x and y arrays on the device
  init<<<numBlocks, blockSize>>>(N, x, y);
  cudaDeviceSynchronize();

  // Launch kernel on 1M elements on the GPU
  add<<<numBlocks, blockSize>>>(N, x, y);

  cudaDeviceSynchronize();

  // Check for errors (all values should be 3.0f)
  float maxError = 0.0f;
  for (int i = 0; i < N; i++) maxError = fmax(maxError, fabs(y[i] - 3.0f));
  std::cout << "Max error: " << maxError << std::endl;

  // Free memory
  cudaFree(x);
  cudaFree(y);
}

void main_sync_by_user() {
  int device = -1;
  cudaGetDevice(&device);

  int N = 1 << 20;
  float *x, *y;

  // Allocate Unified Memory -- accessible from CPU or GPU
  cudaMallocManaged(&x, N * sizeof(float));
  cudaMallocManaged(&y, N * sizeof(float));

  // initialize x and y arrays on the host
  for (int i = 0; i < N; i++) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }

  // prefetch to device
  cudaMemPrefetchAsync(x, N * sizeof(float), device, NULL);
  cudaMemPrefetchAsync(y, N * sizeof(float), device, NULL);

  int blockSize = 256;
  int numBlocks = (N + blockSize - 1) / blockSize;

  // Launch kernel on 1M elements on the GPU
  add<<<numBlocks, blockSize>>>(N, x, y);

  // prefetch to host
  cudaMemPrefetchAsync(x, N * sizeof(float), device, NULL);
  cudaMemPrefetchAsync(y, N * sizeof(float), device, NULL);

  cudaDeviceSynchronize();

  // Check for errors (all values should be 3.0f)
  float maxError = 0.0f;
  for (int i = 0; i < N; i++) maxError = fmax(maxError, fabs(y[i] - 3.0f));
  std::cout << "Max error: " << maxError << std::endl;

  // Free memory
  cudaFree(x);
  cudaFree(y);
}

int main() {
  main_init_in_host();
  main_init_in_kernel();
  main_sync_by_user();
  return 0;
}