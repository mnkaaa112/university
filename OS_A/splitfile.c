#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/uio.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char *argv[]){
        if(argc != 5){
                printf("input is not appropriate.\n");
                printf("ex) ./splitfile <input_file> <output_file1> <output_file2> <split byte>\n");
        exit(1);
        }


        int ifd, ofd1, ofd2, split;
        char *input_file = argv[1];
        char *output_file1 = argv[2];
        char *output_file2 = argv[3];
        split = *argv[4]-39;

        char buffer1[BUFSIZ];
        char buffer2[BUFSIZ];

        if((ifd = open(input_file, O_RDONLY)) == -1){
                perror("open input file");
                exit(1);
        }
        if((ofd1 = open(output_file1, O_WRONLY | O_CREAT, 0666)) == -1){
                perror("open output file1");
                exit(1);
        }
        if((ofd2 = open(output_file2, O_WRONLY | O_CREAT, 0666)) == -1){
                perror("open output file2");
                exit(1);
        }

        if((read(ifd, buffer1, split))!= split){
                perror("read1");
                exit(1);
        }
        if(write(ofd1, buffer1, split)!=split){
                perror("write1");
                exit(1);
        }
        write(ofd1, "\n", 1);
        int index;
        if((index = lseek(ifd, split, SEEK_SET)) == -1){
                perror("lseek");
                exit(1);
        }
        int nbytes;
        nbytes = read(ifd, buffer2, sizeof(buffer2));
        if(write(ofd2, buffer2, nbytes) != nbytes){
                perror("write2");
                exit(1);
        }
  
        if(close(ifd)<0){
                perror("close input_file");
                exit(1);
        }
        if(close(ofd1)<0){
                perror("close output_file1");
                exit(1);
        }
        if(close(ofd2)<0){
                perror("close output_file2");
                exit(1);
        }

        return 0;
}
