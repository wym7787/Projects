#include "../include/hashftl.h"


Block *hash_block_gc(uint32_t lba, int32_t virtual_idx){

	Block *victim;
	Block *s_block;
	Block *res;
	
	Page *valid_p;

	int idx = 0;
	
	int16_t p_idx;
	int32_t segment_idx = virtual_idx / blocks_per_segment;

	victim = g_table[virtual_idx].p_block;
	s_block = shared_block[segment_idx];


	if(victim->p_offset != _PPB){
		g_table[virtual_idx].share = 0;
		return victim;
	}else{
		valid_p = (Page *)malloc(sizeof(Page) * _PPB);
		if(victim->invalid_cnt != 0){
			for(int i = 0 ; i < victim->p_offset; i++){
				if(victim->valid[i]){
					valid_p[idx].oob = victim->page[i].oob;
					idx++;
					gc_read++;
				}
			}

			block_erase_cnt++;
			block_reset(victim);
			res = (Block *)dequeue(bm->free_b);
			enqueue(bm->free_b, victim);

			for(int i = 0 ; i < idx; i++){
				p_idx = res->p_offset;
				res->page[p_idx].oob = valid_p[i].oob;
				res->valid[p_idx] = 1;
				hash_update_mapping(valid_p[i].oob, p_idx);
				res->p_offset++;
				gc_write++;
			}

			g_table[virtual_idx].share = 0;
			g_table[virtual_idx].p_block = res;
			free(valid_p);
			return res;

		}

		if(s_block->invalid_cnt != 0){
			for(int i = 0 ; i < s_block->p_offset; i++){
				if(s_block->valid[i]){
					valid_p[idx].oob = s_block->page[i].oob;
					idx++;
					gc_read++;
				}
			}

			block_erase_cnt++;
			block_reset(s_block);
			res = (Block *)dequeue(bm->free_b);
			enqueue(bm->free_b, s_block);

			for(int i = 0 ; i < idx; i++){
				p_idx = res->p_offset;
				res->page[p_idx].oob = valid_p[i].oob;
				res->valid[p_idx] = 1;
				hash_update_mapping(valid_p[i].oob, p_idx);
				res->p_offset++;
				gc_write++;
			}

			g_table[virtual_idx].share = 1;
			shared_block[segment_idx] = res;
			free(valid_p);
			return res;

		}
	}


}



