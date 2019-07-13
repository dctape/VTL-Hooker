/*
 *
 * fonctions spécifiques au composant adapter du Hooker
 * 
 * 
*/

#include "adapter.h"


#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <errno.h>

int sock_server;
int sock_redir;



/* wrapper pour la récupération des données de l'application legacy */
int get_data_from_redirector(char *rcv_buf)
{   
    return recv(sock_redir, rcv_buf, MAX_DATA_SIZE, 0); //sock_redir global
}

/* wrapper pour l'envoi des données vers l'application legacy */
int send_data_to_redirector(char *snd_buf)
{
    return send(sock_redir, snd_buf, strlen(snd_buf), 0);
}

/* Initialise les sockets utilisés durant la redirection */
int adapter_init_sock(void)
{   
    int hacpt;
 
    int err, one;
    struct sockaddr_in addr;
    
    // create redirection socket
    // hooker userspace server
    if((sock_server= socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket server failed");
        return errno;
	}

    // redirection socket
    if((sock_redir = socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror(" Creation of hooker redirection socket failed");
        return errno;
	}

    // hooker server configuration
    // Allow reuse
    err = setsockopt(sock_server, SOL_SOCKET, SO_REUSEADDR,
                        (char *)&one, sizeof(one));
    if(err) {
        perror("setsockopt sock server failed");
        return errno;
    } 

    // Non-blocking sockets
    err = ioctl(sock_server, FIONBIO, (char*)&one); 
    if (err < 0)
    {
            perror("ioctl server failed");
            return errno;
    }

    // Bind server socket
    memset(&addr, 0, sizeof(struct sockaddr_in));
    addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = inet_addr("0.0.0.0");
    addr.sin_port = htons(PORT_SERVER_HOOKER);
	err = bind(sock_server, (struct sockaddr *)&addr, sizeof(addr));
	if (err < 0) {
		perror("bind server failed()\n");
		return errno;
	}
    
    // listen server socket
    addr.sin_port = htons(PORT_SERVER_HOOKER);
	err = listen(sock_server, 32);
	if (err < 0) {
		perror("listen server failed()\n");
		return errno;
	}   


    //hooker redirection socket 

    // Bind sock_redir
    struct sockaddr_in caddr;
    memset(&caddr, 0, sizeof(struct sockaddr_in));
    caddr.sin_family = AF_INET;
	caddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    caddr.sin_port = htons(PORT_SOCK_REDIR);
	err = bind(sock_redir, (struct sockaddr *)&caddr, sizeof(caddr));
	if (err < 0) {
		perror("bind socket failed()\n");
		return errno;
	}

    // Initiate Connect 
	addr.sin_port = htons(PORT_SERVER_HOOKER );
	err = connect(sock_redir, (struct sockaddr *)&addr, sizeof(addr));
	if (err < 0 && errno != EINPROGRESS) {
		perror("connect socket client failed()\n");
		return errno;
	}

    // accept connection
    hacpt = accept(sock_server, NULL, NULL);
	if (hacpt < 0) {
		perror("accept server failed()\n");
		return errno;
	}

    
    return 0;
}


/* adapter configurations */
int adapter_config(void)
{

    int ret;
    /* Initialisation des sockets */
    ret = adapter_init_sock();
    if(ret < 0)
        return ret;

    /* initialisater les maps */ 
    //TODO : change position later
    /* ret = hk_init_map();
    if(ret < 0)
        return ret; */

    return 0;
}

/* fonction qui récupère les données de l'application legacy et les envoie vers le destinataire */

// retourne les données redirigées par redirector
int adapter_recvfrom_redirector(char *rcv_data) // TODO : change name later...
{
    int numbytes; // TODO : change name later...

    //bzero(rcv_data, sizeof(rcv_data));
    memset(rcv_data, 0, sizeof(rcv_data));

    numbytes = get_data_from_redirector(rcv_data);
    if(numbytes < 0) {
        perror("Get data from redirector failed\n"); // TODO : change error message
        return errno;
    }
    rcv_data[numbytes] = '\0'; // Important afin d'éviter l'apparition de données étrangères  
    //rcv_data = buffer;
    return 0;

}

// envoie les données au redirector + metadata pour trouver la bonne application vers laquelle rediriger
int adapter_sendto_redirector(char *snd_data)
{
    int ret;
    ret = send_data_to_redirector(snd_data);
    if(ret < 0) {
        perror("Send data to redirector failed\n"); //TODO : change error message
        return errno;
    }

    return 0; // or return ret
}

