#include <stdio.h>
#include <stdlib.h>

#include <cstring>
#include <iostream>

using namespace std;

struct DemoStruct {
  int a;
  char b;
};

int sumAll(int *nums, int count) {
  int total = 0;
  for (int i = 0; i < count; i++) {
    total += nums[i];
  }
  return total;
}

int sumDemo(DemoStruct *nums, int count) {
  int total = 0;
  for (int i = 0; i < count; i++) {
    total += nums[i].a;
  }
  return total;
}

int main() {
  int length = 10;
  int *a = (int *)malloc(sizeof(int) * length);

  for (int i = 0; i < length; i++) {
    a[i] = i;
    std::cout << "index: " << i << "value: " << a[i] << "\n";
  }
  std::cout << "*a is " << *a << std::endl;

  std::cout << "sum 0..9:" << sumAll(a, length) << std::endl;

  DemoStruct *dss = (DemoStruct *)(malloc(sizeof(DemoStruct) * length));

  for (int i = 0; i < length; i++) {
    dss[i].a = i;
  }

  std::cout << "sumDemo 0..9:" << sumDemo(dss, length) << std::endl;

  return 0;
}