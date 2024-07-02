#include <iostream>

#include "class.h"
#include "virtual.h"

int main() {
  class_ns::DataClass dc{};
  dc.hello();

  std::cout << dc.m_day << "\n";

  class_ns::DataClass dc1{10, 22};
  // can not access private value.
  // std::cout << dc.private_value;
  const class_ns::DataClass dc2{10, 22};
  dc2.hello();

  // test static member variable
  class_ns::DataClass dc3{};
  class_ns::DataClass dc4{};
  dc3.increment();
  // the same result:
  std::cout << "static value: " << dc3.s_value << "\n";
  std::cout << "static value: " << dc4.s_value << "\n";

  // static function
  class_ns::DataClass::static_hello();

  class_ns::base *bptr;
  class_ns::derived d;
  bptr = &d;

  // Virtual function, binded at runtime
  bptr->print();

  // Non-virtual function, binded at compile time
  bptr->show();
  return 0;
}