#include "../include/zftl.h"

BM *bm;
Table *m_table;
Block *reserved_b;
//Normal request count variables
int32_t write_cnt;
int32_t read_cnt;

//GC I/O count variables;
int32_t gc_write;
int32_t gc_read;
int32_t block_erase_cnt;
int32_t not_found_cnt;

uint32_t lnb;
uint32_t mask;


void zftl_create(void){

	int nob = _NOB;
	int ppb = _PPB;
	//Setup mapping table
	
	
	lnb = L_DEVICE / (ppb * PAGESIZE);


	printf("------------- Zone-based FTL -------------\n");
//	printf("Num of logical block number : %d\n",lnb);
	m_table = (Table *)malloc(sizeof(Table) * lnb);
	for(int i = 0; i < lnb; i++){
		m_table[i].pba = -1;
		m_table[i].new_pba = -1;
		m_table[i].new_flag = 0;


		m_table[i].i_table = (I_table *)malloc(sizeof(I_table) * ppb);
		for(int j = 0 ; j < ppb; j++){
			m_table[i].i_table[j].p_idx = -1;
			m_table[i].i_table[j].b_bits = -1;
			m_table[i].i_table[j].flag = 0;
		}
		m_table[i].s_bits = -1;
	}

	//Setup Storage
	bm = storage_init(nob, ppb);	  //Set Device and heap data structure

	storage_info(bm);	
	reserved_b = &bm->block[nob-1];

	//Setup mask value for LSB bit extraction
	mask = (1<<LSB_RANGE);
	



	return ;
}

void zftl_destroy(void){

	double memory;
	printf("--------- Benchmark Result ---------\n\n");
	printf("Total request  I/O count : %d\n",write_cnt+read_cnt);
	printf("Total write    I/O count : %d\n",write_cnt);
	printf("Total read     I/O count : %d\n",read_cnt);
	printf("Total GC write I/O count : %d\n",gc_write);
	printf("Total GC read  I/O count : %d\n",gc_read);

	printf("Total Not found count    : %d\n",not_found_cnt);
	printf("Total block erase count  : %d\n",block_erase_cnt);
	if(write_cnt != 0)
		printf("Total WAF  : %.2lf\n",(float) (write_cnt+gc_write) / write_cnt);
//	if(read_cnt != 0)
//		printf("Total RAF  : %.2lf\n",(float) ((read_cnt+gc_read) / read_cnt));

	memory = (double) ((lnb * 8) + (LSB_RANGE * _PPB * lnb)/8);

	printf("Mapping Memory Requirement (MB) : %.2lf\n",memory/1024/1024);
	
	free(m_table);
	storage_free(bm);
	return ;
}

int32_t zftl_write(uint32_t lba){
	uint32_t block_idx;
	uint16_t l_offset, p_offset;
	uint32_t pba, ppa;
	Block *block;

	//printf("lba : %d\n",lba);
	l_offset = lba % mask;
	block_idx = (lba >> LSB_RANGE) % lnb; 
	ppa = ppa_alloc(lba);

	pba = ppa / _PPB;
	p_offset = ppa % _PPB;
	block = &bm->block[pba];

	//Set idx mapping table

	m_table[block_idx].i_table[l_offset].p_idx = ppa % _PPB;

	block->valid[p_offset] = 1;
	block->page[p_offset].oob = lba;

//	printf("oob : %d\n",block->page[p_offset].oob);
	write_cnt++;
	return 1;

}

int32_t zftl_read(uint32_t lba){
	uint32_t block_idx;
	uint16_t l_offset;
	int32_t pba;
	uint32_t ppa;
	int16_t p_idx;
	Block *block;

	l_offset  = lba % mask;
	block_idx = (lba >> LSB_RANGE) % lnb;

	if(!m_table[block_idx].i_table[l_offset].flag){
		pba = m_table[block_idx].pba;
	}else{
		pba = m_table[block_idx].new_pba;
	}

	p_idx = m_table[block_idx].i_table[l_offset].p_idx;
	if(p_idx == -1){
		not_found_cnt++;
		return 1;
	}

	block = &bm->block[pba];

	ppa = pba*_PPB + p_idx;
	//For check valid ppa
	
	
	if(block->page[p_idx].oob != lba){
		single_block_status(&bm->block[m_table[block_idx].pba]);
		if(m_table[block_idx].new_pba != -1){
		single_block_status(&bm->block[m_table[block_idx].new_pba]);
		}
		printf("ppa : %d\n",ppa);
		printf("pba : %d offset : %d\n",pba,p_idx);
		printf("lba : %d oob : %d\n",lba, block->page[p_idx].oob);
		printf("Invalid ppa error!\n");
		exit(0);
	}

	read_cnt++;
	return 1;
}







