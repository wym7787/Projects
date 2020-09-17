#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>

#define CONFIG_FILE "config"

int count = 0;
//Cache States
int total_accesses, read_accesses, write_accesses; 	  //Access Part
int read_misses, write_misses;			 	  //Miss Part
int clean_evics, dirty_evics;				  //eviction Part
double read_rate, write_rate;			          //Ratio Part
uint64_t checksum;				          //Checksum

//Cache States2
int capacity, ways, b_size;
int cache_line;
int policy;
//Cache Index box
typedef struct Cache
{
	struct Info *cont;
	int *lru_list;
	int *p_bit;
}Cache;

//Cache contents
struct Info
{
	uint64_t tag;
	int valid;
	int dirty;
};

//program value
int p_value = 0;

void cache_init(Cache *, int, int);
void cache_process(Cache *, int, int, int, char *);
void cache_request(Cache*, uint64_t, int, int, char *);
void cache_free(Cache *, int);

//Pseudo LRU
void p_cache_request(Cache *, uint64_t, int, int, char *);
int p_hit_search(Cache *, uint64_t, int, int);
int p_evic_search(Cache *,uint64_t, int, int);

uint64_t cal_checksum(Cache *,int, int);
uint64_t get_tag(uint64_t, int, int);
int get_idx(uint64_t, int, int);
int get_config(FILE *);
int bit_count(int);

void print_dirty(Cache*,int,int);
void file_print(char *);
int main(int argc, char **argv)
{
	//Cache stats

	Cache *cache = NULL;
	int index_num, ways_num;
//	char *trace_name = "ping_trace.out";
//	char *p_output_name = "ping_trace";
	
	FILE *c_fp = fopen(CONFIG_FILE, "r");
	
	char *file_name[6];	
	char *output_name[6];	
	file_name[0] = "400_perlbench.out";
	file_name[1] = "450_soplex.out";
	file_name[2] = "453_povray.out";
	file_name[3] = "462_libquantum.out";
	file_name[4] = "473_astar.out";
	file_name[5] = "483_xalancbmk.out";

	output_name[0] = "perlbench";
	output_name[1] = "soplex";
	output_name[2] = "povray";
	output_name[3] = "libquantum";
	output_name[4] = "astar";
	output_name[5] = "xalancbmk";


	if(c_fp == NULL)
	{
		printf("config_file open error!\n");
		exit(0);
	}
	/*	
	if(argc != 4)
	{
		printf("Argument error!!\n");
		exit(0);
	}
	*/

	//Cache Setting
	printf("Cache Setting Start!!\n"); 
	
	if(get_config(c_fp))
	{
		printf("Config get success!!\n");
		fclose(c_fp);	
	}
	/*
	capacity = atoi(argv[1]) * 1024;	 //Cache size
	ways = atoi(argv[2]);           	 //Ways
	b_size = atoi(argv[3]);         	 //block_size;
	*/

	cache_line = capacity / b_size;  	 //Cache_line;
	index_num = cache_line / ways;  	 //Num of Cache index
	ways_num = ways;                	 //Num of ways
	printf("Cache Setting End!!\n");
	int num = 0;
	while(1)
	{	
		if(!p_value)
		{
			printf("1. PURE_LRU 2. PSEUDO_LRU 3.Exit\n");
			printf("Policy Choice : ");
			scanf("%d",&policy);
			p_value = 1;
			
		}

		cache = (Cache *)malloc(sizeof(Cache) * index_num);
		cache_init(cache, index_num, ways_num);  
		if(policy == 1)
		{
			cache_process(cache, index_num, ways_num, b_size, file_name[num]);
		}
		else if(policy == 2)
		{
			if(ways < 2)
			{
				printf("Check ways configuration!!\n");
				p_value = 0;
				continue;
			}
			cache_process(cache, index_num, ways_num, b_size, file_name[num]);		
		}
		else if(policy == 3)
		{
			printf("Cache Test exit!!\n");
			break;
		}
		else
		{
			printf("Cache Erorr --Cache restart--\n");
			continue;
		}
		//Cache result caculation

		total_accesses = write_accesses + read_accesses;
		read_rate = (double) read_misses / read_accesses * 100;
		write_rate = (double) write_misses / write_accesses * 100;
		checksum = cal_checksum(cache, index_num, ways_num);
			
		printf("-- General Stats --\n");
		printf("File_name = %s\n",file_name[num]);
		printf("Capacity : %d\n", capacity / 1024);
		printf("Way : %d\n",ways);
		printf("Block size: %d\n", b_size);
		printf("Total accesses : %d\n", total_accesses);
		printf("Read accesses : %d\n", read_accesses);
		printf("Write accesses : %d\n", write_accesses);
		printf("Read misses : %d\n", read_misses);
		printf("Write misses : %d\n", write_misses);
		printf("Read miss rate : %lf\n", read_rate);
		printf("Write miss rate : %lf\n", write_rate);
		printf("Clean evictions : %d\n", clean_evics);
		printf("Dirty evictions : %d\n", dirty_evics);
		printf("Checksum : 0x%llx\n", checksum);
		//print_dirty(cache,index_num,ways_num);
	
		free(cache);
		
		//if you want to ping_trace.out, change the code below	
		file_print(output_name[num]);
	
		//For ping_trace.out break code
		//break;

		num++;
		if(num == 6)
		{
			num = 0;
			p_value = 0;
		}
		//remove end code
	}
	return 0;
	
}


void cache_init(Cache *cache, int index_num, int ways_num)
{
	int i,j;
	
	for(i = 0 ; i < index_num ; i++)
	{
		cache[i].cont = (struct Info *)malloc(sizeof(struct Info) * ways_num);
		cache[i].lru_list = (int *)malloc(sizeof(int) * ways_num);
		cache[i].p_bit = (int *)malloc(sizeof(int) * (ways_num-1));
		for(j = 0 ; j < ways_num ; j++)
		{
			cache[i].cont[j].tag = -1;
			cache[i].cont[j].valid = 0;
			cache[i].cont[j].dirty = 0;
			cache[i].lru_list[j] = -1;
		}
		for(j = 0 ; j < ways_num - 1 ; j++)
		{
			cache[i].p_bit[j] = 0;
		}
		
	}
	total_accesses = 0;
	write_accesses = 0;
	read_accesses = 0;
	read_misses = 0;
	write_misses = 0;
	read_rate = 0.0;
	write_rate = 0.0;
	clean_evics = 0;
	dirty_evics = 0;
	checksum = 0;

}
void cache_process(Cache *cache, int index_num, int ways_num, int b_size, char *file_name)
{
	char buf[256];
	char cmd[2];
	uint64_t addr;
	
	uint64_t i_tag;
	int index;
	FILE *fp = fopen(file_name, "r");
	
	int cmd_count = 0;
	while(fgets(buf,sizeof(buf),fp) != NULL)
	{
		char *ptr = strtok(buf," ");
		strcpy(cmd, ptr);
		ptr = strtok(NULL," ");
		addr = strtoull(ptr, NULL, 16);
		
//		printf("%s %llx\n",cmd, addr);
		i_tag = get_tag(addr,b_size,index_num);
		index = get_idx(addr,b_size,index_num);	

		//printf("index = %d tag = %llx\n", index, i_tag);
		if(index == -1)
		{
			 printf("Index Overflow..\n");
			 exit(0);
		}	
		//Cache Write
		if(!strcmp(cmd,"W"))
		{
			
			write_accesses++;
			if(policy == 1)
				cache_request(cache, i_tag, index, ways_num, cmd);
			else
				p_cache_request(cache, i_tag, index, ways_num, cmd);	
		}
		//Cache Read	
		else
		{
			read_accesses++;
			if(policy == 1)
				cache_request(cache, i_tag, index, ways_num, cmd);
			else
				p_cache_request(cache, i_tag, index, ways_num, cmd);
		}	
		
		cmd_count++;
	}
	
	fclose(fp);
	
}


void cache_request(Cache *cache, uint64_t i_tag, int index, int ways_num, char *cmd)
{
	int i;
	
	int h_offset = -1;
	int evic_offset = -1;

	int lru_point = 0;
	int mru_point = ways_num - 1;
	/*
	uint64_t tmp_tag;
	int tmp_valid;
	int tmp_dirty;
	*/

	//Cache hit check
	for(i = 0; i < ways_num; i++)
	{
	//	printf("test tag = %llx\n",cache[index].cont[i].tag);
	//	printf("i_tag = %llx\n",i_tag);
		if(cache[index].cont[i].tag == i_tag)
		{
	//		printf("Cache hit!!\n");
	//		printf("index = %d tag = %llx\n", index, i_tag);
			h_offset = i;
			break;
		}
	}
	//Cache hit
	if(h_offset != -1)
	{
		int update_offset;
		for(i = 0 ; i < ways_num; i++)
		{
			if(cache[index].lru_list[i] == h_offset)
			{
				update_offset = i;
				break;
			}
		}
		//LRU_List update
		//printf("update_offset = %d\n",update_offset);
		for(i = update_offset; i < ways_num -1 ; i++)
		{
			cache[index].lru_list[i] = cache[index].lru_list[i+1];
		}
		cache[index].lru_list[mru_point] = h_offset;
	
			
		if(!strcmp(cmd,"W"))
			cache[index].cont[h_offset].dirty = 1;
		
		
		return ;		
	
	}
	//Cache miss
	else
	{
		
		//Cache first access check
		for(i = 0 ; i < ways_num; i++)
		{
			if(cache[index].cont[i].valid == 0)
			{
				evic_offset = i;
				break;	
			}
		}
		//Not first miss
		if(evic_offset == -1)
		{
			//LRU position eviction
			evic_offset = cache[index].lru_list[lru_point];

			if(cache[index].cont[evic_offset].dirty)
			{
				dirty_evics++;
			}
			else
			{
				clean_evics++;
			}
	
		}
			//printf("i_offset = %d\n",i_offset);	
		
		//Cache put information
		cache[index].cont[evic_offset].tag = i_tag;
		cache[index].cont[evic_offset].valid = 1;
	
		//LRU_list update
		for(i = 0 ; i < ways_num - 1; i++)
		{
			cache[index].lru_list[i] = cache[index].lru_list[i+1];
		}
		cache[index].lru_list[mru_point] = evic_offset;
			
		if(!strcmp(cmd,"W"))
		{
			cache[index].cont[evic_offset].dirty = 1;
			write_misses++;
			
		}
		else
		{
			cache[index].cont[evic_offset].dirty = 0;
			read_misses++;
		}					
	}

	return ;

}

void p_cache_request(Cache *cache, uint64_t i_tag, int index, int ways_num, char *cmd)
{
	int hit_offset, evic_offset;
	
	//Pseudo LRU cache hit check
	hit_offset = p_hit_search(cache, i_tag, index, ways_num);
	//Cache hit
	if(hit_offset != -1)
	{
		if(!strcmp(cmd,"W"))
			cache[index].cont[hit_offset].dirty = 1;
		return ;
	}
	//Cache miss

	//Pseudo LRU cache miss
	evic_offset = p_evic_search(cache, i_tag, index, ways_num);

	//Not first miss	
	if(cache[index].cont[evic_offset].valid != 0)
	{	
		if(cache[index].cont[evic_offset].dirty)
		{
			dirty_evics++;
		}
		else
		{
			clean_evics++;
		}
	}

//	printf("index = %d evic_offset = %d\n",index, evic_offset);
	cache[index].cont[evic_offset].tag = i_tag;
	cache[index].cont[evic_offset].valid = 1;
	if(!strcmp(cmd,"W"))
	{
		cache[index].cont[evic_offset].dirty = 1;
		write_misses++;
	}
	else
	{

		cache[index].cont[evic_offset].dirty = 0;
		read_misses++;
	}


	return ;	
}
int p_evic_search(Cache *cache, uint64_t i_tag, int index, int ways_num)
{
	int r_evic_offset;
	int tree_index = 0;
	int left_index, right_index;
//	printf("index = %d\n",index);
	while(1)
	{
		if(cache[index].p_bit[tree_index] == 0)
		{
			cache[index].p_bit[tree_index] = 1;
			left_index = (tree_index * 2) + 1;
			tree_index = left_index;
		}
		else
		{
			cache[index].p_bit[tree_index] = 0;
			left_index = (tree_index * 2) + 1;
			right_index = left_index + 1;
			tree_index = right_index;
		}
		//printf("tree_bit[%d] = %d\n",tree_index,cache[index].p_bit[tree_index]);
		if(tree_index >= ways_num -1)
		{
			break;	
		}
	}
//	printf("tree_index = %d\n",tree_index);	
	r_evic_offset = tree_index - (ways_num - 1);
	return r_evic_offset;	
}
int p_hit_search(Cache *cache, uint64_t i_tag, int index, int ways_num)
{
	int i;
	int tree_index = 0;
	int h_offset = -1;
	int check;
	for(i = 0 ; i < ways_num; i++)
	{
		if(cache[index].cont[i].tag == i_tag)
		{
			h_offset = i;
			break;
		}
	}
	//Miss
	if(h_offset == -1)
	{
		return h_offset;
	}
	
	//Hit
	tree_index = h_offset + (ways_num - 1);
	//Check left_node or right_node
	
	while(1)
	{
		//parent node index
		
		check = (tree_index - 1) % 2;
		tree_index = (tree_index - 1) / 2;
		//If left node
		if(check == 0)
		{
			if(cache[index].p_bit[tree_index] == 0)
			{
				cache[index].p_bit[tree_index] = 1;
			}
		}
		else
		{
			if(cache[index].p_bit[tree_index] == 1)
			{
				cache[index].p_bit[tree_index] = 0;
			}
		}
		
		if(tree_index == 0) break;
	}

	return h_offset;
	
	
		
	
}

uint64_t cal_checksum(Cache *cache, int index_num, int ways_num)
{
	uint64_t t_checksum = 0;
	uint64_t t_tag = 0;
	int t_index = 0;
	int t_dirty = 0;
	int i,j;

	for(i = 0 ; i < index_num; i++)
	{
		for(j = 0; j < ways_num; j++)
		{
			if(cache[i].cont[j].valid)
			{
				t_tag = cache[i].cont[j].tag;
				t_index = i;
				t_dirty = cache[i].cont[j].dirty;
				t_checksum = t_checksum ^ (((t_tag ^ t_index) << 1) | t_dirty);
			}
		}
	}

	return t_checksum;
}
uint64_t get_tag(uint64_t addr, int b_size, int index_num)
{
	uint64_t t_tag;
	int block_bit_count, index_bit_count;
	block_bit_count = bit_count(b_size);
	index_bit_count = bit_count(index_num);

//	printf("block_bit_count = %d\n",block_bit_count);
//	printf("index_bit_count = %d\n",index_bit_count);
	
	t_tag = addr >> (block_bit_count + index_bit_count);
//	printf("t_tag = %llx\n",t_tag);
	
	return t_tag;
	
}
int get_idx(uint64_t addr, int b_size, int index_num)
{
	uint64_t t_addr = addr;
	int t_index = 0;
	int i = 0;
	int block_bit_count, index_bit_count;
	
	block_bit_count = bit_count(b_size);
	index_bit_count = bit_count(index_num);

	//printf("block_bit_count = %d\n",block_bit_count);
	//printf("index_bit_count = %d\n",index_bit_count);
	
	//block bit remove

	t_addr = t_addr >> block_bit_count;
	
	for(i = 0 ; i < index_bit_count; i++)
	{
		if(t_addr & 1)
		{
			t_index += (int) pow(2, i);		
		}
		t_addr = t_addr >> 1;
	}

//	printf("t_index = %d\n",t_index);
	if(t_index > index_num)
	{
		return -1;
	}
	
	return t_index;
}

int bit_count(int var)
{
	int count = 0;
//	printf("var = %d\n",var);
	while(1)
	{
		var = var >> 1;
		if(var == 0)
		{
			break;
		}	
		count++;
	}
	return count;
}

int get_config(FILE *fp)
{
	char buf[10];
	int i = 0;
	while(fgets(buf, sizeof(buf), fp) != NULL)
	{
		if(i == 0) capacity = atoi(buf) * 1024;
		if(i == 1) ways = atoi(buf);
		if(i == 2) b_size = atoi(buf);
		i++;
	}

	return 1;
}




void print_dirty(Cache *cache, int index_num, int ways_num)
{
	int i,j;

	for(i = 0 ; i < index_num; i++)
	{
		printf("SET[%d] : ",i);
		for(j = 0 ; j < ways_num; j++)
		{
//			printf("tag = %llx, way[%d].dirty = %d ",cache[i].cont[j].tag,j,cache[i].cont[j].dirty);
		}
		printf("\n");
	}
}

void file_print(char *file_name)
{
	FILE *w_fp;
	char output_name[256];	
	
	//Pure LRU
	if(policy == 1)
	{
		sprintf(output_name,"%s_%d_%d_%d.out",file_name,capacity/1024,ways,b_size);
		w_fp = fopen(output_name, "w");
	
	}
	//PSEUDO LRU
	else
	{
		sprintf(output_name,"%s_%d_%d_%d_p.out",file_name,capacity/1024,ways,b_size);
		w_fp = fopen(output_name, "w");
			
	}
	fprintf(w_fp,"-- General Stats --\n");
	fprintf(w_fp,"Capacity : %d\n", capacity / 1024);
	fprintf(w_fp,"Way : %d\n",ways);
	fprintf(w_fp,"Block size: %d\n", b_size);
	fprintf(w_fp,"Total accesses : %d\n", total_accesses);
	fprintf(w_fp,"Read accesses : %d\n", read_accesses);
	fprintf(w_fp,"Write accesses : %d\n", write_accesses);
	fprintf(w_fp,"Read misses : %d\n", read_misses);
	fprintf(w_fp,"Write misses : %d\n", write_misses);
	fprintf(w_fp,"Read miss rate : %lf\n", read_rate);
	fprintf(w_fp,"Write miss rate : %lf\n", write_rate);
	fprintf(w_fp,"Clean evictions : %d\n", clean_evics);
	fprintf(w_fp,"Dirty evictions : %d\n", dirty_evics);
	fprintf(w_fp,"Checksum : 0x%llx\n", checksum);

	fclose(w_fp);
	return ;	
	
}



