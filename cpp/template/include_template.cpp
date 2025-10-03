#include <iostream>

#include "template.h"

void use_template_func() {
  std::cout << template_tp::max<int>(10, 2000) << "\n";
}