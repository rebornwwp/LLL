#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    int rc = fork();
    int x = 100;
    printf("this x is %d.\n", x);
    if (rc < 0) { // fork failed; exit
        fprintf(stderr, "fork failed\n");
        exit(1);
    } else if (rc == 0) { // child: redirect standard output to a file
        printf("this is the child process\n");
        x = 10;
        printf("x = %d\n", x);
    } else { // parent
        printf("this is the parent process\n");
        x = 11;
        printf("x = %d\n", x);
    }
    return 0;
}
