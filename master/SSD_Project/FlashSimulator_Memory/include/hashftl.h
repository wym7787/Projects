#ifndef __HASHFTL_H_
#define __HASHFTL_H_

#include "block.h"

#define H_BIT 2
#define NUM_HASH (1 << H_BIT)

typedef struct {
	int16_t ppid;
	bool update;
	bool share;
}h_table;

typedef struct {
	Block *p_block;
	Block *s_block;
	bool share;
}v_table;


//hashftl.c
extern BM *bm;
extern Block **shared_block;
extern Block *reserved_b;

extern h_table *p_table;
extern v_table *g_table;
extern int32_t write_cnt;
extern int32_t read_cnt;
extern int32_t gc_write;
extern int32_t gc_read;
extern int32_t block_erase_cnt;
extern int32_t not_found_cnt;
extern uint32_t lnb;
extern uint32_t lnp;
extern int num_op_blocks;
extern int blocks_per_segment;
extern int max_segment;


void hash_create(void);
void hash_destroy(void);
int32_t hash_read(uint32_t);
int32_t hash_write(uint32_t);

//hashftl_util.c

uint32_t ppa_alloc(uint32_t);
int32_t get_virtual_idx(uint32_t);
bool check_block(int32_t virtual_idx);
int32_t check_mapping(uint32_t lba, int32_t virtual_idx);
void hash_update_mapping(uint32_t lba, int16_t p_idx);

//gc.c
Block *hash_block_gc(uint32_t lba, int32_t virtual_idx);



//data_struct/hash.c
uint32_t j_hashing(uint32_t, uint32_t);
void md5(uint32_t *, size_t, uint64_t *);



#endif
