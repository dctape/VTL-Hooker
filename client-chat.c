/*
 * Chat client tcp 
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
#define MAXDATASIZE 1000
#define PORT 9091
#define C_PORT	9092
char *dest_addr = "192.168.130.142"; // @IP vm3


void app(int sockfd)
{
	//char rcv_snd_buf[MAXDATASIZE];
	char snd_buf[MAXDATASIZE];
	/* bzero(snd_buf, sizeof(snd_buf));  // important for ...
	char *data = "Receiving data from client...";
	memcpy(snd_buf, data, strlen(data)); */
	int n, numbytes;
	printf("Début de la conversation. \n");
	//printf("Client : Envoi des données...\n");
	for(;;){
		bzero(snd_buf, sizeof(snd_buf));
		n  = 0;
		printf("Client : ");
		//printf("Client : Envoi des données...\n");
		while((snd_buf[n++] = getchar()) != '\n') // efbonfoh : ouvrir un fichier lambda et en envoyé le contenu.
		;
		if (send(sockfd, snd_buf, strlen(snd_buf), 0) == -1){
			perror("send ");
			exit(1);
		} 

		/* if (send(sockfd, snd_buf, strlen(snd_buf), 0) == -1){
			perror("send ");
			exit(1);
		}
		printf("Data sent.\n"); */ 
		
		bzero(snd_buf, sizeof(snd_buf));
		if((numbytes = recv(sockfd, snd_buf, MAXDATASIZE, 0)) == -1){
			perror("recv");
			exit(1);
		}
		snd_buf[numbytes] = '\0';
		printf("Serveur : %s", snd_buf);
		if ((strncmp(snd_buf, "exit", 4)) == 0){
			printf("Client exit...\n");
			break;
		} 

		//sleep(5);
		

	}
}


int main(int argc, char *argv[])
{
	int sockfd, err;

	struct hostent *hostinfo = NULL;
	struct sockaddr_in servaddr; /* connector's address information */

	/*const char *addr = argv[1];

	if (argc != 2){
		fprintf(stderr, "usage : ??");
		exit(1);
	} */
	if((hostinfo = gethostbyname(dest_addr)) == NULL){
		herror("gethostbyname");
	}

	/* création de la socket */
	if((sockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket");
		exit(1);
	}

	// Bind 
	struct sockaddr_in caddr;
    memset(&caddr, 0, sizeof(struct sockaddr_in));
    caddr.sin_family = AF_INET;
	caddr.sin_addr.s_addr = inet_addr("0.0.0.0"); // important, pas 127.0.0.1
    caddr.sin_port = htons(C_PORT);
	err = bind(sockfd, (struct sockaddr *)&caddr, sizeof(caddr));
	if (err < 0) {
		perror("bind socket failed()\n");
		return errno;
	} 

	/* remplir avec les infos d'adressage du serveur */
	servaddr.sin_family = AF_INET;
	servaddr.sin_addr.s_addr = inet_addr(dest_addr);
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

		if(numbytes = recv(sockfd, snd_buf, MAXDATASIZE, 0) == -1){
			perror("recv");
			exit(1);
		}

		snd_buf[numbytes] = '\0'; // est-ce nécessaire ?

		printf("Reçu dans le pid=%d, text=: %s \n",getpid(), snd_buf );
		sleep(1);

	} */

	/* Echange client-serveur */
	app(sockfd);

	/* Fermeture de la socket */
	close(sockfd);

	return 0;

}