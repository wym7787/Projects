#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "inst.h"


int rss_check(RSS *rss, int rss_size)
{
	int i;
	int rss_set = -1;

	for(i = 0 ; i < rss_size; i++)
	{
		if(rss[i].busy == 0)
		{
			rss_set = i;
			break;
		}
	}

	return rss_set; 


}
int rss_time_set(RSS *rss)
{
	
	if(!strcmp(rss->op,IntAlu))
        {
		rss->time = ALU_TIME;
        }
        if(!strcmp(rss->op,MemRead))
        {
		rss->time = M_READ_TIME;
        }
        if(!strcmp(rss->op,MemWrite))
        {
		rss->time = M_WRITE_TIME;
        }
	return 1;
}

int rob_check(ROB *rob, int rob_size)
{
	int i;
	int rob_set = -1;
	for(i = 0 ; i < rob_size; i++)
	{
		if(rob[i].use == 0)
		{
			rob_set = i;
			break;
		}
	}
	return rob_set;
}


//Linked List

void appendNode(RSS **head, RSS *new)
{
	if((*head) == NULL)
	{
		*head = new;
	}
	else
	{
		RSS *Tail = (*head);
		while(Tail->next != NULL)
		{
			Tail = Tail->next;
		}
		Tail->next = new;
	}
}

RSS *deleteNode(RSS **head)
{
	RSS *cur = *head;
	RSS *tmp = *head;
	if(*head == NULL)
	{
		return NULL;
	}

	while(cur != NULL)
	{

		if(cur->q1 == -1 && cur->q2 == -1)
		{
			break;
		}
		else
		{
			tmp = cur;
			cur = cur->next;
		}
	}
	if(cur == NULL)
	{
		return NULL;
	}
	else
	{
		if(cur == *head)
		{
			if(cur->next != NULL)
			{
				*head = cur->next;
			}
			else
			{
				cur->next = NULL;
				*head = NULL;
			}
		}
		else
		{
			if(cur->next != NULL)
			{
				tmp->next = cur->next;
			}
			else
			{
				tmp->next = NULL;
			}
		}
		return cur;
	}	
		

	
}
void linked_display(RSS **head)
{
	RSS *cur = *head;

	while(cur != NULL)
	{
		printf("%d -> ",cur->rss_set+1);
		cur = cur->next;
	}
	printf("NULL\n");
}








