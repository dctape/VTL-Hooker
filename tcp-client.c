/*
 * Client tcp
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <netdb.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <unistd.h>


#define SA struct sockaddr 
#define MAXDATASIZE 100
#define PORT 8080

void app(int sockfd)
{
	char buffer[MAXDATASIZE];
	int n, numbytes;
	printf("Début de la conversation. \n");
	for(;;){
		bzero(buffer, sizeof(buffer));
		n  = 0;
		printf("Client : ");
		while((buffer[n++] = getchar()) != '\n')
		;
		if (send(sockfd, buffer, strlen(buffer), 0) == -1){
			perror("send ");
			exit(1);
		}
		
		bzero(buffer, sizeof(buffer));
		if((numbytes = recv(sockfd, buffer, MAXDATASIZE, 0)) == -1){
			perror("recv");
			exit(1);
		}
		buffer[numbytes] = '\0';
		printf("Serveur : %s", buffer);
		if ((strncmp(buffer, "exit", 4)) == 0){
			printf("Client exit...\n");
			break;
		}

	}
}

int main(int argc, char *argv[])
{
	int sockfd;

	struct hostent *hostinfo = NULL;
	struct sockaddr_in servaddr; /* connector's address information */

	const char *addr = argv[1];

	if (argc != 2){
		fprintf(stderr, "usage : ??");
		exit(1);
	}
	if((hostinfo = gethostbyname(argv[1])) == NULL){
		herror("gethostbyname");
	}

	/* création de la socket */
	if((sockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket");
		exit(1);
	}

	/* remplir avec les infos d'adressage du serveur */
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = inet_addr(addr);
	servaddr.sin_port = htons(PORT);


	/* connexion du client au serveur */

	if (connect(sockfd, (SA*)&servaddr, sizeof(servaddr)) == -1){
		perror("connect()");
		exit(1);
	}


	/*const char* data_to_send = " Hello, world !\n";
	while(1){
		if (send(sockfd, data_to_send, strlen(data_to_send), 0) == -1){
			perror("send ");
			exit(1);
		}
		printf("Après la fonction send\n");

		if(numbytes = recv(sockfd, buffer, MAXDATASIZE, 0) == -1){
			perror("recv");
			exit(1);
		}

		buffer[numbytes] = '\0'; // est-ce nécessaire ?

		printf("Reçu dans le pid=%d, text=: %s \n",getpid(), buffer );
		sleep(1);

	} */

	/* Echange client-serveur */
	app(sockfd);

	/* Fermeture de la socket */
	close(sockfd);

	return 0;

}
