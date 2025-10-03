#ifndef CLASS_H
#define CLASS_H
#include <iostream>
namespace class_ns {
class DataClass {
 private:
  // private member with default value
  int prive_value{10};
  int *my_array{};

 public:
  int m_year;
  int m_month;
  int m_day;

  // share the same s_value cross all instances of DataClass
  static int s_value;

  // const标识，可以让const的对象可以访问
  void hello() const;
  void set_private(int x);
  void hello(int x);
  void increment();
  // 与python的static函数一样可以直接使用
  static void static_hello() { std::cout << "static hello\n"; };
  DataClass();
  DataClass(int y, int m, int d);
  DataClass(int m, int d);
  ~DataClass();

  // access the private and protected members
  friend void reset_private(int x);
};
}  // namespace class_ns
#endif