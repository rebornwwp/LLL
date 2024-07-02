#include <stdio.h>

// https://zhuanlan.zhihu.com/p/20206577/
// https://stackoverflow.com/questions/14116003/whats-the-difference-between-constexpr-and-const

// A const int var can be dynamically set to a value at runtime and once it is
// set to that value, it can no longer be changed.

// A constexpr int var cannot be dynamically set at runtime, but rather, at
// compile time. And once it is set to that value, it can no longer be changed.

template <int N>
class list {};

constexpr int sqr1(int arg) { return arg * arg; }

int sqr2(int arg) { return arg * arg; }

int main() {
  const int a = 100;
  constexpr int b = 100;
  constexpr int c = 1 << 10;  // 1024
  const int d = 1 << 10;
  list<a> list1;
  list<b> list2;

  const int X = 2;

  list<sqr1(X)> list3;
  // list<sqr2(X)> list4;

  int numbers[a];
  int numbers1[b];

  return 0;
}