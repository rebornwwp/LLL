#include <stdio.h>

// 对于kernel函数更多的是 data parallelism
// 通过stream可以实现 task parallelism
// A CUDA stream represents a queue of GPU operations that get executed in a
// specific order

__global__ void kernel(int *a, int *b, int *c, int n) {
  int idx = threadIdx.x + blockIdx.x * blockDim.x;
  int stride = blockDim.x * gridDim.x;
  while (idx < n) {
    c[idx] = a[idx] + b[idx];
    idx += stride;
  }
}
#define FULL_DATA_SIZE (1 << 20)  // 1M 元素
#define N \
  (1 << 18)  // 每次处理的大小 chunk_size, 对一个大的数据切分成几部分来计算

int main_test() {
  cudaStream_t stream0, stream1;
  cudaStreamCreate(&stream0);
  cudaStreamCreate(&stream1);
  int *host_a, *host_b, *host_c;
  int *dev_a0, *dev_a1, *dev_b0, *dev_b1, *dev_c0, *dev_c1;
  cudaMallocHost((void **)&host_a, FULL_DATA_SIZE * sizeof(*host_a));
  cudaMallocHost((void **)&host_b, FULL_DATA_SIZE * sizeof(*host_b));

  for (int i = 0; i < FULL_DATA_SIZE; i += N * 2) {
    // enqueue copies of a in stream0 and stream1
    cudaMemcpyAsync(dev_a0, host_a + i, N * sizeof(int), cudaMemcpyHostToDevice,
                    stream0);
    cudaMemcpyAsync(dev_a1, host_a + i + N, N * sizeof(int),
                    cudaMemcpyHostToDevice, stream1);
    // enqueue copies of b in stream0 and stream1
    cudaMemcpyAsync(dev_b0, host_b + i, N * sizeof(int), cudaMemcpyHostToDevice,
                    stream0);
    cudaMemcpyAsync(dev_b1, host_b + i + N, N * sizeof(int),
                    cudaMemcpyHostToDevice, stream1);
    kernel<<<N / 256, 256, 0, stream0>>>(dev_a0, dev_b0, dev_c0, N);
    kernel<<<N / 256, 256, 0, stream1>>>(dev_a1, dev_b1, dev_c1, N);

    // enqueue copies of c from device to locked memory
    cudaMemcpyAsync(host_c + i, dev_c0, N * sizeof(int), cudaMemcpyDeviceToHost,
                    stream0);
    cudaMemcpyAsync(host_c + i + N, dev_c1, N * sizeof(int),
                    cudaMemcpyDeviceToHost, stream1);
  }
}

// 支持 device overlaps feature 才能发挥多stream的能力

int main(void) {
  cudaDeviceProp prop;
  int whichDevice;
  cudaGetDevice(&whichDevice);
  cudaGetDeviceProperties(&prop, whichDevice);
  if (!prop.deviceOverlap) {
    printf(
        "Device will not handle overlaps, so no "
        "speed up from streams\n");
    return 0;
  }
}
