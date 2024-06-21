#include <stdio.h>

// https://docs.nvidia.com/cuda/cuda-c-programming-guide/#function-parameters

// https://stackoverflow.com/questions/6499036/kernel-parameter-passing-in-cuda
// https://stackoverflow.com/questions/8302506/parameters-to-cuda-kernels

// param 在main函数中为一个host的变量，当调用device function的时候，nvcc
// compiler 将参数从host端拷贝到device端
// Passing user-defined types requires that the default copy-constructor.
// In summary pass-by-value works well for integral, floating point or other
// primitive types, and simple flat user-defined structs or class objects.

// if you are passing a pointer to a kernel, make sure it points into device
// memory.

__global__ void function_input(int param) {
  printf("input param: %d\n", param);
}

// TODO: add user defined types, need default copy-constructor
// 下面代码还不完整
struct NoMember {};
__global__ void noMemberFunc(NoMember nm) {
  printf("input no member struct: %d\n", &nm);
}

struct UserDefine {
  int a;
  int b;
};

__global__ void function_input(UserDefine ud) {}

int main() {
  constexpr int a = 10;
  function_input<<<4, 1>>>(a);
  cudaDeviceSynchronize();
  return 0;
}