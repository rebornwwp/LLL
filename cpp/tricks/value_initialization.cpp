#include <stdio.h>
#include <string.h>

#include <iostream>
#include <string>

// https://stackoverflow.com/questions/1998752/memset-or-value-initialization-to-zero-out-a-struct/2000646#2000646

using namespace std;

struct POD_OnlyStruct {
  int a;
  char b;
};

struct NotPOD_struct {
  int a;
  std::string b;
};

int main() {
  // 1
  POD_OnlyStruct t = {};
  // 2
  POD_OnlyStruct t1;
  memset(&t1, 0, sizeof(t1));

  std::cout << "OK: " << t1.a << t1.b << "end" << std::endl;

  NotPOD_struct nt = {};
  NotPOD_struct nt1;
  memset(&nt1, 0, sizeof(nt1));
  std::cout << "OK: " << nt1.a << nt1.b << "end" << std::endl;

  return 0;
}
