#include <iostream>
#include <string>

class Person {
 private:
  std::string m_name{};
  int m_age{};

 public:
  Person(const std::string &name = "", int age = 0)
      : m_name{name}, m_age{age} {}
  ~Person() {}
  const std::string &getName() const { return m_name; }
  void setName(const std::string &name) { m_name = name; }
  int getAge() const { return m_age; }
};

class BaseballPlayer : public Person {
 public:
  double m_battingAverage{};

  BaseballPlayer(double x) : m_battingAverage{x} {}
};

class Base {
 public:
  int m_public{};  // can be accessed by anybody
 protected:
  int m_protected{};  // can be accessed by Base members, friends, and derived
                      // classes
 private:
  int m_private{};  // can only be accessed by Base members and friends (but not
                    // derived classes)
};

class Derived : public Base {
 public:
  Derived() {
    m_public = 1;  // allowed: can access public base members from derived class
    m_protected =
        2;  // allowed: can access protected base members from derived class
    // m_private = 3;   // not allowed: can not access private base members from
    // derived class
  }
};

class Animal {
 protected:
  std::string m_name;

  // We're making this constructor protected because
  // we don't want people creating Animal objects directly,
  // but we still want derived classes to be able to use it.
  Animal(const std::string &name) : m_name{name} {}

 public:
  const std::string &getName() const { return m_name; }
  virtual std::string_view speak() const { return "???"; }
};

class Cat : public Animal {
 public:
  Cat(const std::string &name) : Animal{name} {}

  virtual std::string_view speak() const { return "Meow"; }
};

class Dog : public Animal {
 public:
  Dog(const std::string &name) : Animal{name} {}

  virtual std::string_view speak() const { return "Woof"; }
};

void report(const Animal &animal) {
  std::cout << animal.getName() << " says " << animal.speak() << '\n';
}

template <typename T, int size>  // size is an integral non-type parameter
class StaticArray {
 private:
  // The non-type parameter controls the size of the array
  T m_array[size]{};

 public:
  T *getArray();

  T &operator[](int index) {
    std::cout << size << "\n";
    return m_array[index];
  }
};

// Showing how a function for a class with a non-type parameter is defined
// outside of the class
template <typename T, int size>
T *StaticArray<T, size>::getArray() {
  return m_array;
}

int main() {
  BaseballPlayer joe{10};
  joe.setName("Joe");
  std::cout << joe.getName() << "\n";
  std::cout << joe.m_battingAverage << "\n";

  Base base{};
  Derived derived{};
  std::cout << derived.m_public << "\n";
  std::cout << base.m_public << "\n";
  // base.m_protected; wrong
  // derived.m_protected; wrong

  try {
    throw -1;
  } catch (int x) {
    std::cerr << "exception: " << x << '\n';
  } catch (double x) {
    std::cerr << "exception double" << x << "\n";
  }

  Cat cat{"Fred"};
  Dog dog{"Garbo"};

  report(cat);
  report(dog);

  StaticArray<int, 12> intArray;
  std::cout << intArray[0] << "\n";

  return 0;
}