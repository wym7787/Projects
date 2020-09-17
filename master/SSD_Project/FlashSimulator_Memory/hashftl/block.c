#include "../include/block.h"


BM *storage_init(int nob, int ppb){
	return block_init(nob, ppb);

}
void storage_free(BM *bm){
	return block_free(bm);
}
void storage_info(BM *bm){
	int nob = _NOB;
	int nop = _NOP;
	
	printf("--------------- Storage Information --------------\n\n");
	printf("Storage Capacity (GB) : %ld\n", GIGAUNIT);
	printf("Storage Pagesize (KB) : %d\n",PAGESIZE/1024);
	if(_PPB > 1<<7)
		printf("Storage Num of block(SuperBlock) : %d\n",nob);
	else
		printf("Storage Num of block(NormalBlock) : %d\n",nop);

	printf("Storage Page per block : %d\n",_PPB);
	printf("Storage Num of page : %d\n",nop);

	return ;
}


BM *block_init(int nob, int ppb){
	BM *res = (BM *)malloc(sizeof(BM));

	//Data structure for block memory allocation
	res->block = (Block *)malloc(sizeof(Block) * nob);
	for(int i = 0; i < nob; i++){
		res->block[i].pba_idx = i;
		res->block[i].lba_idx = -1;
		res->block[i].invalid_cnt = 0;
		res->block[i].page = (Page *)malloc(sizeof(Page) * ppb);
		res->block[i].valid = (bool *)malloc(sizeof(bool) * ppb);
		res->block[i].p_offset = 0;
		res->block[i].hn_ptr = NULL;	
		res->block[i].b_status = 0;
		memset(res->block[i].page, -1, sizeof(Page) * ppb);
		memset(res->block[i].valid, 0, sizeof(bool) * ppb);
		/*	
		for(int j = 0; j < ppb; j++){
			printf("block[%d].oob[%d] = %d\n",i,j,res->block[i].page[j].oob);
		}
		exit(0);
		*/
	}

	res->b_heap = heap_init(nob);
	init_queue(&res->free_b);	
	
	/*
	for(int i = 0 ; i < nob; i++){
		enqueue(res->free_b, &res->block[i]);
	}
	*/
	return res;
}

void block_free(BM *bm){
	for(int i = 0 ; i < _NOB; i++){
		free(bm->block[i].page);
		free(bm->block[i].valid);
	}

	free(bm->block);
	free(bm->b_heap);
	free_queue(bm->free_b);
	free(bm);

	return ;
}

void block_reset(Block *block){
	block->invalid_cnt = 0;
	block->p_offset = 0;
	block->lba_idx = -1;
	memset(block->page, -1, sizeof(Page) * _PPB);
	memset(block->valid, 0, sizeof(bool) * _PPB);

	return ;
}


void block_status(BM *bm){

	printf("---------- Block invalid count ---------- \n");
	for(int i = 0 ;i < _NOB; i++){	
		printf("block[%d].p_offset : %d\n",i,bm->block[i].p_offset);
	}

}

void single_block_status(Block *block){
	printf("Physical block number : %d\n",block->pba_idx);
	printf("Invalid_cnt : %d\n",block->invalid_cnt);
	printf("Curruent offset : %d\n",block->p_offset);

	for(int i = 0 ; i < _PPB; i++){
		printf("block[%d][%d].oob = %d\n",i,block->valid[i],block->page[i].oob);
	}

	return ;
}


