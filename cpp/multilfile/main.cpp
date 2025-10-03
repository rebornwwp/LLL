#include <iostream>

#include "add.h"
#include "base.h"

#define ENABLE_DEBUG

int main() {
#ifdef ENABLE_DEBUG
  std::cout << "enable debug\n";
#endif

  std::cout << "the sum of 2+4 = " << add(2, 4) << "\n";
  std::cout << "the sum of 2+4+6 = " << add(2, 4, 6) << "\n";
  std::cout << "identity of 10 = " << identity(10) << "\n";
  int x{readNumber()};
  int y{readNumber()};
  writeNumber(x + y);
  return 0;
}
// debug tips:
// 1. print
// 2. https://github.com/sharkdp/dbg-macro
// 3. use macro
// 4. use logger, https://github.com/SergiusTheBest/plog
// 5. GDB tools