#include <cstdlib>
#include <iostream>

#define MY_NAME "ALEX"

#define PRINT_JOE

int add(int, int);

/*
compile process
1. translate cpp source code into a machine language file called object file.
*.o or *.obj. In this example the object file is `helloworld.cpp.o`
2. linker will  combine *.o file to generate a single executable program. or
linking library files. Also make sure all cross-file dependencies are resolved
properly.

build configuration: project settings
    debug configuration -DCMAKE_BUILD_TYPE=debug  binary: 40K
    release configuration -DCMAKE_BUILD_TYPE=RELEASE binary: 20K
 */

// comment
// At the library, program, or function level, use comments to describe what.
// Inside the library, program, or function, use comments to describe how.
// At the statement level, use comments to describe why.

// insertion operator (<<)

// reference, is not pointer
void doNothing(
    int &x)  // Don't worry about what & is for now, we're just using it to
             // trick the compiler into thinking variable x is used
{
  x = 1000;
  return;
}

int main() {
// conditional compilation
#ifdef PRINT_JOE
  std::cout << "hello JOE\n";
#endif

#ifndef PRINT_BOB
  std::cout << "not print bob\n";
#endif

#ifdef PRINT_BOB
  std::cout << "hello BOB\n";
#endif

#if 0
    std::cout << "hello wolrd";
#endif

  std::cout << MY_NAME << "\n";
  int a, b;
  // a = 10;
  // a = 100;
  // init
  doNothing(a);
  int c(6);
  int d{7};
  std::cout << a << " " << b << " " << c << " " << d << std::endl;
  int x{};  // define variable x to hold user input (and zero-initialize it)
  std::cin >> x;  // get number from keyboard and store it in variable x

  std::cout << "You entered " << x << '\n';
  std::cout << "hello world\n";
  std::cout << add(1, 10) << std::endl;
  return EXIT_SUCCESS;
}

int add(int a, int b) { return a + b; }