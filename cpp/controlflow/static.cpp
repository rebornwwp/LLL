#include <iostream>

namespace static_ns {
void incrementAndPrint() {
  // static keyword on a local variable changes its duration from
  // automatic duration to static duration. This means the variable
  // is now created at the start of the program, and destroyed at
  // the end of the program (just like a global variable). As a
  // result, the static variable will retain its value even after
  // it goes out of scope!
  // 这个使用场景需要注意，至少不要拿来做业务代码逻辑
  // 这种方式创建的变量scope有局限，使用这种方式需要思考一下
  static int value{1};
  ++value;
  std::cout << "value is: " << value << "\n";
  return;
}
}  // namespace static_ns
