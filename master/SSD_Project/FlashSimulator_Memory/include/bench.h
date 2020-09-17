#ifndef __BENCH_H_
#define __BENCH_H_


#include "settings.h"
#include "zftl.h"
#include "real.h"
#include "hashftl.h"
#define BENCHSIZE 10


typedef enum{
	SW, RW, SR, RR, RANDRW
}bench_type;


typedef struct {
	uint32_t lba;
	char *data;
	bool r_type;
}b_data;


typedef struct {
	b_data *bench_data;
	bench_type bt;
	int idx;
	int max_addr_range;
}Bench;


void bench_init(void);
void bench_add(bench_type, int32_t);
void bench_free(Bench *);

void seq_write(int32_t);
void seq_read(int32_t);
void rand_write(int32_t);
void rand_read(int32_t);
void rand_r_w(int32_t);

void bench_start(void);
void bench_end(void);


void set_real_bench(char *);

#endif
