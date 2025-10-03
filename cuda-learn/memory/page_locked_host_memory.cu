#include <cuda_runtime.h>
#include <stdio.h>

// 普通 malloc 就是 pageable host memory.
// 使用cudaHostAlloc 就是 f page-locked host memory, sometimes called pinned
// memory, 主要特点，never page this memory out to disk
// 对于数据传输来说都是使用DMA进行数据的拷贝,
// 拷贝的速度主要取决于 pcie 的transfer的速度与system front-side bus speeds
// 但是使用pageable host memmory的时候 copy 会执行两次，
// 第一次:from a pageable system buffer to a page-locked “staging” buffer
// 第二次:then from the page-locked system buffer to the GPU.
//
// 使用cudahostAlloc接口申请的内存已经是page-locked， 就只用走第二步

#define CUDACHECK(err)                     \
  do {                                     \
    cuda_check((err), __FILE__, __LINE__); \
  } while (false)
inline void cuda_check(cudaError_t error_code, const char *file, int line) {
  if (error_code != cudaSuccess) {
    fprintf(stderr, "CUDA Error %d: %s. In file '%s' on line %d\n", error_code,
            cudaGetErrorString(error_code), file, line);
    fflush(stderr);
    exit(error_code);
  }
}

// 计算 mallloc -> devce
float cuda_malloc_test(int size, bool up) {
  cudaEvent_t start, stop;
  int *a, *dev_a;
  float elapsedTime;

  CUDACHECK(cudaEventCreate(&start));
  CUDACHECK(cudaEventCreate(&stop));

  a = (int *)malloc(size * sizeof(*a));

  CUDACHECK(cudaMalloc((void **)&dev_a, size * sizeof(*dev_a)));
  CUDACHECK(cudaEventRecord(start, 0));

  for (int i = 0; i < 100; i++) {
    if (up) {
      CUDACHECK(
          cudaMemcpy(dev_a, a, size * sizeof(*dev_a), cudaMemcpyHostToDevice));
    } else {
      CUDACHECK(
          cudaMemcpy(a, dev_a, size * sizeof(*dev_a), cudaMemcpyDeviceToHost));
    }
  }

  CUDACHECK(cudaEventRecord(stop, 0));
  CUDACHECK(cudaEventSynchronize(stop));
  CUDACHECK(cudaEventElapsedTime(&elapsedTime, start, stop));

  free(a);
  CUDACHECK(cudaFree(dev_a));
  CUDACHECK(cudaEventDestroy(start));
  CUDACHECK(cudaEventDestroy(stop));
  return elapsedTime;
}

float cuda_host_alloc_test(int size, bool up) {
  cudaEvent_t start, stop;
  int *a, *dev_a;
  float elapsedTime;

  CUDACHECK(cudaEventCreate(&start));
  CUDACHECK(cudaEventCreate(&stop));

  CUDACHECK(cudaHostAlloc((void **)&a, size * sizeof(*a),
                          cudaHostAllocDefault));  // pinned host memory
  CUDACHECK(cudaMalloc((void **)&dev_a, size * sizeof(*dev_a)));
  CUDACHECK(cudaEventRecord(start, 0));

  for (int i = 0; i < 100; i++) {
    if (up) {
      CUDACHECK(
          cudaMemcpy(dev_a, a, size * sizeof(*dev_a), cudaMemcpyHostToDevice));
    } else {
      CUDACHECK(
          cudaMemcpy(a, dev_a, size * sizeof(*dev_a), cudaMemcpyDeviceToHost));
    }
  }

  CUDACHECK(cudaEventRecord(stop, 0));
  CUDACHECK(cudaEventSynchronize(stop));
  CUDACHECK(cudaEventElapsedTime(&elapsedTime, start, stop));

  CUDACHECK(cudaFreeHost(a));
  CUDACHECK(cudaFree(dev_a));
  CUDACHECK(cudaEventDestroy(start));
  CUDACHECK(cudaEventDestroy(stop));
  return elapsedTime;
}

#define SIZE (10 * 1024 * 1024)

int main(void) {
  float elapsedTime;
  float MB = (float)100 * SIZE * sizeof(int) / 1024 / 1024;

  elapsedTime = cuda_malloc_test(SIZE, true);
  printf("Time using cudaMalloc: %3.1f ms\n", elapsedTime);
  printf("\t MB/s during copy up: %3.1f\n", MB / (elapsedTime / 1000));

  elapsedTime = cuda_malloc_test(SIZE, false);
  printf("Time using cudaMalloc: %3.1f ms\n", elapsedTime);
  printf("\t MB/s during copy down: %3.1f\n", MB / (elapsedTime / 1000));

  elapsedTime = cuda_host_alloc_test(SIZE, true);
  printf("Time using cudaHostAlloc: %3.1f ms\n", elapsedTime);
  printf("\t MB/s during copy up: %3.1f\n", MB / (elapsedTime / 1000));

  elapsedTime = cuda_host_alloc_test(SIZE, false);
  printf("Time using cudaHostAlloc: %3.1f ms\n", elapsedTime);
  printf("\t MB/s during copy down: %3.1f\n", MB / (elapsedTime / 1000));

  return 0;
}
