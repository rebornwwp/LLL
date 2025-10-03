#include <stdio.h>

// https://developer.nvidia.com/blog/how-implement-performance-metrics-cuda-cc/

// metric:
//   bandwidth throughtput: GB/s = BWEffective = (RB + WB) / (t * 10^9)
//   computational throughtput: GFLOP/s  Giga-FLoating-point OPerations per
//   second = total_operation_number / (t *10^9)
//       在saxpy中使用了一次加法、一次乘法， 所以操作总次数为 2*N/t/10^9

__global__ void saxpy(int n, float a, float *x, float *y) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < n) {
    y[i] = a * x[i] + y[i];
  }
}

// kernel launch time
void measure_kernel_launch_time() {
  //   cudaMemcpy(d_x, x, N * sizeof(float), cudaMemcpyHostToDevice);
  //   cudaMemcpy(d_y, y, N * sizeof(float), cudaMemcpyHostToDevice);

  //   t1 = myCPUTimer();
  //   saxpy<<<(N + 255) / 256, 256>>>(N, 2.0, d_x, d_y);
  //   cudaDeviceSynchronize();
  //   t2 = myCPUTimer();

  //   cudaMemcpy(y, d_y, N * sizeof(float), cudaMemcpyDeviceToHost);
}

// kernel execution time
void measure_kernel_execution_time() {
  int N = 20 * (1 << 20);
  float *x, *y, *d_x, *d_y;

  x = (float *)malloc(N * sizeof(float));
  y = (float *)malloc(N * sizeof(float));

  cudaMalloc(&d_x, N * sizeof(float));
  cudaMalloc(&d_y, N * sizeof(float));

  for (int i = 0; i < N; i++) {
    x[i] = 1.0f;
    y[i] = 2.0f;
  }
  cudaMemcpy(d_x, x, N * sizeof(float), cudaMemcpyHostToDevice);
  cudaMemcpy(d_y, y, N * sizeof(float), cudaMemcpyHostToDevice);

  cudaEvent_t start, stop;
  cudaEventCreate(&start);
  cudaEventCreate(&stop);

  cudaEventRecord(start);
  // Perform SAXPY on 1M elements
  saxpy<<<(N + 511) / 512, 512>>>(N, 2.0f, d_x, d_y);
  cudaEventRecord(stop);

  cudaMemcpy(y, d_y, N * sizeof(float), cudaMemcpyDeviceToHost);

  cudaEventSynchronize(stop);

  float milliseconds = 0;
  cudaEventElapsedTime(&milliseconds, start, stop);

  float maxError = 0.0f;
  for (int i = 0; i < N; i++) {
    maxError = max(maxError, abs(y[i] - 4.0f));
  }

  printf("Max error: %f\n", maxError);
  printf("Effective Bandwidth (GB/s): %f\n", N * 4 * 3 / milliseconds / 1e6);
  // N*4 is the number of bytes transferred per array read or write
  // float is 4 bytes
  // 3 represents the reading of x and the reading and writing of y

  printf("computational throughtput (GFLOP/s): %f\n",
         N * 2 / milliseconds / 1e6);
}

int main() {
  measure_kernel_execution_time();
  return 0;
}