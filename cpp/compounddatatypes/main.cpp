#include <functional>
#include <iostream>
#include <iterator>
#include <string_view>

// Best practice
// Favor passing by const reference over passing by non-const reference
// unless you have a specific reason to do otherwise(e.g.the function
// needs to change the value of an argument).
// Prefer pass by value for objects that are cheap to copy, and pass by const
// reference for objects that are expensive to copy. If you’re not sure whether
// an object is cheap or expensive to copy, favor pass by const reference.
int hello(const int &x) { return x + 100; }

int hello1(const int &x) { return x + 10; }

// argument with function
// ugly
void selectionSort(int *array, int size, bool (*comparisonFcn)(int, int)) {
  // Step through each element of the array
  for (int startIndex{0}; startIndex < (size - 1); ++startIndex) {
    // bestIndex is the index of the smallest/largest element we've encountered
    // so far.
    int bestIndex{startIndex};

    // Look for smallest/largest element remaining in the array (starting at
    // startIndex+1)
    for (int currentIndex{startIndex + 1}; currentIndex < size;
         ++currentIndex) {
      // If the current element is smaller/larger than our previously found
      // smallest
      if (comparisonFcn(array[bestIndex],
                        array[currentIndex]))  // COMPARISON DONE HERE
      {
        // This is the new smallest/largest number for this iteration
        bestIndex = currentIndex;
      }
    }

    // Swap our start element with our smallest/largest element
    std::swap(array[startIndex], array[bestIndex]);
  }
}

// clean and beautiful
using ValidateFunction = bool (*)(int, int);
void selectionSort1(int *array, int size, ValidateFunction fcn) {}

// use std::function
using ValidateFunctionStd = std::function<bool(int, int)>;
void selectionSort2(int *array, int size, ValidateFunctionStd fcn) {}

using Color = int;  // define a type alias named Color

// The following color values should be used for a Color
constexpr Color red{0};
constexpr Color green{1};
constexpr Color blue{2};

// Define a new unscoped enumeration named Color
enum EColor  // ::std::uint8_t
{
  // Here are the enumerators
  // These symbolic constants define all the possible values this type can hold
  // Each enumerator is separated by a comma, not a semicolon
  Ered,
  Egreen,
  Eblue,         // trailing comma optional but recommended
  Egiraffe = 5,  // shares same value as horse
                 // preffer

};  // the enum definition must end with a semicolon

// Scoped enumerations
enum class Fruit {
  banana,  // banana is considered part of Fruit's scope region
  apple,
};

// struct
struct Employee {
  int id{};
  int age{};
  double wage{};
  int default_value{100};
};

// simple memory leak function
void doSomething() {
  // 只借不还
  int *ptr{new int{}};
}

int main() {
  int x{5};     // x is a normal integer variable
  int &ref{x};  // ref is an lvalue reference variable that can now be used as
                // an alias for variable x
  x = 100;
  std::cout << x << '\n';    // print the value of x (100)
  std::cout << ref << '\n';  // print the value of x via ref (100)
  int y{6};
  ref = y;
  std::cout << x << '\n';    // print the value of x (100)
  std::cout << ref << '\n';  // print the value of x via ref (100)

  {
    int &ref1{x};  // ref is a reference to x
    ref1 = 199999;
    std::cout << ref1 << '\n';  // prints value of ref (5)
  }                             // ref is destroyed here -- x is unaware of this

  // A reference can be destroyed before the object it is referencing.
  // The object being referenced can be destroyed before the reference.

  std::cout << x << '\n';    // prints value of x (5)
  std::cout << ref << '\n';  // prints value of x (5)

  // pointer
  int px{5};
  int *pxp{&px};
  std::cout << px << "\n";
  std::cout << &px << "\n";
  std::cout << *(&px) << "\n";
  std::cout << pxp << "\n";
  std::cout << *pxp << "\n";
  // size of pointer
  std::cout << sizeof(&px) << '\n';
  {
    // Dangling pointers
    // Scope makes this happen.
    int x{5};
    int *ptr{&x};

    std::cout << *ptr << '\n';  // valid

    {
      int y{6};
      ptr = &y;

      std::cout << *ptr << '\n';  // valid
    }  // y goes out of scope, and ptr is now dangling

    std::cout
        << *ptr
        << '\n';  // undefined behavior from dereferencing a dangling pointer
  }

  {
    // null pointer,
    // Value initialize your pointers (to be null pointers) if you are not
    // initializing them with the address of a valid object. hold nothing
    int *ptr{
        nullptr};  // ptr is now a null pointer, and is not holding an address
    int x = 10;
    ptr = &x;
    std::cout << "null pointer: " << *ptr << "\n";
    // Favor references over pointers unless the additional capabilities
    // provided by pointers are needed.
  }
  // Prefer return by reference over return by address unless the ability to
  // return “no object” (using nullptr) is important.

  // enum
  Fruit fruit{Fruit::banana};  // note: banana is not directly accessible, we
                               // have to use Fruit::banana

  // struct
  Employee joe;
  joe.age = 1000;
  Employee *joe_ptr{&joe};
  std::cout << "joe's age is: " << joe.age << "\n";
  std::cout << "default value is: " << joe.default_value << "\n";
  std::cout << "ptr: joe's age is: " << joe_ptr->age << "\n";
  std::cout << "ptr: default value is: " << joe_ptr->default_value << "\n";
  // aggregate initialization
  Employee frank = {1, 32, 1000.10};

  // array
  int prime[5]{};
  prime[0] = 2;
  prime[1] = 3;
  std::cout << "prime[5]: " << prime[0] << " " << prime[1] << " " << prime[2]
            << "\n";
  // initialization
  int primes[5]{2, 3, 5, 7,
                11};  // use initializer list to initialize the fixed array
  int emit_primes[]{2, 3, 5, 7, 11};
  std::cout << primes << "\n";
  std::cout << emit_primes << "\n";
  // get length
  std::cout << "lenght of primes: " << std::size(emit_primes) << "\n";
  int length = static_cast<int>(sizeof(emit_primes) / sizeof(emit_primes[0]));
  std::cout << "length of primes: " << length << "\n";

  for (int i = 0; i < length; ++i) {
    std::cout << "index: " << i << " value: " << emit_primes[i] << " ";
  }
  std::cout << "\n";

  for (auto x : emit_primes) {
    std::cout << x << " ";
  }
  std::cout << "\n";
  // array pointer
  std::cout << "prime is a pointer to int*: " << prime << "\n";
  std::cout << "*prime is the first element: " << *prime << "\n";
  int *p2 = prime + 1;
  std::cout << "p2 is a pointer to int*: " << p2 << "\n";
  std::cout << "*p2 is the second element: " << *p2 << "\n";
  // void printSize(int array[]);
  // void printSize(int* array); best practice.
  // two function si identical

  int array[3][5]{
      {1, 2, 3, 4, 5},      // row 0
      {6, 7, 8, 9, 10},     // row 1
      {11, 12, 13, 14, 15}  // row 2
  };

  // C-style string
  // 可以基于index进行修改
  char s[]{"this is a C style string!"};
  std::cout << s << "\n";
  s[0] = 'T';
  std::cout << s << "\n";

  // string_view
  std::string_view str{"hello world"};
  std::cout << str.length() << "\n";

  // Dynamic memory allocation with new and delete
  // Dynamic memory allocation is a way for running programs to request memory
  // from the operating system when needed. This memory does not come from the
  // program’s limited stack memory -- instead, it is allocated from a much
  // larger pool of memory managed by the operating system called the heap.
  // On modern machines, the heap can be gigabytes in size.
  int *ptr_int{new int};
  std::cout << "allocate int memory: " << ptr_int << " " << *ptr_int << "\n";
  *ptr_int = 100;
  std::cout << "init int value: " << ptr_int << " " << *ptr_int << "\n";
  delete ptr_int;  // return the memory pointed to by ptr to the operating
                   // system.
                   // 这里主要是内存的归属权从进程到操作系统，但是内存地址的值其实在程序中已经无效，delete之后继续使用此指针将导致coredump
  ptr_int = nullptr;  // set ptr to be a null pointer
  std::cout << "after destory int memory: " << ptr_int << " "
            << /* *ptr_int*/ ""
            << "\n";

  // function pointers
  std::cout << reinterpret_cast<void *>(hello) << "\n";
  // fcnPtr is a pointer to funciton
  int (*fcnPtr)(const int &){nullptr};
  fcnPtr = &hello;
  std::cout << "function pointer is: " << fcnPtr << "\n";
  std::cout << "run a function pointer: " << (*fcnPtr)(10) << "\n";
  fcnPtr = &hello1;
  std::cout << "run a function pointer: " << (*fcnPtr)(10) << "\n";

  return 0;
}