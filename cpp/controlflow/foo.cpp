int foo_g{110000};

namespace foo {
int add(int x, int y) { return x + y; }

// inline function
int my_min(int x, int y) { return (x < y) ? x : y; }

int my_max(int x, int y) { return (x < y) ? y : x; }
}  // namespace foo