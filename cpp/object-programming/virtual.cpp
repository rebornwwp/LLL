#include "virtual.h"

#include <iostream>

void class_ns::base::print() { std::cout << "print base class\n"; }

void class_ns::base::show() { std::cout << "show base class\n"; }

void class_ns::derived::print() { std::cout << "print derived class\n"; }

void class_ns::derived::show() { std::cout << "show derived class\n"; }