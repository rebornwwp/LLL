#ifndef TEMPLATE_H
#define TEMPLATE_H

namespace template_tp {
// their code isn’t compiled or executed directly.
// Instead, function templates have one job: to generate functions (that are
// compiled and executed). The process of creating functions (with specific
// types) from function templates (with template types) is called function
// template instantiation (or instantiation for short). When this process
// happens due to a function call, it’s called implicit instantiation. An
// instantiated function is often called a function instance (instance for
// short) or a template function. Function instances are normal functions in all
// regards. The process for instantiating a function is simple: the compiler
// essentially clones the function template and replaces the template type (T)
// with the actual type we’ve specified (int).
// TODO: How template works? 模板实例化过程与如何做编译的
// generic types generic programming
template <typename T>
T max(T x, T y) {
  return (x > y) ? x : y;
};

template <typename T>
int someFcn(T x, double y) {
  return 5;
}

// Functions templates with multiple template type parameters
// 返回类型不明确使用auto
template <typename T, typename U>
auto min(T x, U y) {
  return (x > y) ? y : x;
};
}  // namespace template_tp
#endif