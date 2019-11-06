
#ifndef __VTL_STRUCTURES_H
#define __VTL_STRUCTURES_H

#include <net/if.h>           // struct ifreq
#include <netinet/ip.h>       // struct ip and IP_MAXPACKET (which is 65535)
#include <stdint.h>

/* En-tête de paquet vtl */
typedef vtl_header vtlhdr_t;
struct vtl_header {

	uint16_t checksum;
};



/* vtl metadata */
typedef vtl_metadata vtl_md_t;
struct vtl_metadata {
        
        uint8_t *payload;
        size_t payload_s;

        vtlhdr_t vtlh;

        int *ip_flags;
        char *src_ip;
        char *dst_ip;
        char *interface;
        char *target;
        struct ifreq ifr;// TODO: is it necessary ?
        struct ip iphdr;
        
        uint8_t *packet;
};

#endif /* __VTL_STRUCTURES_H */