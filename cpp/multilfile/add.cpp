#include <iostream>

#include "base.h"

int add(int x, int y) { return identity(x) + identity(y); }

int add(int x, int y, int z) { return identity(x) + identity(y) + identity(z); }

int readNumber() {
  std::cout << "Enter a number: ";
  int x{};
  std::cin >> x;
  return x;
}

void writeNumber(int x) { std::cout << "The answer is: " << x << "\n"; }