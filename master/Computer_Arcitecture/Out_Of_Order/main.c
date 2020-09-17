#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include "queue.h"
#include "inst.h"

//config variable
int dump, width, rob_size, rss_size;
//stats variable
int cycle, total_insts, IntAlu_count, MemRead_count, MemWrite_count;
double IPC;
//Out_of_order buffer
INST *inst;
RSS *rss;
RAT *rat;
ROB *rob;

RSS *link = NULL;
RSS *c_link = NULL;
//quick sort function


//Setting and Process function
void out_init(void);
void out_free(void);

int o_process(char *);
int get_config(FILE *);
void type_count(char *);
int type_display(INST *);
int minFind(int);

void final_stats(void);

//Buffer function
extern int rss_check(RSS *, int);
extern int rss_time_set(RSS *);
extern int rob_check(ROB *, int);
extern int rat_check(RAT *, int);

void rss_index(RSS *, int, Queue *);
void rob_index(ROB *, int , Queue *);

//Variable
//static int commit_index;

Queue *rss_queue;
Queue *rob_queue;
Queue *commit_queue;
static int commit_index;
static int test_count;

//Out_of_Order function
int fetch(Queue *, FILE *);
int decode(Queue *);
int issue(Queue *);
int execute(Queue *);
int commit();
void dump_print();

int main(int argc, char **argv)
{
	char *trace_name;
	FILE *c_fp;
	printf("Out_of_Order Setting!\n");
	if(argc != 3)
	{
		printf("usage ./out_of_order config_fime_name trace_file_name\n");
		exit(0);
	}
	else
	{
		c_fp = fopen(argv[1], "r");	
		trace_name = argv[2];	
		if(get_config(c_fp))
		{
			printf("Config_get success!\n");
			fclose(c_fp);
		}
		
	}

	if(o_process(trace_name))
	{

		printf("Out_of_order End!!\n");
	}
	else
	{
		printf("Out_of_order Fail!!\n");
	}
	IPC = total_insts / cycle;
	final_stats();	
}
int o_process(char *trace_name)
{
	FILE *fp = fopen(trace_name, "r");
	Queue *f_queue;	
	Queue *i_queue;
	
	rss_queue = (Queue *)malloc(sizeof(Queue));
	rob_queue = (Queue *)malloc(sizeof(Queue));
	commit_queue = (Queue *)malloc(sizeof(Queue));
	f_queue = (Queue *)malloc(sizeof(Queue));
	i_queue = (Queue *)malloc(sizeof(Queue));

	
	if(fp == NULL)
	{
		 printf("Trace file open Error!\n");
		 exit(0);
	}

	//buffer setting
	out_init();
	//fetch_queue init
	q_init(f_queue, width);
	//issue queue init
	c_q_init(i_queue, width);
	c_q_init(rob_queue, rob_size);
	c_q_init(rss_queue, rss_size);
	c_q_init(commit_queue, rob_size);
	while(!feof(fp))
	{
		
		if(!commit())
		{
		}
		
		if(!execute(i_queue))
		{
		}

		if(!issue(i_queue))
		{
		//	printf("Issue Stall!!\n");
		}
		if(!decode(f_queue))
		{
		//	printf("Decode Stall!!\n");
		}
		
			//Instruction Fetch
		if(!fetch(f_queue, fp))
		{
		//	printf("Fetch Stall!!\n");
		}
	
		for (int i = 0; i < rss_size; i++) {
			if (rss[i].f1 == 1) {
				rss[i].q1 = -1;
				rss[i].f1 = 0;
			}
			if (rss[i].f2 == 1) {
				rss[i].q2 = -1;
				rss[i].f2 = 0;
			}
		}
		
		cycle++;
		dump_print();
		total_insts = IntAlu_count + MemRead_count + MemWrite_count;
		if(total_insts == 100) break;	
	}
	out_free();
	q_free(f_queue);
	q_free(i_queue);
	q_free(rob_queue);
	q_free(rss_queue);
	q_free(commit_queue);
	return 1;
	
}
void out_init(void)
{
	int i;
	inst = (INST *)malloc(sizeof(INST));
	rss = (RSS *)malloc(sizeof(RSS) * rss_size);
	rat = (RAT *)malloc(sizeof(RAT) * NUM_OF_REG + 1);
	rob = (ROB *)malloc(sizeof(ROB) * rob_size);
	
	//init
	memset(inst, 0, sizeof(INST));
	for(i = 0 ; i < rss_size; i++)
	{
		rss[i].rob_num = -1;
		rss[i].time = -1;
		rss[i].busy = 0;
		rss[i].q1 = -1;
		rss[i].q2 = -1;
		rss[i].f1 = 0;
		rss[i].f2 = 0;
		rss[i].execute_bit = 0;
	}
	for(i = 0; i < NUM_OF_REG + 1; i++)
	{
		rat[i].q = -1;
		rat[i].valid = 1;
	}
	for(i = 0; i < rob_size; i++)
	{
		rob[i].dest = -1;
		rob[i].status = -1;
		rob[i].use = 0;
		rob[i].commit_bit = 0;
	}

	
}
void out_free(void)
{
	free(inst);
	free(rss);
	free(rat);
	free(rob);
}
int fetch(Queue *q, FILE *fp)
{
	int i;
	int j = 0;
	char *ptr = NULL;	
	char buf[BUF_SIZE];
	
	for(i = 0; i < width; i++)
	{
		if(!is_full(q))
		{
			INST *tmp;
			fgets(buf, sizeof(buf),fp);
			test_count++;
	//		printf("test_count = %d\n",test_count);	
			tmp = (INST *)malloc(sizeof(INST));
			ptr = strtok(buf," ");
			strcpy(tmp->type, ptr);
			type_count(tmp->type);
			while(ptr != NULL)
			{
				ptr = strtok(NULL, " ");
				if(j == 0) tmp->dest = atoi(ptr);
				if(j == 1) tmp->src1 = atoi(ptr);
				if(j == 2) tmp->src2 = atoi(ptr);
				if(j == 3) tmp->addr = atoi(ptr);
				j++;	
			}
			j = 0;
	//		printf("%s %d %d %d %d\n",tmp->type,tmp->dest, tmp->src1, tmp->src2, tmp->addr);
			enqueue(q, tmp);
		}
		else
		{
		//	printf("Fetch queue is full!\n");
			return 0;
		}

		
	}
	return 1;	
}
int decode(Queue *f_queue)
{
	int i;
	int rss_set, rob_num;
	int dest;
	int src1, src2;
	INST *d_inst;
	//RSS or ROB check

	for(i = 0 ; i < width; i++)
	{
		
		if(!is_empty(f_queue))
		{

			if(is_empty(rss_queue) || is_empty(rob_queue)) 
			{


		//		printf("decode impossible!\n");
				return 0;	
			}
		
			rss_set = c_dequeue(rss_queue);
			rob_num = c_dequeue(rob_queue);

	//		printf("rss_set = %d\n",rss_set);	
	//		printf("rob_num = %d\n",rob_num);
			
			d_inst = dequeue(f_queue);
			dest = d_inst->dest;
			src1 = d_inst->src1;
			src2 = d_inst->src2;
	//		printf("proceeding %d %d %d\n", dest, src1, src2);
			
			//RSS Setting
			rss[rss_set].rss_set = rss_set;
			rss[rss_set].rob_num = rob_num;
			strcpy(rss[rss_set].op, d_inst->type);
			if(src1 != 0 && rat[src1].valid == 0) rss[rss_set].q1 = rat[src1].q;
			else rss[rss_set].q1 =-1;
			if(src2 != 0 && rat[src2].valid == 0) rss[rss_set].q2 = rat[src2].q;
			else rss[rss_set].q2 =-1;
			rss[rss_set].next = NULL;	
			appendNode(&link, &rss[rss_set]);
	//		linked_display(&link);
			//printf("dest = %d\n",dest);
			//printf("src1 = %d\n",src1);
			//printf("src2 = %d\n",src2);
			//printf("rss_set = %d\n",rss_set);
			//printf("rob_num = %d\n",rob_num);

			//ROB Setting
			strcpy(rob[rob_num].op, d_inst->type);
			rob[rob_num].dest = dest;      		  //ROB register setting
			rob[rob_num].status = P;                  //ROB status setting
			//RAT Setting
			if(dest != 0)
			{
				rat[dest].q = rob_num;
				rat[dest].valid = 0; 
			}
			else
			{
				rat[dest].q = -1;
				rat[dest].valid = 1 ;
			}
			free(d_inst);
		}
		else
		{
				printf("Fetch queue is empty!\n");
				return 0;
		}

	
	}
	return 1;		
}
int issue(Queue *i_queue)
{
	int i;
	int entry_index;
	RSS *tmp;
	for(i = 0 ; i < width; i++)
	{
		if(!is_full(i_queue))
		{
			tmp = deleteNode(&link);
			if(tmp == NULL)
			{
				return 0;
			}
			tmp->next = NULL;
			rss_time_set(tmp);
			entry_index = tmp->rss_set;
			
	//		printf("entry_index = %d\n", entry_index);
			c_enqueue(i_queue, entry_index);



		}
		else
		{
			return 0;
		}
	}
	return 1;
	
}
int execute(Queue *i_queue)
{
	int i = 0;
	int j;
	int entry_index;
	int rob_num;
	for(i = 0 ; i < width; i++)
	{
		if(!is_empty(i_queue))
		{
			entry_index = c_dequeue(i_queue);
			rss[entry_index].time--;		
			if(rss[entry_index].time == 0)
			{
				rob_num = rss[entry_index].rob_num;
				rss[entry_index].rss_set = -1;
				rss[entry_index].rob_num = -1;
				rss[entry_index].time = -1;
				rss[entry_index].busy = 0;
				strcpy(rss[entry_index].op,"");
				for(j = 0 ; j < rss_size; j++)
				{
					if(rss[j].q1 == rob_num) rss[j].f1 = 1;
					if(rss[j].q2 == rob_num) rss[j].f2 = 1;
				}
				//if(rss[j].q1 == -1 && rss[j].q2 == -1)
				//{
				//	rss[entry_index].f = 1;
				//}
				rob[rob_num].status = C;
			}
			else
			{
				c_enqueue(i_queue, entry_index);
			}
			
		}
		else
		{
			return 0;
		}
	}
	return 1;		
}
int commit()
{
	int i;
	int reg_num;
	rob_index(rob, rob_size, rob_queue);		
	rss_index(rss, rss_size, rss_queue);

	for(i = 0; i < width; i++)
	{

	//	printf("commit_index = %d\n",commit_index);
		if(rob[commit_index].status == C)
		{
			reg_num = rob[commit_index].dest; //Reg_number;
			strcpy(rob[commit_index].op,"");
			rob[commit_index].status = -1;
			rob[commit_index].dest = -1;
			rob[commit_index].use = 0;

			rat[reg_num].q = -1;
			rat[reg_num].valid = 1;
		
			commit_index = (commit_index + 1) % rob_size;
		}
	}
	return 1;
		
}



int get_config(FILE *c_fp)
{
	char buf[10];
	int i = 0;
	if(c_fp == NULL)
	{
		printf("Config_get Fail!\n");
		exit(0);
	}
	while(fgets(buf, sizeof(buf), c_fp) != NULL)
	{
		if(i == 0) dump = atoi(buf);
		if(i == 1) width = atoi(buf);
		if(i == 2) rob_size = atoi(buf);
		if(i == 3) rss_size = atoi(buf);
		i++;
	}
//	printf("dump = %d\n",dump);
//	printf("width = %d\n", width);
//	printf("rob_size = %d\n", rob_size);
//	printf("rss_size = %d\n", rss_size);
	return 1;
	
}



void type_count(char *type)  
{
        if(!strcmp(type,IntAlu))
        {
		IntAlu_count++;
        }
        if(!strcmp(type,MemRead))
        {
		MemRead_count++;
        }
        if(!strcmp(type,MemWrite))
        {
		MemWrite_count++;
        }
	return ;
}
int type_display(INST *tmp)
{
        printf("type : %s\n",tmp->type);
        printf("dest : %d\n",tmp->dest);
        printf("src1 : %d\n",tmp->src1);
        printf("src2 : %d\n",tmp->src2);
        printf("addr : %x\n",tmp->addr);
        return 1;
}
void final_stats(void)
{

	total_insts = IntAlu_count + MemRead_count + MemWrite_count;
	IPC = (double) total_insts / (double) cycle;
	printf("Cycles      : %d\n",cycle);
	printf("IPC         : %.2lf\n", IPC);
	printf("Total insts : %d\n",total_insts);
	printf("IntAlu      : %d\n",IntAlu_count);
	printf("MemRead     : %d\n",MemRead_count);
	printf("MemWrite    : %d\n",MemWrite_count); 
	
}


void rss_index(RSS *rss, int rss_size, Queue *q)
{
	int i;

	for(i = 0; i < rss_size; i++)
	{
		
		if(rss[i].busy == 0)
		{		
			rss[i].busy = 1;
			c_enqueue(q, i);
		}
	}
	return ;
}

void rob_index(ROB *rob, int rob_size, Queue *q)
{
        int i;
        for(i = 0 ; i < rob_size; i++)
        {
                if(rob[i].use == 0)
                {
			rob[i].use = 1;	
                        c_enqueue(q, i);
                }
        }
        return ;
}

void dump_print()
{
	int i;

	if(dump == 1)
	{

		printf("= Cycle %d\n",cycle);
		for(i = 0; i < rss_size; i++)
		{
			if(rss[i].rob_num != -1)
			{
				printf("RS%d    : ROB%d ",i+1,rss[i].rob_num+1);
				if(rss[i].q1 != -1) printf("%d\t",rss[i].q1+1);
				else printf("V ");

				if(rss[i].q2 != -1) printf("%d\n",rss[i].q2+1);
				else printf("V\n");
			}
		}


	
	}

	if(dump == 2)
	{

		printf("= Cycle %d\n",cycle);
		for(i = 0 ; i <rob_size; i++)
		{
			if(rob[i].status != -1)
			{
				printf("ROB%d   :    ",i+1);
				if(rob[i].status == P) printf("P\n");
				if(rob[i].status == C) printf("C\n");
			}
		}
	}

}
