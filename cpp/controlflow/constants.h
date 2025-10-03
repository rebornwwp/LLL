#ifndef CONSTANTS_H
#define CONSTANTS_H
// how to define global variable to multiple files?
namespace constants {
// 在header中定义全局变量不推荐使用
// 1. 每次被include的时候都会拷贝参数到include的文件中,
// 如果参数很多和include的地方很多将造成很多的重复
// 作为开发者需要的是使用全局变量都会指向相同的地方
// 2. 编译的问题，修改一个constant参数会导致相关文件都会重新编译
// constexpr double pi{3.1415};
// 解决方式将constant的变量变成external的变量,
// 这样指向同一个地方的变量能够被所有文件share
extern const double pi;

// C++ 17的方式
// 缺点就是编译的问题，导致相关文件重新再编译的问题
// inline constexpr double pi { 3.14159 }; // note: now inline constexpr
}  // namespace constants
#endif