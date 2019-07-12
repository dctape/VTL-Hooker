/*
 * Code for communications over udp
 * 
*/

#include "udp.h"

#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/ioctl.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <errno.h>

#define udpsock1_port       10005
#define udpsock2_port       10006

int udpsock1; // client udp
int udpsock2; // serveur udp

char *udpsock1_to_addr = "192.168.130.142"; // vm serveur ~ hooker-vm3
char *udpsock2_to_addr = "192.168.130.141"; // vm client ~ hooker-vm2

//char *serv_addr = "127.0.0.1"; // test sur la même machine

sockaddr_in_t udpsock1_to;
sockaddr_in_t udpsock2_to;


int udp_config(void)
{   
    struct sockaddr_in addr;
    int err;
    
    // initiate udp sockets
    //udpsock1
    udpsock1 = socket(AF_INET, SOCK_DGRAM, 0);
    if(udpsock1 < 0) {
        perror("creation udpsock1 failed!");
        return errno;
    }

    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(udpsock1_port);
    err = bind(udpsock1, (struct sockaddr *)&addr, sizeof(addr));
    if (err < 0) {
		perror("bind udpsock2 failed");
		return errno;
	}

    //udpsock2
    udpsock2 = socket(AF_INET, SOCK_DGRAM, 0);
    if(udpsock2 < 0) {
        perror("creation udpsock2 failed!");
        return errno;
    }

    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(udpsock2_port);
    err = bind(udpsock2, (struct sockaddr *)&addr, sizeof(addr));
    if (err < 0) {
		perror("bind udpsock2 failed");
		return errno;
	}

    //config udp destination
    
    udpsock1_to.sin_family = AF_INET;
    udpsock1_to.sin_port = htons(udpsock2_port);
    udpsock1_to.sin_addr.s_addr = inet_addr(serv_addr); // TODO : serv addr

    udpsock2_to.sin_family = AF_INET;
    udpsock2_to.sin_port = htons(udpsock1_port);
    udpsock2_to.sin_addr.s_addr = inet_addr(serv_addr); // TODO : serv addr


    return 0;

}

int udp_snd(int sockudp, char *data, sockaddr_in_t to)
{   
    return sendto(sockudp, data, strlen(data), 0,
                (const struct sockaddr *) &to, sizeof(to));
}

int udp_rcv(int sockudp, char *data, sockaddr_in_t from)
{   
    // attention to MAXDATASIZE
    int fromsize = sizeof(from);
    return recvfrom(sockudp, data, MAXDATASIZE, 0 ,
                                (struct sockaddr*)&from, (socklen_t *)&fromsize);

}