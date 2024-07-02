// ifndef macro make our header will be included once.  alternative solution:
// #pragma once . it is not an official part of C++ language this is called
// `header guards` which is preferred than `#program once`
#ifndef BASE_H
#define BASE_H
// Do not define functions in headers
// int identity(int x)
// {
//     return x;
// }

int identity(int x);

#endif
