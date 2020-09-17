#include "../include/zftl.h"
#if FIRST
Block *block_gc(void){
	Page *valid_p;
	Block *victim;
	Block *new_block;
	Block *res;
	int idx = 0;
	int16_t p_idx;
	uint32_t block_idx;
	uint32_t new_idx;
	valid_p = (Page *)malloc(sizeof(Page) * _PPB);


	victim = get_max_heap(bm->b_heap);

	block_idx = victim->lba_idx;
	res = reserved_b;

	if(victim->invalid_cnt == _PPB){
		block_reset(victim);
		reset_mapping_flag(block_idx);
		m_table[block_idx].pba = m_table[block_idx].new_pba;
		m_table[block_idx].new_pba = -1;
		block_erase_cnt++;
		reserved_b = victim;
		return res;
	}
	
	new_idx = m_table[block_idx].new_pba;
	new_block = &bm->block[new_idx];

	//Valid copy into memory (Read)
	for(int i = 0 ; i < victim->p_offset; i++){
		if(victim->valid[i]){
			valid_p[idx].oob = victim->page[i].oob;
			idx++;
			gc_read++;
		}
	}
	for(int i = 0 ; i < new_block->p_offset; i++){
		if(new_block->valid[i]){
			valid_p[idx].oob = new_block->page[i].oob;
			idx++;
			gc_read++;
		}
	}
	block_reset(victim);
	block_reset(new_block);
	block_erase_cnt += 2;


	//Valid copy into Flash (Write)
	for(int i = 0 ; i < idx; i++){
		p_idx = res->p_offset;
		res->page[p_idx].oob = valid_p[i].oob;
		res->valid[p_idx] = 1;
		update_mapping(valid_p[i].oob, p_idx);
		res->p_offset++;
		gc_write++;
	}

	reset_mapping_flag(block_idx);
	m_table[block_idx].pba = res->pba_idx;
	m_table[block_idx].new_pba = -1;
	res->lba_idx = block_idx;
	reserved_b = new_block;
	res = victim;

	
	free(valid_p);
	return res;


}
#endif

Block* block_migration(uint32_t block_idx, Block *new_block){

	Page *valid_p;
	Block *f_block, *s_block, *res;
	int32_t f_pba, s_pba, idx = 0;
	int32_t p_idx;
	f_pba = m_table[block_idx].pba;
	s_pba = m_table[block_idx].new_pba;

	f_block = &bm->block[f_pba];
	s_block = &bm->block[s_pba];
	Heap *h = bm->b_heap;
	heap_change(h, f_block->hn_ptr, &h->body[h->idx-1]);
	f_block->hn_ptr = NULL;

	valid_p = (Page *)malloc(sizeof(Page) * _PPB);
	if(new_block == NULL)
		res = reserved_b;
	else
		res = new_block;
	
	//If First block is all invalid pages, just erase block
	if(f_block->invalid_cnt == _PPB){
		block_reset(f_block);
		reset_mapping_flag(block_idx);
		m_table[block_idx].pba = s_pba;
		if(new_block != NULL)
			enqueue(bm->free_b, f_block);
		else
			reserved_b = f_block;

		s_block->hn_ptr = heap_insert(bm->b_heap, s_block);
		block_erase_cnt++;		
		m_table[block_idx].new_pba = res->pba_idx;
		m_table[block_idx].new_flag = 1;
		res->lba_idx = block_idx;
		free(valid_p);
		return res;
	}

	for(int i = 0 ; i < f_block->p_offset; i++){
		if(f_block->valid[i]){
			valid_p[idx].oob = f_block->page[i].oob;
			idx++;
			gc_read++;
		}
	}
	for(int i = 0 ; i < s_block->p_offset; i++){
		if(s_block->valid[i]){
			valid_p[idx].oob = s_block->page[i].oob;
			idx++;
			gc_read++;
		}
	}

	//write valid page copy into flash
	for(int i = 0 ; i < idx; i++){
		p_idx = res->p_offset;
		res->page[p_idx].oob = valid_p[i].oob;
		res->valid[p_idx] = 1;
		update_mapping(valid_p[i].oob, p_idx);
		res->p_offset++;
		gc_write++;
	}

	block_reset(f_block);
	block_reset(s_block);
	block_erase_cnt += 2;
	reset_mapping_flag(block_idx);


	m_table[block_idx].pba = res->pba_idx;
	m_table[block_idx].new_pba = -1;
	res->lba_idx = block_idx;

	free(valid_p);

	if(new_block != NULL){
		enqueue(bm->free_b, f_block);
		enqueue(bm->free_b, s_block);
	}else{
		reserved_b = f_block;
		enqueue(bm->free_b, s_block);
	}

	if(res->p_offset == _PPB){
		res->hn_ptr = heap_insert(bm->b_heap, res);
		res = (Block *)dequeue(bm->free_b);
		m_table[block_idx].new_pba = res->pba_idx;
		m_table[block_idx].new_flag = 1;
		res->lba_idx = block_idx;
	}
	return res;
}





