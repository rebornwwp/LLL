
int add(int x, int y) { return x + y; }

namespace bar {
int add(int x, int y) { return ::add(x, y); }
namespace bar_nest {
int add(int x, int y) { return x + y; }
}  // namespace bar_nest
}  // namespace bar