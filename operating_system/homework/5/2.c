#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    FILE* fp;
    fp = fopen("input.txt", "w");
    int pr = fork();
    if (pr < 0) {
        perror("fork");
        exit(1);
    } else if (pr == 0) {
        printf("child process\n");
        char child_str[] = "this is the child process!\n";
        fwrite(child_str, 1, sizeof(child_str), fp);
    } else {
        printf("this is parent process\n");
        char parent_str[] = "this is the parent process!\n";
        fwrite(parent_str, 1, sizeof(parent_str), fp);
    }
    fclose(fp);
    return 0;
}
