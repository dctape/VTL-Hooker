
#ifndef __VTL_STRUCTURES_H
#define __VTL_STRUCTURES_H

#include <linux/types.h>
#include <net/if.h>           // struct ifreq
#include <netinet/ip.h>       // struct ip and IP_MAXPACKET (which is 65535)
#include <stdint.h>

#include "../../common/xdp_user_helpers.h"
#include "../../common/xsk_user_helpers.h"

/* En-tête de paquet vtl */
typedef struct vtl_header vtlhdr_t;
struct vtl_header {

	uint16_t checksum;
};



/* vtl metadata */
typedef struct vtl_metadata vtl_md_t;
struct vtl_metadata {
        
        uint8_t *snd_data;
        size_t snd_datalen;

        uint8_t *rcv_data;
        size_t rcv_datalen;

        vtlhdr_t vtlh;

        int *ip_flags;
        char *src_ip;
        char *dst_ip;
        char *interface;
        char *target;
        struct ifreq ifr;// TODO: is it necessary ?
        struct ip iphdr;

        int af_inet_sock;
        struct xsk_socket_info *xsk_socket;
        xdp_cfg_t *xdp_cfg;
        
        bool xsk_poll_mode;
        uint8_t *snd_packet;
};

#endif /* __VTL_STRUCTURES_H */