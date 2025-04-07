#include <stdio.h>

// https://docs.nvidia.com/cuda/cuda-c-programming-guide/#execution-configuration
// https://www.informit.com/articles/article.aspx?p=2455391

//  Kernels provide dimension and index variables for each block and thread.
// Dimension variables:
// • gridDim specifies the number of blocks in the grid.
// • blockDim specifies the number of threads in each block.
// Index variables:
// • blockIdx gives the index of the block in the grid.
// • threadIdx gives the index of the thread within the block.

//  Kernels execute on the GPU and do not, in general, have access to data
//  stored on the host side that would be accessed by the CPU.

// Kernels cannot return a value, so the return type is always void

__global__ void index() {
  printf(
      "gridDim.x: %d, blockIdx.x: %d, blockIdx.y: %d, threadIdx.x: %d, "
      "threadIdx.y: %d\n",
      gridDim.x, blockIdx.x, blockIdx.y, threadIdx.x, threadIdx.y);
}

__global__ void index_1D() {
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  printf("1D idx: %d\n", idx);
  // 内核称为单片内核(monolithic kernel)，
  // 因为它假设一个大型线程网格可以一次性处理整个数组
  // 完全消除loop，对arrary的每个元素进行并行计算
}

// https://developer.nvidia.com/blog/cuda-pro-tip-write-flexible-kernels-grid-stride-loops/
__global__ void index_1D_grid_stride() {
  int n = 100;
  int tid = threadIdx.x + blockIdx.x * blockDim.x;  // 全局索引
  int stride = blockDim.x * gridDim.x;              // 总线程数
  for (int i = tid; i < n; i += stride) {
    // operate on index i
    // 这里整体数据，切分成部分并行， 每个并行逻辑中有loop的逻辑
    // TODO: grid stride for 2D and 3D
  }
}

__global__ void index_2D() {
  int row = blockIdx.y * blockDim.y + threadIdx.y;
  int col = blockIdx.x * blockDim.x + threadIdx.x;
  // if ptr is a matrix of [height][width],
  // the element of [row][col] is ptr[row * width + col]
  printf("row: %d, column: %d\n", row, col);
}

__global__ void index_3D() {
  int row = blockIdx.y * blockDim.y + threadIdx.y;
  int col = blockIdx.x * blockDim.x + threadIdx.x;
  int str = blockIdx.z * blockDim.z +
            threadIdx.z;  // stratum or stack, range from [0, D-1], D is the
                          // depth of the stack
  // if ptr is a matrix of [height][width][Depth],
  // the element of [row][col][str] is ptr[row * width + col + str*width*height]
  printf("row: %d, column: %d, stratum: %d\n", row, col, str);
}

void getBoundaryValue() {
  int devNo = 0;
  cudaDeviceProp iProp;

  cudaGetDeviceProperties(&iProp, devNo);

  printf("Maximum grid size is: (");
  for (int i = 0; i < 3; i++) {
    printf("%d\t,", iProp.maxGridSize[i]);
  }
  printf(")\n");

  printf("Maximum block size is: (");
  for (int i = 0; i < 3; i++) {
    printf("%d\t,", iProp.maxThreadsDim[i]);
  }
  printf(")\n");

  printf("Max threads per block: %d\n", iProp.maxThreadsPerBlock);
  printf("Max threads per MP: %d\n", iProp.maxThreadsPerMultiProcessor);
}

int main() {
  getBoundaryValue();

  printf("####################################\n");
  printf("block 1, thread 1\n");
  index<<<1, 1>>>();
  cudaDeviceSynchronize();

  printf("####################################\n");
  printf("block 2, thread 2\n");
  index<<<2, 2>>>();
  cudaDeviceSynchronize();

  printf("####################################\n");
  printf("launch kernel with dim3:\n");
  int nx;  // total threads in X dimension
  int ny;  // total threads in Y dimension
  int nz;  // total threads in Z dimension
  nx = 4;
  ny = 1;
  nz = 1;
  dim3 block(2, 1, 1);
  dim3 grid(nx / block.x, ny / block.y, nz / block.z);
  printf("grid: (%d, %d, %d), block: (%d,%d,%d)\n", grid.x, grid.y, grid.z,
         block.x, block.y, block.z);
  index<<<grid, block>>>();
  cudaDeviceSynchronize();

  printf("####################################\n");
  dim3 block_1D(2, 1, 1);
  dim3 grid_1D(2, 1, 1);
  printf("grid: (%d, %d, %d), block: (%d,%d,%d)\n", grid_1D.x, grid_1D.y,
         grid_1D.z, block_1D.x, block_1D.y, block_1D.z);
  index_1D<<<grid_1D, block_1D>>>();
  cudaDeviceSynchronize();

  printf("####################################\n");
  dim3 block_2D(3, 3, 1);
  dim3 grid_2D(3, 3, 1);
  printf("grid: (%d, %d, %d), block: (%d,%d,%d)\n", grid_2D.x, grid_2D.y,
         grid_2D.z, block_2D.x, block_2D.y, block_2D.z);
  // matrix 2D is W columns and H rows
  // computation into 2D blocks with
  //   TX threads in the x-direction
  //   TY threads in the y-direction
  // dim3 blockSize(TX, TY);
  // int bx = (W + blockSize.x - 1)/blockSize.x ;
  // int by = (H + blockSize.y – 1)/blockSize.y ;
  // grid size:
  // dim3 gridSize = dim3(bx, by);
  index_2D<<<grid_2D, block_2D>>>();
  cudaDeviceSynchronize();

  printf("####################################\n");
  dim3 block_3D(3, 3, 3);
  dim3 grid_3D(3, 3, 3);
  printf("grid: (%d, %d, %d), block: (%d,%d,%d)\n", grid_3D.x, grid_3D.y,
         grid_3D.z, block_3D.x, block_3D.y, block_3D.z);
  index_3D<<<grid_3D, block_3D>>>();
  cudaDeviceSynchronize();

  printf("####################################\n");
  printf("threads size large than max:\n");
  index<<<1, 4096>>>();
  auto errName = cudaGetErrorName(cudaGetLastError());
  printf("get error: %s\n\n", errName);
  cudaDeviceSynchronize();

  return 0;
}
