#include <exception>
#include <iostream>

void basic() {
  try {
    throw -1;
  } catch (int x) {
    std::cerr << "we caught an int exception with value: " << x << '\n';
  } catch (double) {
    std::cerr << "we caught an int exception of type double" << '\n';
  } catch (std::string&) {
    std::cerr << "we caught an int exception of type std::string" << '\n';
  } catch (...) {
    std::cout << "We caught an exception of an undetermined type\n";
  }
}

// exception class
class ArrayException {
 private:
  std::string m_error;

 public:
  ArrayException(std::string_view error) : m_error{error} {}

  const std::string& getError() const { return m_error; }
};

class IntArray {
 private:
  int m_data[3]{};  // assume array is length 3 for simplicity

 public:
  IntArray() {}

  int getLength() const { return 3; }

  int& operator[](const int index) {
    if (index < 0 || index >= getLength()) {
      throw ArrayException{"Invalid index"};
    }

    return m_data[index];
  }
};

class Base {
 public:
  Base() {}
};

class Derived : public Base {
 public:
  Derived() {}
};

// Deriving your own classes from std::exception
class ArrayException1 : public std::exception {
 private:
  std::string m_error{};  // handle our own string

 public:
  ArrayException1(std::string_view error) : m_error{error} {}

  // std::exception::what() returns a const char*, so we must as well
  const char* what() const noexcept override { return m_error.c_str(); }
};

class IntArray1 {
 private:
  int m_data[3]{};  // assume array is length 3 for simplicity

 public:
  IntArray1() {}

  int getLength() const { return 3; }

  int& operator[](const int index) {
    if (index < 0 || index >= getLength())
      throw ArrayException("Invalid index");

    return m_data[index];
  }
};

void throwTheSameException() {
  try {
    throw Derived();
  } catch (Base& b) {
    throw;  // rethrowing the object
  }
}

// function level catch exception

int func() try {
  int b;
  int c;
  throw Derived();
} catch (const std::exception& e) {
  std::cerr << e.what() << '\n';
}

void doSomething() noexcept;  // this function is specified as non-throwing

void foo() { throw -1; }
void boo(){};
void goo() noexcept {};
struct S {};

constexpr bool b1{noexcept(5 + 3)};  // true; ints are non-throwing
constexpr bool b2{noexcept(foo())};  // false; foo() throws an exception
constexpr bool b3{noexcept(boo())};  // false; boo() is implicitly noexcept(false)
constexpr bool b4{noexcept(goo())};  // true; goo() is explicitly noexcept(true)
constexpr bool b5{noexcept(S{})};  // true; a struct's default constructor is noexcept by default

int main() {
  basic();
  IntArray array;

  try {
    int value{array[5]};  // out of range subscript
  } catch (const ArrayException&
               exception)  // reference. Catching exceptions by pointer should
                           // generally be avoided unless you have a specific
                           // reason to do so.
  {
    std::cerr << "An array exception occurred (" << exception.getError()
              << ")\n";
  }

  try {
    throw Derived();
  } catch (const Derived& derived)  // 先是派生类
  {
    std::cerr << "caught Derived";
  } catch (const Base& base)  // 才是基类
                              // Handlers for derived exception classes should
                              // be listed before those for base classes.
  {
    std::cerr << "caught Base";
  }

  // exception

  try {
    // code using standard library goes here
    throw std::runtime_error("Bad things happened");
  }
  // This handler will catch std::length_error (and any exceptions derived from
  // it) here
  catch (const std::length_error& exception) {
    std::cerr << "You ran out of memory!" << '\n';
  }
  // This handler will catch std::exception (and any exception derived from it)
  // that fall through here
  catch (const std::exception& exception) {
    std::cerr << "Standard exception: " << exception.what() << '\n';
  }
  return 0;
}
