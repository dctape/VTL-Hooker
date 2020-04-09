#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
//#include <sys/wait.h>
//#include <sys/time.h>
#include <unistd.h>

#define PORT 9090
#define SA struct sockaddr
#define MAXDATASIZE  8 * 1024
#define MAXPENDING 1


int buflen = 8 * 1024; /* length of buffer */
int nbuf = 2 * 1024;   /* number of buffers to send in sinkmode */

int send_to_client(int fd, void *buf, int count)
{
        register int cnt;

        cnt = write(fd, buf, count);

        return cnt;
}

// void app(int sockfd)
// {
//         char rcv_buf[MAXDATASIZE];
//         int n, numbytes;
//         printf("Reception from data sent by client tcp:\n");
//         for (;;)
//         {
//                 bzero(rcv_buf, sizeof(rcv_buf));
//                 /* Lecture du message du client */
//                 if ((numbytes = recv(sockfd, rcv_buf, MAXDATASIZE, 0)) == -1)
//                 {
//                         perror("recv");
//                         exit(1);
//                 }
//                 rcv_buf[numbytes] = '\0';

//                 /* affichage du message du client   // efbonfoh : au lieu d'un simple, ouvrir un fichier en écriture et y écrire 
// 					      // les données reçues de façon à les sauvegarder
//         printf("Client : %sServeur :", buffer); */
//                 printf("%s\n", rcv_buf);
//                 bzero(rcv_buf, sizeof(rcv_buf));
//                 n = 0;

//                 // copie du message du serveur dans le buffer
//                 /*while((buffer[n++] = getchar()) != '\n')
// 		;
//         // envoie du message au client 
// 		if (send(sockfd, buffer, strlen(buffer), 0) == -1){
// 			perror("send ");
// 			exit(1);
// 		}
// 		if ((strncmp(buffer, "exit", 4)) == 0){
// 			printf("Server exit...\n");
// 			break;
// 		} */
//         }
// }

void pattern( char *cp, int cnt )
{
	char c;
	c = 0;
	while( cnt-- > 0 )  {
		while( !isprint((c&0x7F)) )  c++;
		*cp++ = (c++&0x7F);
	}
}

int main(int argc, char *argv[])
{
        int sockfd, csock, len;
        struct sockaddr_in servaddr, csin;

        /* Création de socket */
        if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1) {
                perror("socket");
                exit(1);
        }
        printf("Socket crée..\n");
        //bzero(&servaddr, sizeof(servaddr));
        memset(&servaddr, 0, sizeof(servaddr));

        /* Assignation de port et d'@IP */
        servaddr.sin_family = AF_INET;
        servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
        servaddr.sin_port = htons(PORT);

        /* Binding de la socket avec l'@socket */
        if (bind(sockfd, (SA *)&servaddr, sizeof(servaddr)) == -1) {
                perror("bind");
                exit(1);
        }
        printf("Adresse attachée au socket..\n");

        /* Mettre le serveur en écoute  */
        if (listen(sockfd, MAXPENDING) == -1) {
                perror("listen");
                exit(1);
        }
        printf("Le serveur écoute..\n");

        len = sizeof(csin);
        /* accepter les données venant d'un client et les vérifier */
        if ((csock = accept(sockfd, (SA *)&csin, (unsigned *)&len)) == -1) {
                perror("accept");
                exit(1);
        }
        printf("Le serveur a accepté le client..\n");

        /* Echange Client - Serveur */
        // Le serveur envoie des données au client

        char *buf;
        buf = calloc (1, MAXDATASIZE *sizeof(char));
        if (!buf)
                goto close;
        pattern(buf, MAXDATASIZE);

        send_to_client(csock, buf,MAXDATASIZE);

        //app(csock);

close:
        /* Fermeture de la socket */
        close(sockfd);

        return 0;
}
