#include <iostream>

// gcc -E test.cpp > test.p
// 通过此方式可以获取macro展开的结果
using namespace std;
#define DEBUG

// 函数macro
#define MIN(a, b) (((a) < (b)) ? a : b)
// #运算
#define MKSTR(x) #x
// ##运算
#define concat(a, b) a##b

int main() {
#ifdef DEBUG
  cout << "hello debug\n";
#endif

#ifndef NODEFINE
  cout << "not define macro\n";
#endif

  cout << MKSTR(HELLO C++) << endl;
  int xy = 10;
  cout << concat(x, y) /* concat(x, y) => xy */ << endl;

  // 预定义macro
  cout << "Value of __LINE__ : " << __LINE__ << endl;
  cout << "Value of __FILE__ : " << __FILE__ << endl;
  cout << "Value of __DATE__ : " << __DATE__ << endl;
  cout << "Value of __TIME__ : " << __TIME__ << endl;
  return 0;
}