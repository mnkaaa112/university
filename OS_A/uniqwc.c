#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/uio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/wait.h>

int main(int argc, char *argv[]){
        if(argc!=2){
                printf("input is invalid\n");
                printf("ex) ./splitfile <input_file>");
                exit(1);
        }

        int p2c[2], c2p[2];
        char *input = argv[1];

        pid_t pid;
        int status;
        pipe(p2c);
if((pid = fork())==0){ //child -uniq
                close(c2p[0]);
                close(p2c[1]);

                if((p2c[0]=open(input, O_RDONLY))== -1){
                        perror("open input file");
                        exit(1);
                }
                dup2(p2c[0], 0);
                dup2(c2p[1], 1);
                close(p2c[0]);
                close(c2p[1]);
                if(execlp("uniq", "uniq", NULL)==-1){
                        perror("uniq");
                        exit(1);
                }
        }else if(pid>0){ //parent -wc
                close(p2c[0]);
                close(c2p[1]);

                wait(&status);
                dup2(c2p[0], 0);
                close(c2p[0]);
                close(p2c[1]);
                if(execlp("wc","wc", "-l", NULL)==-1){
                        perror("wc");
                        exit(1);
       }
        }else{
                perror("fork");
                exit(1);
        }

        return 0;
}
