#include <stdio.h>

// __global__ is the qualifier for kernels (which can be called from the host
// and executed on the device).

// __host__ functions are called from the host and execute on the host.
// (This is the default qualifier and is often omitted.)

// __device__ functions are called from the device and execute on the device.
// (A function that is called from a kernel needs the __device__ qualifier.)

__global__ void call_in_host_run_in_device() {
  printf("call in host run in device\n");
}

__host__ void call_in_host_run_in_host() {
  printf("call in host run in host\n");
}

__device__ void call_in_device_run_in_device() {
  printf("call in device run in device\n");
}

__global__ void callFunctionInDeviceCode() {
  printf("call device function\n");
  call_in_device_run_in_device();
}

int main() {
  printf("#########################\n");
  call_in_host_run_in_device<<<1, 1>>>();
  cudaDeviceSynchronize();
  printf("#########################\n");
  // error: a host function call cannot be configured
  // call_in_host_run_in_host<<<1, 1>>>();
  call_in_host_run_in_host();
  printf("#########################\n");
  callFunctionInDeviceCode<<<1, 1>>>();
  cudaDeviceSynchronize();
  return 0;
}