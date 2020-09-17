//2012335044 B반 원유민
//서버 소스코드
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

void nameCheck(char *msg, int clnt_sock);         // 이름 추가 함수
int nameCheck2(char *conName, int clnt_sock);     // 중복 체크 함수
void list(int clnt_sock);                         // list 출력 함수
void initStr(char *msg, int len);                 // 버퍼 초기화 함수
int secretCheck(char *msg, int len);              // 귓속말 체크 함수
int secretCheck2(char *msg, int len);             // 귓속말 형식 체크 함수
int secretSend(char *msg, char *rename, int len); // 귓속말 전송 함수


// 공유 변수
int clnt_cnt = 0;             // 클라이언트 수
int clnt_socks[MAX_CLNT];     // 소켓 저장공간
char *clnt_name[CLNTMAX];     // 클라이언트 이름 저장
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
		clnt_name[clnt_cnt] = NULL;        //이름 공간 NULL 초기화
		clnt_cnt++;
		pthread_mutex_unlock(&mutx);

		printf("Client IP: %s 접속 시도 \n", inet_ntoa(clnt_adr.sin_addr));
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

	char conMessage[] = "채팅방에 접속하였습니다\n";
	char reMessage[BUF_SIZE];	


	read(clnt_sock, name, sizeof(name));      //이름을 받는다.
	nameCheck(name, clnt_sock);               //ID 를 배열에 추가한다.
	namebit = nameCheck2(name, clnt_sock);    //ID 중복 여부 2차 확인

	write(clnt_sock, &clnt_cnt, sizeof(clnt_cnt)); //클라이언트 수를 보낸다
	
	// 클라이언트 수 5명 이상이면 접속 실패를 알린다.
	/* 채팅방 인원 제한을 고려한 코드
	if (clnt_cnt > CLNTMAX)
	{
		pthread_mutex_lock(&mutx);
		//write(clnt_sock, &clnt_cnt, sizeof(clnt_cnt));
		clnt_cnt--;
		pthread_mutex_unlock(&mutx);
		printf("채팅방 인원 초과로 인한 접속 실패!!\n");
		close(clnt_sock);
		return NULL;
	}
	*/

	// 클라이언트 ID 중복을 알린다.
	if (namebit)
	{
		list(clnt_sock);
		printf("Client ID 중복으로 접속 실패!!\n");
		close(clnt_sock);
		return NULL;
	}

	printf("Client 접속 성공!!\n");
	write(clnt_sock, conMessage, strlen(conMessage));  //채팅방에 접속하였음을 알린다.
	sprintf(rename, "[%s]", name);
	sprintf(reMessage, "%s 님이 접속하였습니다\n", rename); 
	send_msg(reMessage, clnt_sock, strlen(reMessage));       //접속 여부를 보낸다.
	list(clnt_sock);                                         //목록 리스트를 보낸다.

	

	
	while ((str_len = read(clnt_sock, msg, sizeof(msg)))!=0)
	{
		//@ 입력 시 목록 출력 구간
		if (!strcmp(msg, "@\n"))
		{
			list(clnt_sock);
			initStr(msg, str_len);
			continue;
		}
		// 귓속말 보내기 구간
		if (secretCheck(msg, str_len)) //#이 있음을 확인한다.
		{
			//귓속말 형식에 맞는지 확인한다.
			if (secretCheck2(msg, str_len))
			{
				//해당 ID 존재하는지 확인
				if(secretSend(msg, rename, str_len)); 
				else // ID 존재 하지 않을 경우
				{
					char errorMessage[] = "ID가 존재하지 않습니다. 목록을 확인하세요!!\n";
					write(clnt_sock, errorMessage, strlen(errorMessage));
				}
				
				
			}
			// 귓속말 형식이 아닐 경우
			else
			{
				char errorMessage[] = "/귓속말 형식 (#ID Message)\n";
				write(clnt_sock, errorMessage, strlen(errorMessage));
				
			}
			initStr(msg, str_len);
			continue;
		}
		
		//일반 메세지 전송
		send_msg(msg, clnt_sock, str_len);
		initStr(msg, str_len);
	}

	//Ctrl + C 또는 q 입력 시 방을 나갔음을 알린다.
	sprintf(byeName, "%s", rename);
	sprintf(msg, "%s 님이 채팅방을 나갔습니다\n", byeName);
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
	sprintf(listMessage, "현재 접속자 목록 [%d]명 : ",clnt_cnt);
	
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
		sprintf(lastMessage, "%s <귓속말> %s", rename, Message);
		write(clnt_sock, lastMessage, strlen(lastMessage));
		return flag;
	}
	else
		return flag;

	

	
}