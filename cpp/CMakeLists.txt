cmake_minimum_required(VERSION 3.13.4)

project(
  cpp-learn
  LANGUAGES CXX C
  VERSION 0.1.0)

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# enable code coverage:
# https://www.jetbrains.com/help/clion/code-coverage-clion.html add code
# coverage set(ENABLE_COVERAGE true) if(ENABLE_COVERAGE) set compiler flags for
# gcc coverage
set(CMAKE_CXX_FLAGS "-O0 -coverage")
# for clang coverage set(CMAKE_CXX_FLAGS "-fprofile-instr-generate
# -fcoverage-mapping")

# find required tools
find_program(LCOV lcov REQUIRED)
find_program(GENHTML genhtml REQUIRED)

# add coverage target
add_custom_target(
  coverage
  # gather data
  COMMAND ${LCOV} --directory . --capture --output-file coverage.info
  # generate report
  COMMAND ${GENHTML} --demangle-cpp -o coverage coverage.info
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR})
# endif()

add_subdirectory(helloworld)
add_subdirectory(multilfile)
add_subdirectory(datatypes)
add_subdirectory(controlflow)
add_subdirectory(template)
add_subdirectory(compounddatatypes)
add_subdirectory(object-programming)
add_subdirectory(inheritance)
add_subdirectory(googletestdemo)
add_subdirectory(cmake-demo)
add_subdirectory(tricks)
add_subdirectory(exception)
add_subdirectory(macro)
