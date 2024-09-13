#include <termios.h>
#include "termops.h"

void
set_icanon(int fd)
{
        struct termios term;
        tcgetattr(0, &term);
        term.c_lflag |= ICANON;
        tcsetattr(fd, TCSAFLUSH, &term);
}


void
unset_icanon(int fd)
{
        struct termios term;
        tcgetattr(0, &term);
        term.c_lflag &= ~ICANON;
        tcsetattr(fd, TCSAFLUSH, &term);
}