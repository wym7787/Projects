//2012335044 B�� ������
//���� �ҽ��ڵ�
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <pthread.h>

#define BUF_SIZE 100
#define NAME_SIZE 20
#define MAX_CLNT 256
#define CLNTMAX 100


void * handle_clnt(void * arg);
void send_msg(char * msg, int my_sock, int len);
void error_handling(char * msg);

void nameCheck(char *msg, int clnt_sock);         // �̸� �߰� �Լ�
int nameCheck2(char *conName, int clnt_sock);     // �ߺ� üũ �Լ�
void list(int clnt_sock);                         // list ��� �Լ�
void initStr(char *msg, int len);                 // ���� �ʱ�ȭ �Լ�
int secretCheck(char *msg, int len);              // �ӼӸ� üũ �Լ�
int secretCheck2(char *msg, int len);             // �ӼӸ� ���� üũ �Լ�
int secretSend(char *msg, char *rename, int len); // �ӼӸ� ���� �Լ�


// ���� ����
int clnt_cnt = 0;             // Ŭ���̾�Ʈ ��
int clnt_socks[MAX_CLNT];     // ���� �������
char *clnt_name[CLNTMAX];     // Ŭ���̾�Ʈ �̸� ����
pthread_mutex_t mutx;

int main(int argc, char *argv[])
{
	int serv_sock, clnt_sock;
	struct sockaddr_in serv_adr, clnt_adr;
	int clnt_adr_sz;
	pthread_t t_id;
	if (argc != 2) {
		printf("Usage : %s <port>\n", argv[0]);
		exit(1);
	}

	pthread_mutex_init(&mutx, NULL);
	serv_sock = socket(PF_INET, SOCK_STREAM, 0);

	memset(&serv_adr, 0, sizeof(serv_adr));
	serv_adr.sin_family = AF_INET;
	serv_adr.sin_addr.s_addr = htonl(INADDR_ANY);
	serv_adr.sin_port = htons(atoi(argv[1]));

	if (bind(serv_sock, (struct sockaddr*) &serv_adr, sizeof(serv_adr)) == -1)
		error_handling("bind() error");
	if (listen(serv_sock, 5) == -1)
		error_handling("listen() error");

	while (1)
	{
		clnt_adr_sz = sizeof(clnt_adr);
		clnt_sock = accept(serv_sock, (struct sockaddr*)&clnt_adr, &clnt_adr_sz);

		pthread_mutex_lock(&mutx);
		clnt_socks[clnt_cnt] = clnt_sock;
		clnt_name[clnt_cnt] = NULL;        //�̸� ���� NULL �ʱ�ȭ
		clnt_cnt++;
		pthread_mutex_unlock(&mutx);

		printf("Client IP: %s ���� �õ� \n", inet_ntoa(clnt_adr.sin_addr));
		pthread_create(&t_id, NULL, handle_clnt, (void*)&clnt_sock);
		pthread_detach(t_id);
		
	}
	close(serv_sock);
	return 0;
}

void * handle_clnt(void * arg)
{
	int clnt_sock = *((int*)arg);
	int str_len = 0, i;
	int namebit = 0;
	char name[NAME_SIZE];
	char rename[NAME_SIZE];
	char byeName[NAME_SIZE];
	char msg[BUF_SIZE] = { 0, };

	char conMessage[] = "ä�ù濡 �����Ͽ����ϴ�\n";
	char reMessage[BUF_SIZE];	


	read(clnt_sock, name, sizeof(name));      //�̸��� �޴´�.
	nameCheck(name, clnt_sock);               //ID �� �迭�� �߰��Ѵ�.
	namebit = nameCheck2(name, clnt_sock);    //ID �ߺ� ���� 2�� Ȯ��

	write(clnt_sock, &clnt_cnt, sizeof(clnt_cnt)); //Ŭ���̾�Ʈ ���� ������
	
	// Ŭ���̾�Ʈ �� 5�� �̻��̸� ���� ���и� �˸���.
	/* ä�ù� �ο� ������ ����� �ڵ�
	if (clnt_cnt > CLNTMAX)
	{
		pthread_mutex_lock(&mutx);
		//write(clnt_sock, &clnt_cnt, sizeof(clnt_cnt));
		clnt_cnt--;
		pthread_mutex_unlock(&mutx);
		printf("ä�ù� �ο� �ʰ��� ���� ���� ����!!\n");
		close(clnt_sock);
		return NULL;
	}
	*/

	// Ŭ���̾�Ʈ ID �ߺ��� �˸���.
	if (namebit)
	{
		list(clnt_sock);
		printf("Client ID �ߺ����� ���� ����!!\n");
		close(clnt_sock);
		return NULL;
	}

	printf("Client ���� ����!!\n");
	write(clnt_sock, conMessage, strlen(conMessage));  //ä�ù濡 �����Ͽ����� �˸���.
	sprintf(rename, "[%s]", name);
	sprintf(reMessage, "%s ���� �����Ͽ����ϴ�\n", rename); 
	send_msg(reMessage, clnt_sock, strlen(reMessage));       //���� ���θ� ������.
	list(clnt_sock);                                         //��� ����Ʈ�� ������.

	

	
	while ((str_len = read(clnt_sock, msg, sizeof(msg)))!=0)
	{
		//@ �Է� �� ��� ��� ����
		if (!strcmp(msg, "@\n"))
		{
			list(clnt_sock);
			initStr(msg, str_len);
			continue;
		}
		// �ӼӸ� ������ ����
		if (secretCheck(msg, str_len)) //#�� ������ Ȯ���Ѵ�.
		{
			//�ӼӸ� ���Ŀ� �´��� Ȯ���Ѵ�.
			if (secretCheck2(msg, str_len))
			{
				//�ش� ID �����ϴ��� Ȯ��
				if(secretSend(msg, rename, str_len)); 
				else // ID ���� ���� ���� ���
				{
					char errorMessage[] = "ID�� �������� �ʽ��ϴ�. ����� Ȯ���ϼ���!!\n";
					write(clnt_sock, errorMessage, strlen(errorMessage));
				}
				
				
			}
			// �ӼӸ� ������ �ƴ� ���
			else
			{
				char errorMessage[] = "/�ӼӸ� ���� (#ID Message)\n";
				write(clnt_sock, errorMessage, strlen(errorMessage));
				
			}
			initStr(msg, str_len);
			continue;
		}
		
		//�Ϲ� �޼��� ����
		send_msg(msg, clnt_sock, str_len);
		initStr(msg, str_len);
	}

	//Ctrl + C �Ǵ� q �Է� �� ���� �������� �˸���.
	sprintf(byeName, "%s", rename);
	sprintf(msg, "%s ���� ä�ù��� �������ϴ�\n", byeName);
	str_len = strlen(msg);
	send_msg(msg, clnt_sock, str_len);
	
	

	pthread_mutex_lock(&mutx);
	for (i = 0; i<clnt_cnt; i++)   // remove disconnected client
	{
		if (clnt_sock == clnt_socks[i])
		{
			
			while (i < clnt_cnt - 1)
			{
				clnt_socks[i] = clnt_socks[i + 1];
				clnt_name[i] = clnt_name[i + 1];
				i++;
			}
			break;
		}
	}
	
	clnt_cnt--;
	pthread_mutex_unlock(&mutx);

	close(clnt_sock);
	return NULL;
}

void send_msg(char * msg,int my_sock, int len)   // send to all
{
	int i;
	pthread_mutex_lock(&mutx);
	for (i = 0; i < clnt_cnt; i++)
	{
		if (my_sock != clnt_socks[i])
			write(clnt_socks[i], msg, len);
	}
	pthread_mutex_unlock(&mutx);
}
void error_handling(char * msg)
{
	fputs(msg, stderr);
	fputc('\n', stderr);
	exit(1);
}


void nameCheck(char *conName,int clnt_sock)
{
	int i;
	
	
	pthread_mutex_lock(&mutx);
	for (i = 0; i < clnt_cnt; i++)
	{
		if (clnt_name[i] == NULL)
		{
			clnt_name[i] = conName;
		}

	}
	pthread_mutex_unlock(&mutx);
}
int nameCheck2(char *conName, int clnt_sock)
{
	int i;
	int namebit = 0;

	pthread_mutex_lock(&mutx);
	for (i = 0; i < clnt_cnt - 1; i++)
	{
		if (!strcmp(clnt_name[i], conName))
		{
			namebit = 1;
			clnt_name[clnt_cnt - 1] = 0;
			clnt_cnt--;
			break;
		}

	}
	pthread_mutex_unlock(&mutx);
	write(clnt_sock, &namebit, sizeof(namebit));
	return namebit;
}
void list(int clnt_sock)
{
	int i;
	char listMessage[BUF_SIZE];
	
	pthread_mutex_lock(&mutx);
	sprintf(listMessage, "���� ������ ��� [%d]�� : ",clnt_cnt);
	
	for (i = 0; i < clnt_cnt; i++)
	{
		if (i == clnt_cnt - 1)
		{
			strncat(listMessage, clnt_name[i], strlen(clnt_name[i]));
			strcat(listMessage, "\n");
			break;
		}
		strncat(listMessage, clnt_name[i], strlen(clnt_name[i]));
		strcat(listMessage, ", ");
	}

	
	pthread_mutex_unlock(&mutx);
	write(clnt_sock, listMessage, strlen(listMessage));
	initStr(listMessage, strlen(listMessage));
}


void initStr(char *msg, int len)
{
	int i;
	for (i = 0; i < len; i++)
	{
		msg[i] = 0;
	}
}


int secretCheck(char *msg, int len)
{
	int i;
	for (i = 0; i < len; i++)
	{
		if (msg[i] == '#')
		{
			return 1;
		}
	}

	return 0;

}
int secretCheck2(char *msg, int len)
{
	int i;
	int num;
	int count = 0;
	for (i = 0; i < len; i++)
	{
		if (msg[i] == '#')
		{
			num = i;
			break;
		}
	}
	if (msg[num + 1] == 32)
		return 0;

	return 1;


}

int secretSend(char *msg,char *rename, int len)
{
	int i, j = 0;
	int num;
	int count = 0;
	int clnt_sock;
	int flag = 0;
	char name[NAME_SIZE] = { 0, };
	char Message[BUF_SIZE];
	char lastMessage[BUF_SIZE];

	
	pthread_mutex_lock(&mutx);
	for (i = 0; i < len; i++)
	{
		if (msg[i] == '#')
		{
			num = i + 1;
			break;
		}
	}
	for (i = num; i < len; i++)
	{
		if (msg[i] == 32)
		{
			num = i + 1;
			break;
			
		}
		name[j++] = msg[i];
	}
	j = 0;
	for (i = num; i < len; i++)
	{
		Message[j++] = msg[i];
	}
	Message[j] = 0;

	for (i = 0; i < clnt_cnt; i++)
	{
		if (!strcmp(name, clnt_name[i]))
		{
			clnt_sock = clnt_socks[i];
			flag = 1;
			break;
		}
		
	}
	pthread_mutex_unlock(&mutx);

	if (flag)
	{
		sprintf(lastMessage, "%s <�ӼӸ�> %s", rename, Message);
		write(clnt_sock, lastMessage, strlen(lastMessage));
		return flag;
	}
	else
		return flag;

	

	
}