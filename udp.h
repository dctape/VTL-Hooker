
#ifndef __UDP_H
#define __UDP_H

#include <netinet/in.h>
#include "config.h"

typedef struct sockaddr_in sockaddr_in_t;

extern int udpsock1; // client udp
extern int udpsock2; // serveur udp

extern sockaddr_in_t udpsock1_to;
extern sockaddr_in_t udpsock2_to;

int udp_config(void);
int udp_snd(int sockudp, char *data, sockaddr_in_t to);
int udp_rcv(int sockudp, char *data, sockaddr_in_t from);


#endif