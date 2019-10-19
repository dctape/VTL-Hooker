
#ifndef __RAW_SOCKET_H
#define __RAW_SOCKET_H

#include <netinet/ip.h>       // struct ip and IP_MAXPACKET (which is 65535)
#include <net/if.h>           // struct ifreq
#include <sys/ioctl.h>        // macro ioctl is defined
#include <sys/types.h>        // needed for socket(), uint8_t, uint16_t, uint32_t

#include "../../lib/vtl_util.h"

#define IP4_HDRLEN            20 // IPv4 header length

//TODO


//TODO: Find later a better name
struct inject_config {

        uint8_t *data;
        int datalen;
        uint8_t *packet;
        
        struct vtlhdr vtlh;
        int *ip_flags;
        char *src_ip;
        char *dst_ip;
        char *interface;
        char *target; // Why ???

        struct ip iphdr;
        struct ifreq ifr;

};

char *allocate_strmem (int len);
uint8_t *allocate_ustrmem (int len);
int *allocate_intmem (int len);
int *allocate_intmem (int len);

int ip4_hdr_config(struct inject_config *cfg);
void ip4_pkt_assemble(struct inject_config *cfg);



#endif /* __RAW_SOCKET_H */
