#include "../include/hashftl.h"

uint32_t ppa_alloc(uint32_t lba){

	int32_t ppa;
	int32_t virtual_idx;
	int32_t segment_idx;
	bool flag;

	Block *block;

	virtual_idx = get_virtual_idx(lba);
	flag = check_block(virtual_idx);

	if(!flag){
		block = g_table[virtual_idx].p_block;
		ppa = block->pba_idx * _PPB + block->p_offset++;
		g_table[virtual_idx].share = 0;		
	}else{
		segment_idx = virtual_idx / blocks_per_segment;
		block = shared_block[segment_idx];
		if(block->p_offset == _PPB){
			block = hash_block_gc(lba, virtual_idx);
			ppa = block->pba_idx * _PPB + block->p_offset++;
		}else{
			ppa = block->pba_idx * _PPB + block->p_offset++;
			g_table[virtual_idx].share = 1;		
		}
	}
	check_mapping(lba, virtual_idx);
	p_table[lba].share = g_table[virtual_idx].share;
	return ppa;

}

int32_t get_virtual_idx(uint32_t lba){

	int32_t res;
	
	uint32_t lba_md5 = lba;
	size_t len = sizeof(lba_md5);
	uint64_t res_md5;

	md5(&lba_md5, len, &res_md5);	
	res = res_md5 % lnb;
	
	return res;
}


bool check_block(int32_t virtual_idx){
	Block *checker = g_table[virtual_idx].p_block;


	//If block offset is empty, return ppa;
	if(checker->p_offset == _PPB){
		return 1;
	}

	return 0;

}

int32_t check_mapping(uint32_t lba, int32_t virtual_idx){
	int32_t segment_idx = virtual_idx / blocks_per_segment;
	int16_t ppid;
	
	bool share;
	ppid = p_table[lba].ppid;
	share = p_table[lba].share;
	Block *block;


	if(ppid != -1){
		if(share){
			block = shared_block[segment_idx];

		}else{
			block = g_table[virtual_idx].p_block;
		}
		block->page[ppid].oob = -1;
		block->valid[ppid] = 0;
		block->invalid_cnt++;
	}


}

void hash_update_mapping(uint32_t lba, int16_t p_idx){
	p_table[lba].ppid = p_idx;
	return ;
}
