#ifndef __QUEUE_H
#define __QUEUE_H

#include "inst.h"

//fetch queue
typedef struct queue {
	int rear;
	int front;
	int size;
	INST **arr;
	int *c_arr;
	
}Queue;


//fetch_queue function
void q_init(Queue *, int size);
void q_free(Queue *);
int is_empty(Queue *);
int is_full(Queue *);
void enqueue(Queue *, INST *);
INST* dequeue(Queue *);
void q_display(Queue *);

//Common_queue function
void c_q_init(Queue *, int);
void c_enqueue(Queue *, int);
int c_dequeue(Queue *);


#endif
