#ifndef __BLOCK_H_
#define __BLOCK_H_

#include "settings.h"
//Data structure for Heap node
typedef struct {
	void *value;
	int my_idx;
}h_node;

 struct b_node {
	void *data;
	struct b_node *next;
};


typedef struct {
	int size;
	struct b_node *head;
	struct b_node *tail;
}Queue;

//Data structure for page
typedef struct{
	int32_t oob;
}Page;

//Data structure for block
typedef struct{
	uint32_t pba_idx;
	uint32_t lba_idx;
	uint32_t invalid_cnt;
	Page *page;
	bool *valid;
	uint16_t p_offset;
	h_node *hn_ptr;
	bool b_status;

}Block;

//Data structure for heap management
typedef struct {
	int idx;
	int max_size;
	h_node *body;
}Heap;


//Block manager data structure
typedef struct{
	Block *block;
	Heap *b_heap;
	Queue *free_b;
}BM;


//block.c
BM* storage_init(int,int);
void storage_free(BM *);
void storage_info(BM *);
BM *block_init(int32_t nob, int32_t ppb);
void block_free(BM *);
void block_status(BM *);
void single_block_status(Block *);
void block_reset(Block *);

//heap.c
Heap *heap_init(int);
void heap_free(Heap *);
void max_heapify(Heap *);
void heap_swap(h_node *, h_node *);
h_node *heap_insert(Heap *, Block *);
Block *get_max_heap(Heap *);
void heap_print(Heap *);
void heap_change(Heap *,h_node *, h_node *);
void heap_remove(Heap *);


//queue.c
void init_queue(Queue **);
void free_queue(Queue *);
void enqueue(Queue *, void *);
void *dequeue(Queue *);







#endif
