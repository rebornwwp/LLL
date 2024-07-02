#include <bitset>
#include <iostream>
#include <string>

/*
    work with byte-sized chunks of data

    add0    01010100
    add1    10100101
    add2    12129012
    add3    10101001

    data_type
    float
    double
    long double	Floating Point	a number with a fractional part	3.14159
    bool	Integral (Boolean)	true or false	true
    char
    wchar_t
    char8_t (C++20)
    char16_t (C++11)
    char32_t (C++11)	Integral (Character)	a single character of text
   ‘c’ short int long long long (C++11)	Integral (Integer)	positive and
   negative whole numbers, including 0	64 std::nullptr_t (C++11)	Null
   Pointer	a null pointer	nullptr void	Void	no type	n/a

    access memory:
    1. through variable names. Good
    2. memory addresses. Bad. discard physics
 */

void print(int x) { std::cout << x << "\n"; }

void printInt(const int x) { std::cout << x << "\n"; }

int five() { return 5; }

int main() {
  float f{11111.1111111f};
  std::cout << f << "\n";
  double d{11111.1111111f};
  std::cout << d << "\n";

  std::uint32_t i_32{100000};
  std::cout << i_32 << "\n";

  // double nan{0 / 0};
  // std::cout << nan << "\n";

  std::cout << "bool:\t\t" << sizeof(bool) << " bytes\n";
  std::cout << "char:\t\t" << sizeof(char) << " bytes\n";
  std::cout << "wchar_t:\t" << sizeof(wchar_t) << " bytes\n";
  std::cout << "char16_t:\t" << sizeof(char16_t) << " bytes\n";
  std::cout << "char32_t:\t" << sizeof(char32_t) << " bytes\n";
  std::cout << "short:\t\t" << sizeof(short) << " bytes\n";
  std::cout << "int:\t\t" << sizeof(int) << " bytes\n";
  std::cout << "long:\t\t" << sizeof(long) << " bytes\n";
  std::cout << "long long:\t" << sizeof(long long) << " bytes\n";
  std::cout << "float:\t\t" << sizeof(float) << " bytes\n";
  std::cout << "double:\t\t" << sizeof(double) << " bytes\n";
  std::cout << "long double:\t" << sizeof(long double) << " bytes\n";

  std::cout << "least 8:  " << sizeof(std::int_least8_t) * 8 << " bits\n";
  std::cout << "least 16: " << sizeof(std::int_least16_t) * 8 << " bits\n";
  std::cout << "least 32: " << sizeof(std::int_least32_t) * 8 << " bits\n";
  std::cout << '\n';
  std::cout << "fast 8:  " << sizeof(std::int_fast8_t) * 8 << " bits\n";
  std::cout << "fast 16: " << sizeof(std::int_fast16_t) * 8 << " bits\n";
  std::cout << "fast 32: " << sizeof(std::int_fast32_t) * 8 << " bits\n";

  std::cout << std::boolalpha;
  // std::cout << std::noboolalpha;
  std::cout << true << '\n';   // true evaluates to 1
  std::cout << !true << '\n';  // !true evaluates to 0

  bool b{false};
  std::cout << b << '\n';   // b is false, which evaluates to 0
  std::cout << !b << '\n';  // !b is true, which evaluates to 1

  // char
  char c{'a'};  // preffered
  char c1{98};
  std::cout << c << "\n";
  std::cout << c1 << "\n";
  std::cout << c1 - c << "\n";

  // type conversion and static_cast
  print(static_cast<int>(5.5));
  // char to int
  print(static_cast<int>(c));
  // unsigned to signed
  unsigned int u{5u};
  print(static_cast<int>(u));

  // const
  // runtime constant or compile-time constant, compiler will track of this
  // feature we can use constexport to indicate the vars is compile-time
  // constant 告诉编译器相关的标记，感觉上可以提高编译的速度
  const int cx{100};
  std::cout << "const variables: " << cx << "\n";
  printInt(5);
  constexpr int cea{4};
  constexpr int ceb{5};
  constexpr int cec{cea + ceb};
  std::cout << cec << "\n";

  // bits
  std::bitset<8> bin1{0b1100'0101};  // binary literal for binary 1100 0101
  std::cout << bin1 << std::endl;

  // strings
  // std::string
  // std::string_view
  // expensive in initialize and copy
  std::string name{"Alex"};
  std::cout << name << " length:" << name.length() << "\n";
  // c++ 17
  // constexpr std::string_view s{"Hello, world!"};

  return 0;
}