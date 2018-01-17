#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char *argv[]) {
    printf("parent process\n");
    int pr = fork();
    int status;
    if (pr < 0) {
        perror("fork");
        exit(1);
    } else if (pr == 0) {
        int a = wait(NULL);
        printf("a = %d\n", a);
    } else {
        wait(NULL);
        printf("parent process\n");
    }
    return 0;
}
