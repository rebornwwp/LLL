#include <assert.h>
#include <stdio.h>

// Convenience function for checking CUDA runtime API results
// can be wrapped around any runtime API call. No-op in release builds.
inline cudaError_t checkCuda(cudaError_t result) {
#if defined(DEBUG) || defined(_DEBUG)
  if (result != cudaSuccess) {
    fprintf(stderr, "CUDA Runtime Error: %s\n", cudaGetErrorString(result));
    assert(result == cudaSuccess);
  }
#endif
  return result;
}

// https://www.cnblogs.com/1024incn/p/4605502.html
// https://developer.nvidia.com/blog/using-shared-memory-cuda-cc/

// Shared memory is allocated per thread block, so all threads in the block have
// access to the same shared memory. alternative is that share memory supports
// efficient sharing of information between threads in a block

// On devices of compute capability 2.x and 3.x, each multiprocessor has 64KB of
// on-chip memory that can be partitioned between L1 cache and shared memory.

// For devices of compute capability 2.x, there are two settings, 48KB shared
// memory / 16KB L1 cache, and 16KB shared memory / 48KB L1 cache. default 48KB
// shared memory

// setting level
// all kernels cudaDeviceSetCacheConfig()
// per-kernel cudaFuncSetCacheConfig()

// capability 3.x allow a third setting of 32KB shared memory / 32KB L1 cache
// which can be obtained using the option cudaFuncCachePreferEqual.

// data race problem
// __syncthreads() waits until all threads in the thread block have reached this
// point. Is used to coordinate the communication between threads in the same
// block.

// 在SIMT parallelism里，每个thread只能访问自己的kernel variable，
// 但是不能访问其他thread的东西 通过使用shared
// memory可将使得一个thread里面可以访问另外一个thread放置的信息

// ********************************** BASIC *****************************

// allocate the shared array with a fixed size
__global__ void staticReverse(int *d, int n) {
  // the shared memory array size is known at compile time.
  // size is 64
  __shared__ int s[64];
  int t = threadIdx.x;
  int tr = n - t - 1;
  s[t] = d[t];
  __syncthreads();
  d[t] = s[tr];
}

// allocate the shared array dynamically
__global__ void dynamicReverse(int *d, int n) {
  // dynamic shared memory
  extern __shared__ int s[];
  int t = threadIdx.x;
  int tr = n - t - 1;
  s[t] = d[t];
  __syncthreads();
  d[t] = d[tr];
}

void basicMain() {
  constexpr int N = 64;
  int a[N], r[N], d[N];

  for (int i = 0; i < N; i++) {
    a[i] = i;
    r[i] = N - i - 1;
    d[i] = 0;
  }
  printf("shared memory\n");

  int *d_d;
  cudaMalloc(&d_d, N * sizeof(int));
  // run version with static shared memory
  cudaMemcpy(d_d, a, N * sizeof(int), cudaMemcpyHostToDevice);
  staticReverse<<<1, N>>>(d_d, N);
  cudaMemcpy(d, d_d, N * sizeof(int), cudaMemcpyDeviceToHost);
  for (int i = 0; i < N; i++) {
    if (d[i] != r[i]) {
      printf("Error: d[%d]!=r[%d] (%d, %d)\n", i, i, d[i], r[i]);
    }
  }

  // run dynamic shared memory version
  cudaMemcpy(d_d, a, N * sizeof(int), cudaMemcpyHostToDevice);
  dynamicReverse<<<1, N, N * sizeof(int)>>>(
      d_d, N);  // 这里设置shared memory大小，单位为byte
  cudaMemcpy(d, d_d, N * sizeof(int), cudaMemcpyDeviceToHost);
  for (int i = 0; i < N; i++) {
    if (d[i] != r[i]) {
      printf("Error: d[%d]!=r[%d] (%d, %d)\n", i, i, d[i], r[i]);
    }
  }
}

// ******************************* Example ************************

// https://developer.nvidia.com/blog/efficient-matrix-transpose-cuda-cc/

// matrix transpose: https://en.wikipedia.org/wiki/Transpose

constexpr int TILE_DIM = 32;
constexpr int BLOCK_ROWS = 8;
constexpr int NUM_REPS = 100;

// Check errors and print GB/s
void postprocess(const float *ref, const float *res, int n, float ms) {
  bool passed = true;
  for (int i = 0; i < n; i++)
    if (res[i] != ref[i]) {
      printf("%d %f %f\n", i, res[i], ref[i]);
      printf("%25s\n", "*** FAILED ***");
      passed = false;
      break;
    }
  if (passed) printf("%20.2f\n", 2 * n * sizeof(float) * 1e-6 * NUM_REPS / ms);
}

__global__ void index() {
  printf(
      "gridDim.x: %d, blockIdx.x: %d, blockIdx.y: %d, threadIdx.x: %d, "
      "threadIdx.y: %d\n",
      gridDim.x, blockIdx.x, blockIdx.y, threadIdx.x, threadIdx.y);
}

// simple copy kernel
__global__ void copy(float *odata, float *idata) {
  int x = blockIdx.x * TILE_DIM + threadIdx.x;
  int y = blockIdx.y * TILE_DIM + threadIdx.y;
  int width = gridDim.x * TILE_DIM;

  for (int j = 0; j < TILE_DIM; j += BLOCK_ROWS) {
    odata[(y + j) * width + x] = idata[(y + j) * width + x];
  }
}

__global__ void trans() {}

void exampleMain1(int argc, char **argv) {
  const int nx = 1024;
  const int ny = 1024;
  const int mem_size = nx * ny * sizeof(float);

  dim3 dimGrid(nx / TILE_DIM, ny / TILE_DIM, 1);
  dim3 dimBlock(TILE_DIM, BLOCK_ROWS, 1);

  int devId = 0;
  if (argc > 1) devId = atoi(argv[1]);

  cudaDeviceProp prop;
  checkCuda(cudaGetDeviceProperties(&prop, devId));
  printf("\nDevice : %s\n", prop.name);
  printf("Matrix size: %d %d, Block size: %d %d, Tile size: %d %d\n", nx, ny,
         TILE_DIM, BLOCK_ROWS, TILE_DIM, TILE_DIM);
  printf("dimGrid: %d %d %d. dimBlock: %d %d %d\n", dimGrid.x, dimGrid.y,
         dimGrid.z, dimBlock.x, dimBlock.y, dimBlock.z);

  checkCuda(cudaSetDevice(devId));

  float *h_idata = (float *)malloc(mem_size);
  float *h_cdata = (float *)malloc(mem_size);
  float *h_tdata = (float *)malloc(mem_size);
  float *gold = (float *)malloc(mem_size);

  float *d_idata, *d_cdata, *d_tdata;
  checkCuda(cudaMalloc(&d_idata, mem_size));
  checkCuda(cudaMalloc(&d_cdata, mem_size));
  checkCuda(cudaMalloc(&d_tdata, mem_size));

  // check parameters and calculate execution configuration
  if (nx % TILE_DIM || ny % TILE_DIM) {
    printf("nx and ny must be a multiple of TILE_DIM\n");
    goto error_exit;
  }

  if (TILE_DIM % BLOCK_ROWS) {
    printf("TILE_DIM must be a multiple of BLOCK_ROWS\n");
    goto error_exit;
  }

  // host
  for (int j = 0; j < ny; j++)
    for (int i = 0; i < nx; i++) h_idata[j * nx + i] = j * nx + i;

  // correct result for error checking
  for (int j = 0; j < ny; j++)
    for (int i = 0; i < nx; i++) gold[j * nx + i] = h_idata[i * nx + j];

  // device
  checkCuda(cudaMemcpy(d_idata, h_idata, mem_size, cudaMemcpyHostToDevice));

  // events for timing
  cudaEvent_t startEvent, stopEvent;
  checkCuda(cudaEventCreate(&startEvent));
  checkCuda(cudaEventCreate(&stopEvent));
  float ms;

  // ------------
  // time kernels
  // ------------
  printf("%25s%25s\n", "Routine", "Bandwidth (GB/s)");

  // index
  index<<<dimGrid, dimBlock>>>();

  // ----
  // copy
  // ----
  printf("%25s", "copy");
  checkCuda(cudaMemset(d_cdata, 0, mem_size));
  // warm up
  copy<<<dimGrid, dimBlock>>>(d_cdata, d_idata);
  checkCuda(cudaEventRecord(startEvent, 0));
  for (int i = 0; i < NUM_REPS; i++) {
    copy<<<dimGrid, dimBlock>>>(d_cdata, d_idata);
  }
  checkCuda(cudaEventRecord(stopEvent, 0));
  checkCuda(cudaEventSynchronize(stopEvent));
  checkCuda(cudaEventElapsedTime(&ms, startEvent, stopEvent));
  checkCuda(cudaMemcpy(h_cdata, d_cdata, mem_size, cudaMemcpyDeviceToHost));
  postprocess(h_idata, h_cdata, nx * ny, ms);

error_exit:
  // cleanup
  checkCuda(cudaEventDestroy(startEvent));
  checkCuda(cudaEventDestroy(stopEvent));
  checkCuda(cudaFree(d_tdata));
  checkCuda(cudaFree(d_cdata));
  checkCuda(cudaFree(d_idata));
  free(h_idata);
  free(h_tdata);
  free(h_cdata);
  free(gold);
}

int main(int argc, char **argv) {
  exampleMain1(argc, argv);
  return 0;
}
