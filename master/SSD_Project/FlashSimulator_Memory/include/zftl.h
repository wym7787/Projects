#ifndef __ZFTL_H_
#define __ZFTL_H_

#include "block.h"

typedef struct {
	int16_t p_idx;
	int8_t b_bits;
	bool flag;
}I_table;

typedef struct {
	int32_t pba;
	int32_t new_pba;
	I_table *i_table;
	Block *b_pointer;
	int8_t s_bits;
	bool new_flag;
}Table;



extern BM *bm;
extern Table *m_table;
extern Block *reserved_b;

//zoneftl.c
extern int32_t write_cnt;
extern int32_t read_cnt;
extern int32_t gc_write;
extern int32_t gc_read;
extern int32_t block_erase_cnt;
extern int32_t migration_cnt;
extern uint32_t mask;
extern uint32_t lnb;




void zftl_create(void);
void zftl_destroy(void);
int32_t zftl_read(uint32_t lba);
int32_t zftl_write(uint32_t lba);


//zftl_util.c
uint32_t ppa_alloc(uint32_t);
int32_t check_block_mapping(uint32_t);
void check_idx_mapping(uint32_t);
void update_mapping(uint32_t, uint32_t);
void reset_mapping_flag(uint32_t);

//gc.c
Block* block_gc(void);
Block* block_migration(uint32_t, Block *); 



//hash.c
uint32_t j_hashing(uint32_t, uint32_t);
void md5(uint32_t *, size_t, uint64_t *);





#endif
