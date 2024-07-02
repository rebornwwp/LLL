#ifndef VIRTUAL_H
#define VIRTUAL_H

namespace class_ns {
class base {
 public:
  virtual void print();
  void show();
};

class derived : public base {
 public:
  void print();
  void show();
};

}  // namespace class_ns

#endif