
#ifndef __VTL_STRUCTURES_H
#define __VTL_STRUCTURES_H

#include <linux/types.h>
#include <net/if.h>     // struct ifreq
#include <netinet/ip.h> // struct ip and IP_MAXPACKET (which is 65535)
#include <stdint.h>

//TODO: Break dependency with common folder.
#include "vtl_macros.h"
#include "../../src/common/xdp_user_helpers.h"
#include "../../src/common/xsk_user_helpers.h"

/* En-tête de paquet vtl */
typedef struct vtl_header vtlhdr_t;
struct vtl_header
{

        uint16_t checksum;
};

/* vtl metadata */
typedef struct vtl_metadata vtl_md_t;
struct vtl_metadata
{

        struct xsk_socket_info *xsk_socket;
        struct xdp_config xdp_cfg;
        bool xsk_poll_mode;
        uint8_t *rcv_data;
        size_t rcv_datalen;
        
        int af_inet_sock;
        uint8_t *snd_packet;
        uint8_t *snd_data;
        size_t snd_datalen;
        vtlhdr_t vtlh;
        struct ip iphdr;
        int *ip_flags;
        char src_ip[INET_ADDRSTRLEN];
        char dst_ip[INET_ADDRSTRLEN];
        char ifname[IF_NAMESIZE];
        char target[40];
        struct ifreq ifr; // TODO: is it necessary ?
        

        char err_buf[VTL_ERRBUF_SIZE];
};

#endif /* __VTL_STRUCTURES_H */