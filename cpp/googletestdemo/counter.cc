#include "counter.h"

#include <iostream>

int Counter::Increment() { return counter_++; }

int Counter::Decrement() {
  if (counter_ == 0) {
    return counter_;
  }
  return counter_--;
}

void Counter::Print() const { std::cout << counter_ << "\n"; }