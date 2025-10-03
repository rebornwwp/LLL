#ifndef BAR_H
#define BAR_H
namespace bar {
constexpr double e{2.7};
int add(int, int);
namespace bar_nest {
int add(int, int);
}
}  // namespace bar
#endif