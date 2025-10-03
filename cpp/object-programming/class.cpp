#include "class.h"

#include <iostream>

void class_ns::DataClass::hello() const {
  std::cout << "dataclass hello"
            << "\n";
}

void class_ns::DataClass::hello(int x) { std::cout << "hello x " << x << "\n"; }

class_ns::DataClass::DataClass() { std::cout << "dataclass init\n"; }

// Use member initializer lists to initialize your class member variables
// instead of assignment.
class_ns::DataClass::DataClass(int y, int m, int d)
    : m_year{y}, m_month{m}, m_day{d} {
  std::cout << "dataclass init with " << y << m << d << "\n";
}

// use another constructor to construct class instance.
class_ns::DataClass::DataClass(int m, int d)
    : class_ns::DataClass::DataClass{2022, m, d} {
  std::cout << "dataclass init with " << m << d << "\n";
}

class_ns::DataClass::~DataClass() {
  delete[] this->my_array;
  std::cout << "dataclass destory\n";
}

void class_ns::DataClass::increment() { s_value += 1; }

int class_ns::DataClass::s_value{1};

void class_ns::DataClass::set_private(int x) {
  prive_value = x;
  std::cout << "hi set private value in friend function.\n";
}
