#include "../include/bench.h"

Bench *bench;

void bench_init(void){


	printf("Bench init completion !!\n");
	bench = (Bench *)malloc(sizeof(Bench) * BENCHSIZE);
	memset(bench, 0, sizeof(Bench) * BENCHSIZE);

	return ;
}
void bench_add(bench_type type, int32_t max_range){


	bench[bench->idx].bt = type;
	bench[bench->idx].max_addr_range = max_range;
	switch(type){
		case SW:
			seq_write(max_range);
			break;
		case RW:
			rand_write(max_range);
			break;
		case SR:
			seq_read(max_range);
			break;
		case RR:
			rand_read(max_range);
			break;
		case RANDRW:
			rand_r_w(max_range);
			break;
		default:
			printf("Bench init Fail!!\n");
			exit(0);

	}

	return ;
}


void bench_free(Bench *bench)
{

	for(int i = 0 ; i < bench->idx ; i++){
		free(bench[i].bench_data);
	}
	free(bench);
	printf("Bench test end!\n");


}


void seq_write(int32_t max_range){
	
	printf("Sequential Write Range : 0 ~ %d\n",max_range);
	bench[bench->idx].bench_data = (b_data *)malloc(sizeof(b_data) * max_range);
	for(int i = 0 ; i < max_range; i++){
		bench[bench->idx].bench_data[i].lba = i;
	//	printf("%d\n",bench[bench->idx].bench_data[i].lba);
		bench[bench->idx].bench_data[i].data = "yumin!";
		bench[bench->idx].bench_data[i].r_type = 0;
	}
	bench->idx++;
}

void seq_read(int32_t max_range){

	printf("Sequential Read Range : 0 ~ %d\n",max_range);	
	bench[bench->idx].bench_data = (b_data *)malloc(sizeof(b_data) * max_range);
	for(int i = 0 ; i < max_range; i++){
		bench[bench->idx].bench_data[i].lba = i;
		bench[bench->idx].bench_data[i].r_type = 1;
	}
	bench->idx++;

}


void rand_write(int32_t max_range){

	printf("Random Write Range : 0 ~ %d\n",max_range);	
	bench[bench->idx].bench_data = (b_data *)malloc(sizeof(b_data) * max_range);
	for(int i = 0 ; i < max_range; i++){
		bench[bench->idx].bench_data[i].lba = rand() % max_range;
		bench[bench->idx].bench_data[i].data = "yumin!";
		bench[bench->idx].bench_data[i].r_type = 0;
	}
	bench->idx++;
	
}
void rand_read(int32_t max_range){

	printf("Random Read Range : 0 ~ %d\n",max_range);	
	bench[bench->idx].bench_data = (b_data *)malloc(sizeof(b_data) * max_range);
	for(int i = 0 ; i < max_range; i++){
		bench[bench->idx].bench_data[i].lba = rand() % max_range;
		bench[bench->idx].bench_data[i].r_type = 1;
	}
	bench->idx++;	

}

void rand_r_w(int32_t max_range){
	int rand_idx;
	
	printf("Random Read/Write range : 0 ~ %d\n",max_range);
	bench[bench->idx].bench_data = (b_data *)malloc(sizeof(b_data) * max_range);
	for(int i = 0 ; i < max_range; i++){
		bench[bench->idx].bench_data[i].lba = rand() % max_range;
		bench[bench->idx].bench_data[i].data = "yumin!";
		bench[bench->idx].bench_data[i].r_type = 0;
	}
	bench->idx++;
	bench[bench->idx].bench_data = (b_data *)malloc(sizeof(b_data) * max_range);
	for(int i = 0; i < max_range; i++){
		rand_idx = rand() % max_range;
		bench[bench->idx].bench_data[i].lba = bench[bench->idx-1].bench_data[rand_idx].lba;
		bench[bench->idx].bench_data[i].r_type = 1;
	}
	bench[bench->idx].max_addr_range = max_range;
	bench->idx++;
}

void bench_start(void){
	int lba;
	//char *data;

	printf("Bench test start!\n");
	for(int i = 0; i < bench->idx; i++){
		for(int j = 0; j < bench[i].max_addr_range; j++){
		
			lba = bench[i].bench_data[j].lba;
			//data = bench[i].bench_data[j].data;
			if(!bench[i].bench_data[j].r_type){
				hash_write(lba);
				//zftl_write(lba);
			}else{
				hash_read(lba);
				//zftl_read(lba);
			}
			printf("\r testing.... [%.2lf%%]",(double)(j)/(bench[i].max_addr_range/100));
			fflush(stdout);
		}

		printf("\n");

	}
	return ;
}
void bench_end(void){
	bench_free(bench);
}



void set_real_bench(char *load_file){
	FILE *fp = fopen(load_file, "r");
	char command[2];
	char type[5];
	double cal_len;
	unsigned long long int offset;
	int len;
	int blk_len = 8; //4K = 8, 8K =16
	bool r_type;

	printf("testing ... !!\n");
	while(fscanf(fp, "%s %s %llu %lf", command, type, &offset, &cal_len) != EOF){
		if(command[0] == 'D'){
			offset = offset / blk_len;
			len = ceil(cal_len / blk_len);
			if(offset + len > RANGE){
				continue;
			}
			if(type[0] == 'R'){
				r_type = 1;
			}else{
				r_type = 0;
			}
		}

		for(int i = 0 ; i < len ; i++){
			if(r_type == 0){
				hash_write(offset+i);
			}else{
				hash_read(offset+i);
			}
		}
	}
	fclose(fp);
	return ;
}




