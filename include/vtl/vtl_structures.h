
#ifndef __VTL_STRUCTURES_H
#define __VTL_STRUCTURES_H

#include <linux/types.h>
#include <net/if.h>     // struct ifreq
#include <netinet/ip.h> // struct ip and IP_MAXPACKET (which is 65535)
#include <stdint.h>
#include <semaphore.h>
#include <pthread.h>

//TODO: Break dependency with common folder.
#include "vtl_macros.h"
#include "../../src/common/xdp_user_helpers.h"
#include "../../src/common/xsk_user_helpers.h"


// TODO: déterminer le bon type de données
// TODO: reécrire les noms !
struct perf_rcv_data
{
        struct perf_rcv_data *next;
        uint16_t data_len;
        uint8_t *data;
};

struct perf_rcv_data_list
{
        struct perf_rcv_data *first;
        struct perf_rcv_data *last;
        int len;
}


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
        //TODO: find a better name.
        uint32_t cnt_pkts;
        uint32_t cnt_bytes;

        /* Reception with perf_event buffer */
        int perf_map_fd;
        struct perf_buffer *pb; // à garder pour libération du buffer
        sem_t rcv_sem;
        pthread_t rcv_thread;
        struct perf_rcv_data_list *rcv_data_list;



        char err_buf[VTL_ERRBUF_SIZE];
};

#endif /* __VTL_STRUCTURES_H */