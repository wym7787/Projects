//2012335044 B반 원유민
//클라이언트 소스코드
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

	write(sock, name, strlen(name));         // 자신의 ID를 보낸다
	read(sock, &namebit, sizeof(namebit));   // 중복여부 플래그를 받는다.
	read(sock, &clnt_max, sizeof(clnt_max)); // 채팅방 인원 수를 받는다.
	
	/* 채팅방 인원 제한을 고려한 코드
	if (clnt_max > CLNTMAX)
	{
		printf(">>> 현재 채팅방 상황 (5/5) <<<\n");
		printf("채팅방 인원이 꽉 찼습니다. 잠시 후 다시 시도해 주세요!\n");
		return 0;
	}
	*/
	// 중복된 ID 있을 경우
	if (namebit)
	{
		char list[BUF_SIZE] = { 0, };
		read(sock, list, BUF_SIZE);
		printf(">>> 현재 채팅방 상황 %d 명 <<<\n",clnt_max);
		printf("%s", list);
		printf("중복된 ID가 존재합니다. 다른 ID로 접속하세요!!\n");
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
