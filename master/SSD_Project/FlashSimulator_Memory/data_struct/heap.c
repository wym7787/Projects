#include "../include/block.h"


void heap_swap(h_node *a, h_node *b){
	Block *ablock = (Block*)a->value;
	Block *bblock = (Block*)b->value;
	a->value = (void*)bblock;
	bblock->hn_ptr = a;
	b->value = (void*)ablock;
	ablock->hn_ptr = b;
}

void heap_change(Heap *heap, h_node *a, h_node *b){
	
	heap_swap(a, b);
	heap->body[heap->idx-1].value = NULL;
	heap->body[heap->idx-1].my_idx = -1;
	heap->idx--;
}




Heap *heap_init(int max_size){
	Heap *res = (Heap *)malloc(sizeof(Heap));
	res->body = (h_node *)malloc(sizeof(h_node) * max_size);
	res->idx = 0;
	res->max_size = max_size;
	memset(res->body, 0, sizeof(h_node) * max_size);
	for(int i = 0; i < max_size; i++){
		res->body[i].value = NULL;
		res->body[i].my_idx = i;
	}
	return res;
}
void heap_remove(Heap *h){
	Block *block;
	h_node *node;
	int heap_size = h->idx;
	for(int i = 0; i < heap_size ; i++){
		node = &h->body[i];
		block = (Block *)node->value;
		block->lba_idx = -1;
		block->hn_ptr = NULL;
		node->value = NULL;
		node->my_idx = -1;
		h->idx--;
	}

	return ;
}


void heap_free(Heap *insert){
	free(insert->body);
	free(insert);
}


void max_heapify(Heap* h){
	h_node *parents, *target;
	Block *p, *now;
//	printf("h->idx : %d\n",h->idx);
	for(int i = 1; i < h->idx; i++)
	{
		parents = &h->body[(i - 1)/2];
		target = &h->body[i];
		p = (Block*)parents->value;
		now = (Block*)target->value;
		if(now->invalid_cnt > p->invalid_cnt)
		{
			int j = i;
			while(now->invalid_cnt > p->invalid_cnt)
			{
				heap_swap(target, parents);
				j = (j - 1) / 2;
				parents = &h->body[(j - 1)/2];
				target = &h->body[j];
				p = (Block*)parents->value;
				now = (Block*)target->value;
			}
		}
	}
}
h_node* heap_insert(Heap *heap, Block *value){

	if(heap->idx == heap->max_size){
		printf("heap full!\n");
		exit(1);
	}
	heap->body[heap->idx].value = (void*)value;
	h_node *res = &heap->body[heap->idx];
	heap->idx++;
	return res;
}

Block* get_max_heap(Heap *heap){
	Block *first, *res;
	max_heapify(heap);
	res = (Block*)heap->body[0].value;
	res->hn_ptr = NULL;
	heap->body[0].value = heap->body[heap->idx - 1].value;
	heap->body[heap->idx - 1].value = NULL;
	first = (Block*)heap->body[0].value;
	first->hn_ptr = &heap->body[0];
	heap->idx--;
	return res;
}

void heap_print(Heap *h){ 
	int idx = 0; 
	while(h->body[idx].value){ 
		Block *temp=(Block*)h->body[idx].value; 
		printf("idx : %d block_idx: %d invalid:%d\n",idx,temp->pba_idx,temp->invalid_cnt);
		idx++; 
	} 
	printf("cnt: %d\n", idx); 
	printf("\n"); 
}

