#include "../include/hashftl.h"

BM *bm;
Block *reserved_b;

Block **shared_block;

h_table *p_table;
v_table *g_table;

int32_t write_cnt;
int32_t read_cnt;
int32_t gc_write;
int32_t gc_read;
int32_t block_eranse_cnt;
int32_t not_found_cnt;

uint32_t lnb;
uint32_t lnp;
int num_op_blocks;
int blocks_per_segment;
int max_segment;






void hash_create(void){

	int nob = _NOB;
	int ppb = _PPB;
	lnb = L_DEVICE / (ppb * PAGESIZE);
	lnp = L_DEVICE / PAGESIZE;

	printf("------------------- Hash-based FTL ------------------\n");

	//Setup mapping table;
	p_table = (h_table *)malloc(sizeof(h_table) * lnp);
	g_table = (v_table *)malloc(sizeof(v_table) * lnb);
	for(int i = 0 ; i < lnb; i++){
		g_table[i].p_block = NULL;
		g_table[i].s_block = NULL;
		g_table[i].share = 0;
	}
	for(int i = 0 ; i < lnp; i++){
		p_table[i].ppid = -1;
		p_table[i].update = 0;
		p_table[i].share = 0;
	}
	num_op_blocks = nob - lnb;
	blocks_per_segment = ceil((lnb/num_op_blocks)) + 1;
	max_segment = lnb/blocks_per_segment + 1;
	
	shared_block = (Block **)malloc(sizeof(Block *) * max_segment);
	printf("Total Num op blocks : %d\n", num_op_blocks);
	printf("Blocks per segment : %d\n",blocks_per_segment);
	printf("Max segment count : %d\n",max_segment);
	printf("Total logical num of pages  : %d\n",lnp);
	printf("Total logical num of blocks : %d\n",lnb); 

	bm = storage_init(nob, ppb);
	//Virtual to Physical block mapping
	for(int i = 0 ; i < lnb; i++){
		g_table[i].p_block = &bm->block[i];
	}

	//Set shared blocks
	int idx;
	
	for(int i = 0 ; i < max_segment; i++){
		idx = lnb + i;
		shared_block[i] = &bm->block[idx];
	}
	printf("idx : %d\n",idx);
	//Set queue for reserved blocks
	for(int i = idx+1; i < nob; i++){
		enqueue(bm->free_b, &bm->block[i]);
	}

	
	
	
	storage_info(bm);

	

}


void hash_destroy(void){
	double memory;
	printf("--------- Benchmark Result ---------\n\n");
    printf("Total request  I/O count : %d\n",write_cnt+read_cnt);
    printf("Total write    I/O count : %d\n",write_cnt);
    printf("Total read     I/O count : %d\n",read_cnt);
    printf("Total GC write I/O count : %d\n",gc_write);
    printf("Total GC read  I/O count : %d\n",gc_read);
	printf("Total Not found count    : %d\n",not_found_cnt);
	printf("Total erase count        : %d\n",block_erase_cnt);
	if(write_cnt != 0)
		printf("Total WAF  : %.2lf\n",(float) (write_cnt+gc_write) / write_cnt);

	memory = (double) ((lnp * 10)/8 + (lnb * 4));
	printf("Mapping memory Requirement (MB) : %.2lf\n",memory/1024/1024);

	free(p_table);
	free(g_table);
	free(shared_block);
	storage_free(bm);

	return ;
}

int32_t hash_write(uint32_t lba){

	Block *block;
	uint32_t pba, ppa;
	int16_t p_idx;
	ppa = ppa_alloc(lba);

	pba = ppa / _PPB;
	p_idx = ppa % _PPB;
	block = &bm->block[pba];


	p_table[lba].ppid = p_idx;
	block->valid[p_idx] = 1;
	block->page[p_idx].oob = lba;

	write_cnt++;
	return 1;
}


int32_t hash_read(uint32_t lba){
	Block *block;
	int16_t p_idx;
	int32_t virtual_idx;
	int32_t segment_idx;
	bool share = p_table[lba].share;

	virtual_idx = get_virtual_idx(lba);
	if(!share){
		block = g_table[virtual_idx].p_block;
	}else{
		segment_idx = virtual_idx / blocks_per_segment;
		block = shared_block[segment_idx];
	}
	p_idx = p_table[lba].ppid;
	if(p_idx == -1)
		return 1;


	if(block->page[p_idx].oob != lba){
		printf("Page offset : %d\n",p_idx);
		printf("oob : %d lba : %d\n",block->page[p_idx].oob, lba);
		printf("ppa allocation error!\n");
		exit(0);
	}
	read_cnt++;
	return 1;
}
