
#include <cstring>
#include <iostream>
#include <string>
#include <vector>

#include "cuda.h"
#include "cuda_runtime.h"

#define cudaCheckError(e)                                      \
  {                                                            \
    if (e != cudaSuccess) {                                    \
      printf("Cuda failure %s:%d: '%s'\n", __FILE__, __LINE__, \
             cudaGetErrorString(e));                           \
      exit(0);                                                 \
    }                                                          \
  }

#define WIDTH 7024
#define HEIGHT 2024
#define DEPTH 4

// CUDA 内核函数：对 2D 数组中的每个元素执行加法操作
__global__ void gridStrideAdd2D(int *data, int *d_data, int width, int height,
                                int depth) {
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  int idy = blockIdx.y * blockDim.y + threadIdx.y;
  int idz = blockIdx.z * blockDim.z + threadIdx.z;

  int strideX = blockDim.x * gridDim.x;
  int strideY = blockDim.y * gridDim.y;
  int strideZ = blockDim.z * gridDim.z;

  for (int z = idz; z < depth; z += strideZ) {
    for (int y = idy; y < height; y += strideY) {
      for (int x = idx; x < width; x += strideX) {
        int index = z * width * height + y * width + x;
        data[index] = d_data[index];
      }
    }
  }
}

int main() {
  // 1. 初始化主机数据
  int size = WIDTH * HEIGHT * DEPTH * sizeof(int);
  int *h_data = new int[WIDTH * HEIGHT * DEPTH];
  int *result_data = new int[WIDTH * HEIGHT * DEPTH];
  for (int i = 0; i < WIDTH * HEIGHT * DEPTH; i++) {
    h_data[i] = 1;
  }

  // 2. 分配设备内存并将数据拷贝到设备
  int *d_data;
  cudaMalloc((void **)&d_data, size);
  cudaMemcpy(d_data, h_data, size, cudaMemcpyHostToDevice);

  int *r_data;
  cudaMalloc((void **)&r_data, size);
  // 3. 启动内核，使用 Grid-Stride Loop 处理 2D 数据
  dim3 blockSize(8, 8, 8);
  dim3 gridSize((WIDTH + blockSize.x - 1) / blockSize.x,
                (HEIGHT + blockSize.y - 1) / blockSize.y,
                (DEPTH + blockSize.z - 1) / blockSize.z);
  gridStrideAdd2D<<<gridSize, blockSize>>>(r_data, d_data, WIDTH, HEIGHT,
                                           DEPTH);

  cudaCheckError(cudaGetLastError());
  // 4. 拷贝结果回主机
  cudaMemcpy(result_data, r_data, size, cudaMemcpyDeviceToHost);

  // 5. 打印部分结果

  for (int index = 0; index < WIDTH * HEIGHT * DEPTH; index++) {
    if (h_data[index] != result_data[index]) {
      printf("index: %d, value1 %d, %d\n", index, h_data[index],
             result_data[index]);
    }
  }

  // 6. 释放内存
  cudaFree(d_data);
  cudaFree(r_data);
  delete[] h_data;
  delete[] result_data;

  return 0;
}
