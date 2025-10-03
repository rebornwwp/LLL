
// 线程分岐（Thread Divergence） 是 CUDA 编程中性能优化的一个重要概念。它发生在
// 一个 warp 中的线程执行不同的控制流路径 时，例如在条件判断或循环中。

// CUDA 中的线程分岐
// 一个 warp 包含 32 个线程，它们被分组为一个单元并同时执行同一条指令。
// 如果 warp 内的线程在同一指令上执行不同的路径，例如 if-else 或 while
// 循环，则需要分开执行，导致性能下降。
__global__ void thread_divergence() {
  int my_var = 0;
  if (threadIdx.x % 2) {
    my_var = threadIdx.x;
  }
}