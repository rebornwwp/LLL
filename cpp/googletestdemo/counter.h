#ifndef COUNTER_H
#define COUNTER_H

class Counter {
 private:
  /* data */
  int counter_;

 public:
  Counter() : counter_{0} {};
  int Increment();
  int Decrement();
  void Print() const;
};

#endif