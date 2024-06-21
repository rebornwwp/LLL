cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
project(hello LANGUAGES CXX CUDA)
enable_language(CUDA)

# if(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)
#     set(CMAKE_CUDA_ARCHITECTURES 50 52 53)
# endif(NOT DEFINED CMAKE_CUDA_ARCHITECTURES)

add_subdirectory(basic)
add_subdirectory(memory)
add_subdirectory(cuda-library)
add_subdirectory(implement)
