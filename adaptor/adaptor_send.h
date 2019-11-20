
#ifndef __ADAPTOR_SEND_H
#define __ADAPTOR_SEND_H

#include <netinet/ip.h>       // struct ip and IP_MAXPACKET (which is 65535)
#include <net/if.h>           // struct ifreq
#include <sys/ioctl.h>        // macro ioctl is defined
#include <sys/types.h>        // needed for socket(), uint8_t, uint16_t, uint32_t

#include "../include/vtl/vtl_macros.h"
#include "../include/vtl/vtl_structures.h"


int adaptor_create_raw_sock(int domain, int protocol);
int adaptor_config_raw_sock(int sockfd, char* interface);

int adaptor_send_packet(int sock_fd, vtl_md_t *vtl_md);



#endif /* __ADAPTOR_SEND_H */