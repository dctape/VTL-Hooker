
#ifndef __HK_ADAPTER_H
#define __HK_ADAPTER_H

#include <stdlib.h>
#include "config.h"

extern int sock_server; 
extern int sock_redir;


typedef struct sockaddr_in sockaddr_in_t;


int getdata_from_redirector(char *rcv_buf);
int senddata_to_redirector(char *snd_buf);
int adapter_init_sock(void);

int adapter_config(void);
int adapter_recvfrom_redirector(char *rcv_data);
int adapter_sendto_redirector(char *snd_data);



#endif