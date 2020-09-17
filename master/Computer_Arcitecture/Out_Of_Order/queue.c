#include <stdio.h>
#include <stdlib.h>
#include "queue.h"

void q_init(Queue *q, int size)
{	
	q->rear = 0;
	q->front = 0;
	q->size = 2 * size + 1;
	q->arr = (INST **)malloc(sizeof(INST *) * q->size);
	q->c_arr = NULL;
	return ;	
}
void c_q_init(Queue *q, int size)
{
	q->rear = 0;
	q->front = 0;
	q->size = size + 1;
	q->arr = NULL;
	q->c_arr = (int *)malloc(sizeof(int) * q->size);
}

void q_free(Queue *q)
{
	free(q);
}
int is_empty(Queue *q)
{
	return q->front == q->rear ? TRUE:FALSE;
}

int is_full(Queue *q)
{
	return (q->rear+1) % q->size == q->front ? TRUE:FALSE;
}

void enqueue(Queue *q, INST *inst)
{
	if(is_full(q))
	{
//		printf("Queue is full!!\n");
		return ;
	}
	else
	{	
		q->rear = (q->rear + 1) % q->size;
		q->arr[q->rear] = inst;
		return ;
	}
}

void c_enqueue(Queue *q, int set)
{
	if(is_full(q))
	{
//		printf("Queue is full!\n");
		return ;
	}
	else
	{
		q->rear = (q->rear + 1) % q->size;
		q->c_arr[q->rear] = set;
		return ;
	}
}


INST* dequeue(Queue *q)
{
	if(is_empty(q))
	{
		printf("Queue is empty!!\n");
		return NULL;
	}
	else
	{
		q->front = (q->front+1) % q->size;
		
	}

	return q->arr[q->front];
}
int c_dequeue(Queue *q)
{
	if(is_empty(q))
	{
		printf("Queue is empty!!\n");
		return -1;
	}
	else
	{
		q->front = (q->front+1) % q->size;
	}

	return q->c_arr[q->front];
}

/*
void q_display(Queue *q)
{
	int i;
	INST *tmp;
	for(i = 1 ; i < q->size+1; i++)
	{
		printf("type : %s\n",q->arr[i]->type);
	}	
}
*/



