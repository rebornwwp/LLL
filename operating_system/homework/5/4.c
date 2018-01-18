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
        printf("child process\n");
        execl("/bin/ls", "ls", "-l", (char*)NULL);
        char *args[] = {"ls", "-l", NULL};
        //execvp("ls", args);
    } else {
        wait(NULL);
        printf("parent process\n");
    }
    return 0;
}
