#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <time.h>
#include <string.h>
#include <sys/ioctl.h>
#define BUFF_SIZE 4096
#define SIZE 1024*1024*512/4096

struct info{
	unsigned long real_file;
	unsigned long com_file;
	unsigned long write_count;
	unsigned long read_count;
};

int main(){
    char buf[BUFF_SIZE];
    int loop = 0, random = 0;
    int fd1 = 0, fd2 = 0, dev = 0;
    ssize_t rd_size;
    struct info *info;
    int n = 1024*1024;
    info = (struct info *)malloc(sizeof(struct info));
    clock_t start,end, write_start, write_end, read_start, read_end;
    srand(time(NULL));
    if((dev = open("/dev/sbulla",O_RDWR)) < 0){
        printf("Device open error\n");
        exit(1);
    }
    start = clock();
    write_start = clock();
    if(0 < (fd1 = open("sample1",O_RDONLY))){
        while( 0 < (rd_size = read(fd1, buf, BUFF_SIZE))){
            if(write(dev, buf, rd_size) < 0){
                perror("Write error");
                exit(1);
            }
            random = rand()%10000000;
            lseek(fd1, random, SEEK_SET);
            if(random >= 95536){
                lseek(fd1, 0, SEEK_SET);
            }
            if(loop % 1000 == 0){
                printf("sample 1, write : %d/65536\n",loop);
            }
            if(loop == 65537){
                break;
            }
            loop += 1;
        }
    }else{
        printf("sample1 open error\n");
        exit(1);
    }
    printf("Sample1 write finish\n");
    loop = 0;
    if(0 < (fd2 = open("sample2",O_RDONLY))){
        while( 0 < (rd_size = read(fd2, buf, BUFF_SIZE))){
            if(write(dev, buf, rd_size) < 0){
                perror("Write error");
                exit(1);
            }
            random = rand()%10000000;
            lseek(fd2, random, SEEK_SET);
            if(random >= 95536){
                lseek(fd2, 0, SEEK_SET);
            }
            if(loop % 1000 == 0){
              printf("sample 2, write : %d/65536\n", loop);
            }
            if(loop == 65537){
                break;
            }
            loop += 1;
        }
    }else{
        printf("sample2 open error\n");
        exit(1);
    }
    write_end = clock();
    printf("Sample2 write finish\n");
    read_start = clock();
    close(dev);
    if((dev = open("/dev/sbulla",O_RDWR)) < 0){
	printf("Device open error!\n");
	exit(1);
    }
    for(loop = 0; loop < SIZE; loop++){
        if(read(dev, buf, BUFF_SIZE) < 0){
            perror("Read error");
            exit(1);
        }
        if(loop % 1000 == 0){
            printf("Read : %d/131072\n",loop);
        }
    }
    ioctl(dev, 0, info);
    read_end = clock();
    end = clock();
    printf("Read finish\n");
    close(fd1);
    close(fd2);
    close(dev);
    printf("Result\n");
    printf("User Capacity    : %ldMB\n",info->real_file / n);
    printf("Stored Capacity  : %ldMB\n",info->com_file / n);
    printf("I/O Count : Read - %ld, Write - %ld\n",info->read_count, info->write_count);
    printf("Write time : %.3lf ms\n",(float)(write_end - write_start)*1000/CLOCKS_PER_SEC);
    printf("Read time : %.3lf ms\n",(float)(read_end-read_start)*1000/CLOCKS_PER_SEC);
    printf("Run time : %.3lf ms\n",(float)(end-start)*1000/CLOCKS_PER_SEC);
    free(info);



}
