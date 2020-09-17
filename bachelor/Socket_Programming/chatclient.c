//2012335044 B�� ������
//Ŭ���̾�Ʈ �ҽ��ڵ�
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h> 
#include <string.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <pthread.h>

#define BUF_SIZE 100
#define NAME_SIZE 20
#define CLNTMAX 5

void * send_msg(void * arg);
void * recv_msg(void * arg);
void error_handling(char * msg);


char name[NAME_SIZE];
char msg[BUF_SIZE];

int main(int argc, char *argv[])
{
	int sock;
	int namebit;
	int clnt_max;
	struct sockaddr_in serv_addr;
	pthread_t snd_thread, rcv_thread;
	void * thread_return;
	if (argc != 4) {
		printf("Usage : %s <IP> <port> <name>\n", argv[0]);
		exit(1);
	}

	sprintf(name, "%s", argv[3]);
	sock = socket(PF_INET, SOCK_STREAM, 0);

	memset(&serv_addr, 0, sizeof(serv_addr));
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = inet_addr(argv[1]);
	serv_addr.sin_port = htons(atoi(argv[2]));

	if (connect(sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) == -1)
		error_handling("connect() error");

	write(sock, name, strlen(name));         // �ڽ��� ID�� ������
	read(sock, &namebit, sizeof(namebit));   // �ߺ����� �÷��׸� �޴´�.
	read(sock, &clnt_max, sizeof(clnt_max)); // ä�ù� �ο� ���� �޴´�.
	
	/* ä�ù� �ο� ������ ����� �ڵ�
	if (clnt_max > CLNTMAX)
	{
		printf(">>> ���� ä�ù� ��Ȳ (5/5) <<<\n");
		printf("ä�ù� �ο��� �� á���ϴ�. ��� �� �ٽ� �õ��� �ּ���!\n");
		return 0;
	}
	*/
	// �ߺ��� ID ���� ���
	if (namebit)
	{
		char list[BUF_SIZE] = { 0, };
		read(sock, list, BUF_SIZE);
		printf(">>> ���� ä�ù� ��Ȳ %d �� <<<\n",clnt_max);
		printf("%s", list);
		printf("�ߺ��� ID�� �����մϴ�. �ٸ� ID�� �����ϼ���!!\n");
		return 0;
	}
	
	

	pthread_create(&snd_thread, NULL, send_msg, (void*)&sock);
	pthread_create(&rcv_thread, NULL, recv_msg, (void*)&sock);
	pthread_join(snd_thread, &thread_return);
	pthread_join(rcv_thread, &thread_return);
	close(sock);
	return 0;
}

void * send_msg(void * arg)   // send thread main
{
	int sock = *((int*)arg);
	char rename[NAME_SIZE];
	char name_msg[NAME_SIZE + BUF_SIZE];
	
	sprintf(rename, "[%s]", name);
	while (1)
	{
		
		fgets(msg, BUF_SIZE, stdin);
		if (!strcmp(msg, "q\n") || !strcmp(msg, "Q\n"))
		{
			close(sock);
			exit(0);
		}
		if (!strcmp(msg, "@\n"))
		{
			write(sock, msg, strlen(msg));
			continue;
		}
		sprintf(name_msg, "%s %s", rename, msg);
		write(sock,name_msg, strlen(name_msg));
	}
	return NULL;
}

void * recv_msg(void * arg)   // read thread main
{
	int sock = *((int*)arg);
	char name_msg[NAME_SIZE + BUF_SIZE];
	int str_len;
	

	while (1)
	{
		
		str_len = read(sock, name_msg, NAME_SIZE + BUF_SIZE - 1);
		if (str_len == -1)
			return (void*)-1;
		name_msg[str_len] = 0;
		fputs(name_msg, stdout);
		
	}
	return NULL;
}

void error_handling(char *msg)
{
	fputs(msg, stderr);
	fputc('\n', stderr);
	exit(1);
}
