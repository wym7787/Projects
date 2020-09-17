#include "../include/zftl.h"

#if FIRST
uint32_t ppa_alloc(uint32_t lba){
	Block *new_block;
	Block *f_block;
	Block *s_block;
	int32_t pba,ppa;
	int32_t f_pba, s_pba;
	
	int16_t l_offset   = lba % mask;
	uint32_t block_idx = (lba >> LSB_RANGE) % lnb;
	
	pba = check_block_mapping(block_idx);		
	//If block mapping table is first, just set physical new block
	if(pba == -1){
		new_block = (Block *)dequeue(bm->free_b);
		//If not exists free block in queue, trigger gc operation
		if(new_block == NULL){
			new_block = block_gc();
		}
		m_table[block_idx].pba = new_block->pba_idx;			
		new_block->lba_idx = block_idx;
		
		//new_block->hn_ptr = heap_insert(bm->b_heap, new_block);
		ppa = new_block->pba_idx * _PPB + new_block->p_offset++;
	}else{
		f_pba = m_table[block_idx].pba;
		s_pba = m_table[block_idx].new_pba;
		f_block = &bm->block[f_pba];
		if(s_pba != -1){
			s_block = &bm->block[s_pba];
			if(s_block->p_offset == _PPB){
				new_block = (Block *)dequeue(bm->free_b);
				new_block = block_migration(block_idx, new_block);
				ppa = new_block->pba_idx * _PPB + new_block->p_offset++;
			}else{
				ppa = s_block->pba_idx * _PPB + s_block->p_offset++;
			}
		}else{
			if(f_block->p_offset == _PPB){
				new_block = (Block *)dequeue(bm->free_b);
				if(new_block == NULL){
					new_block = block_gc();
				}
				m_table[block_idx].new_pba = new_block->pba_idx;
				m_table[block_idx].new_flag = 1;
				f_block->hn_ptr = heap_insert(bm->b_heap, f_block);
				ppa = new_block->pba_idx * _PPB + new_block->p_offset++;
				new_block->lba_idx = block_idx;
			}else{
				ppa = f_block->pba_idx * _PPB + f_block->p_offset++;
			}
		}
		check_idx_mapping(lba);
	}
	m_table[block_idx].i_table[l_offset].flag = m_table[block_idx].new_flag;
	

	return ppa;	
}
#endif
#if SECOND
uint32_t ppa_alloc(uint32_t lba){
}


#endif



int32_t check_block_mapping(uint32_t block_idx){

	return m_table[block_idx].pba;
}

void check_idx_mapping(uint32_t lba){
	Block *block;
	uint32_t block_idx;
	int16_t offset;
	int32_t ppa_idx;
	int32_t pba,new_pba;


	offset    = lba % mask;
	block_idx = (lba >> LSB_RANGE) % lnb; 
	new_pba = m_table[block_idx].new_pba;

	if(new_pba == -1){
		pba = m_table[block_idx].pba;
	}else{
		if(!m_table[block_idx].i_table[offset].flag){
			pba = m_table[block_idx].pba;
		}else{
			pba = m_table[block_idx].new_pba;
		}
	}

	block = &bm->block[pba];
	ppa_idx = m_table[block_idx].i_table[offset].p_idx;

	//If Mapping is already setup, invalid page
	if(ppa_idx != -1){
		block->valid[ppa_idx] = 0;
		block->page[ppa_idx].oob = -1;
		block->invalid_cnt++;
	}

	return ;
}

void reset_mapping_flag(uint32_t block_idx){

	m_table[block_idx].new_flag = 0;
	for(int i = 0 ; i < _PPB; i++){
		m_table[block_idx].i_table[i].flag = 0;
	}
	
	return ;
}

void update_mapping(uint32_t lba, uint32_t p_idx){
	uint32_t block_idx;
	uint16_t offset;

	offset = lba % mask;
	block_idx = (lba >> LSB_RANGE) % lnb;
	

	m_table[block_idx].i_table[offset].p_idx = p_idx;

	return ;

}
	






