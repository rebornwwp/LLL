# introduction

CPU hava one or several computing units

GPU have hundreds or thousands of computing units

CUDA employs the `single instruction multiple thread (SIMT)` model of parallelization.
CUDA GPUs contain numerous fundamental computing units called `cores`,
and each `core` includes an `arithmetic logic unit (ALU)` and a `floating-point unit (FPU)`.
`Cores` are collected into groups called `streaming multiprocessors (SMs)`.

We parallelize a computing task by breaking it up into numerous subtasks called
`threads` that are organized into `blocks`. `Blocks` are divided into `warps` whose size
matches `the number of cores in an SM`. Each `warp` gets assigned to a particular
`SM` for execution. The SM's control unit directs each of its cores to execute the
same instructions simultaneously for each thread in the assigned warp, hence
the term "single instruction multiple thread."

CUDA Runtime API provides functions for transferring input data to the device and 
transferring results back to the host:

* cudaMalloc() allocates device memory.
* cudaMemcpy() transfers data to or from a device.
* cudaFree() frees device memory that is no longer in use.

CUDA provides functions to synchronize and coordinate execution when necessary:

* __syncThreads() synchronizes threads within a block.
* cudaDeviceSynchronize() effectively synchronizes all threads in a grid.
* Atomic operations, such as atomicAdd(), prevent conflicts associated with multiple threads concurrently accessing a variable.

## terminology

FLOPS (floating point operations per second)

the key criterion of FLOPS/watt -- the ratio of computing productivity to energy consumption

`host` refers to the CPU and its memory,

`device` refers to the GPU and its memory.
