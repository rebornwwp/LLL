#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    int pr = fork();
    int status;
    if (pr < 0) {
        perror("fork");
        exit(1);
    } else if (pr == 0) {
        printf("hello\n");
    } else {
        while (waitpid (pr, &status, WNOHANG) == 0) {
            sleep(1);
        }
        printf("goodbye\n");
    }
    return 0;
}
