#include "../include/block.h"

void init_queue(Queue **q){
	*q=(Queue*)malloc(sizeof(Queue));
	(*q)->size=0;
	(*q)->head=(*q)->tail=NULL;
}

void enqueue(Queue* q, void* data){
	struct b_node *new_node=(struct b_node *)malloc(sizeof(struct b_node));
	new_node->data = data;
	new_node->next=NULL;
	if(q->size==0){
		q->head = q->tail = new_node;
	}
	else{
		q->tail->next = new_node;
		q->tail = new_node;
	}
	q->size++;
}

void* dequeue(Queue *q){
	if(!q->head || q->size==0){
		return NULL;
	}
	struct b_node *target_node;
	target_node = q->head;
	q->head = q->head->next;

	void *res=target_node->data;
	q->size--;
	free(target_node);
	return res;
}

void free_queue(Queue *q){
	while(dequeue(q)){}
	free(q);
}
