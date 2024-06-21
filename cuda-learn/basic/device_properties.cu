#include <cuda_runtime_api.h>
#include <stdio.h>
// 	Tesla C870	Tesla C1060	Tesla C2050	Tesla K10	Tesla
// K20

// Compute Capability	1.0	1.3	2.0	3.0	3.5

// Max Threads per Thread Block	512	512	1024	1024	1024

// Max Threads per SM	768	1024	1536	2048	2048

// Max Thread Blocks per SM	8	8	8	16	16

int main() {
  int nDevices;

  cudaGetDeviceCount(&nDevices);
  for (int i = 0; i < nDevices; i++) {
    cudaDeviceProp prop;
    cudaGetDeviceProperties(&prop, i);
    printf("Device Number: %d\n", i);
    printf("  Device name: %s\n", prop.name);
    printf("  Memory Clock Rate (KHz): %d\n", prop.memoryClockRate);
    printf("  Memory Bus Width (bits): %d\n", prop.memoryBusWidth);
    printf("  Peak Memory Bandwidth (GB/s): %f\n",
           2.0 * prop.memoryClockRate * (prop.memoryBusWidth / 8) / 1.0e6);
    printf("  Compute capability: %d.%d\n\n", prop.major, prop.minor);
  }
}