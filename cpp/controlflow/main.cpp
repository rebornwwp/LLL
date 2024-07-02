#include <iostream>

#include "bar.h"
#include "constants.h"
#include "foo.h"
#include "static.h"

void if_func() {
  if (true) {
    std::cout << "IF: true done\n";
  } else if (false) {
    std::cout << "ELSE IF: will not works\n";
  } else {
    std::cout << "ELSE: will not works\n";
  }
}

void switch_func(int x) {
  switch (x) {
    case 1:
      std::cout << "1" << std::endl;
      break;
    default:
      break;
  }
}

void loop_func(int x) {
  int count{1};
  while (count <= 10) {
    std::cout << count << " ";
    ++count;
  }
  std::cout << "done\n";
}

// 不推荐使用
// 使用如下: trailing return type,
// 好处auto函数多了之后，可以代码对齐，牛p，这语法也是醉了
auto auto_func() -> int { return 10; }

// function overload
// Best practice
// Use function overloading to make your program simpler.
auto overload_func(int x = 10) -> int { return x; }
auto overload_func(double x) -> double { return x; }

// Consider using a “g” or “g_” prefix for global variables to help
// differentiate them from local variables.
const int g_x{10000};
constexpr int g_cx{10000};

// use foo_g in foo.cpp, foo_g is file scope
// avoid use global variables.
extern int foo_g;

int main() {
  // start block
  if_func();
  switch_func(1);
  loop_func(1);
  std::cout << "hello world\n";
  std::cout << ((true) ? "helloFlow" : "world") << std::endl;
  std::cout << bar::add(10, 10) << std::endl;
  std::cout << foo::add(10, 10) << std::endl;
  std::cout << bar::e << std::endl;
  std::cout << bar::bar_nest::add(10, 10) << std::endl;

  // namespace aliases
  namespace ali_bar = bar;
  std::cout << "aliases namespace: " << ali_bar::bar_nest::add(10, 10)
            << std::endl;
  std::cout << "global const int: " << g_x << std::endl;
  std::cout << "global constexpr int: " << g_cx << std::endl;
  std::cout << "FUCK: " << foo_g << std::endl;

  // define global variables
  std::cout << constants::pi << std::endl;

  // static
  static_ns::incrementAndPrint();
  static_ns::incrementAndPrint();
  static_ns::incrementAndPrint();
  static_ns::incrementAndPrint();
  static_ns::incrementAndPrint();

  // summary:
  // https://www.learncpp.com/cpp-tutorial/scope-duration-and-linkage-summary/

  // inline
  // Avoid the use of the inline keyword for functions unless you have a
  // specific, compelling reason to do so. 一般不使用，只有在特定场景下使用
  // 主要作用是做代码替换，防止函数调用堆栈等操作使得性能下降，针对小且短逻辑的函数
  std::cout << "inline test: " << foo::my_min(10, 11) << "\n";

  // constexpor function
  // tell this function can be compute in compile-time
  std::cout << "constexpr function: " << foo::my_max(10, 11) << "\n";

  // static_assert
  // assert in compile time
  static_assert(sizeof(int) == 4, "int must be 4 bytes");

  // type alias and typedef
  // typedef is for backwards compatibility reasons.
  // type alias is preferred
  // 提升代码可读性与维护性
  using Distance = double;
  Distance dis{100.0};
  std::cout << "type alias: " << dis << "\n";

  // type deduction
  auto auto1{10};
  std::cout << auto1 << std::endl;
  const auto auto2{10};
  std::cout << auto2 << std::endl;
  std::cout << auto_func() << std::endl;

  std::cout << overload_func(1) << std::endl;
  std::cout << overload_func(1.00000) << std::endl;
  std::cout << overload_func() << std::endl;

  return 0;
  // end block
}