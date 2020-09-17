#ifndef __INST_H
#define __INST_H

#include <stdint.h>
#define TRUE 1
#define FALSE 0

#define P 0
#define C 1

#define NUM_OF_REG 16
#define BUF_SIZE 50

#define ALU_TIME 1
#define M_READ_TIME 3
#define M_WRITE_TIME 1

#define IntAlu "IntAlu"
#define MemRead "MemRead"
#define MemWrite "MemWrite"



typedef struct INST{
	char type[10];
	int dest;
	int src1;
	int src2;
	int addr;
}INST;

typedef struct RSS{
	int rss_set;
	int rob_num;
	int time;
	char busy;
	char op[10];
	int q1;
	int q2;
	char f1;
	char f2;
	char execute_bit;
	struct RSS *next;
}RSS;

typedef struct RAT{
	int q;
	char valid;
}RAT;

typedef struct ROB{
	char op[10];
	int dest;
	char status;
	char use;
	char commit_bit;
}ROB;



int rss_check(RSS *, int);
int rss_time_set(RSS *);
int rob_check(ROB *, int);

//Linked List 
void linked_display(RSS **);
void appendNode(RSS **, RSS *);
RSS* deleteNode(RSS **);


#endif
