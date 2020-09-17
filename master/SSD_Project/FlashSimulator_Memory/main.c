#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>

#include "./include/block.h"
#include "./include/zftl.h"
#include "./include/bench.h"
#include "./include/hashftl.h"

extern Bench *bench;

int main(int argc, char **argv){

	hash_create();
	
	
//	set_real_bench(ROCKS_R_W_16);
//	set_real_bench(ROCKS_RW_RR_16);


	
	bench_init();
//	bench_add(SW,RANGE);
	bench_add(RW,RANGE);
	bench_add(RW,RANGE);
	bench_add(RW,RANGE);
	bench_start();
	bench_end();
	
	block_status(bm);
	
	hash_destroy();



	/*
	zftl_create();

	bench_init();
	
	bench_add(SW,RANGE*0.7);
	bench_start();	
	bench_end();

	
	set_real_bench(ROCKS_R_W_16);
	set_real_bench(ROCKS_RW_RR_16);

	
	bench_add(RW,RANGE);

	bench_add(SR,RANGE);

	
	
	zftl_destroy();
*/


	return 1;

}
