#include <iostream>

#include "template.h"

int main() {
  std::cout << "hello world" << std::endl;
  std::cout << template_tp::max<int>(10, 200) << "\n";

  //  template argument deduction to have the compiler deduce the actual
  // type that should be used from the argument types in the function call.
  std::cout << template_tp::max<>(10, 200) << "\n";
  std::cout << template_tp::max(10, 200) << "\n";

  template_tp::someFcn(1, 3.4);     // matches someFcn(int, double)
  template_tp::someFcn(1, 3.4f);    // matches someFcn(int, double) -- the float
                                    // is promoted to a double
  template_tp::someFcn(1.2, 3.4);   // matches someFcn(double, double)
  template_tp::someFcn(1.2f, 3.4);  // matches someFcn(float, double)
  template_tp::someFcn(1.2f, 3.4f);  // matches someFcn(float, double) -- the
                                     // float is promoted to a double
  return 0;
}