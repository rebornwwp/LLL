add_library(add add.cpp)
add_executable(cmake-demo main.cpp)
target_link_libraries(cmake-demo add)
