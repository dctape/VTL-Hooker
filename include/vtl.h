#ifndef __VTL_H
#define __VTL_H

#include <linux/types.h>
#include <net/if.h>     // struct ifreq
#include <netinet/ip.h> // struct ip and IP_MAXPACKET (which is 65535)
#include <stdint.h>
#include <semaphore.h>
#include <pthread.h>

#include "../../src/common/xdp_user_helpers.h"
#include "../../src/common/xsk_user_helpers.h"

//TODO: Is it necessary ?
#define IP4_HDRLEN            0x14 // IPv4 header length

#define IPPROTO_VTL           0xc8 //Nombre arbitraire...
/**
 *  vtl header length
 **/ 
#define VTL_HDRLEN            0x14 //Nombre arbitraire....
/**
 * vtl error buffer size 
 **/ 
#define VTL_ERRBUF_SIZE       0x100 

#define VTL_DATA_SIZE         0x400// ideal size ? 1024 ? 16k ?

#define VTL_LOCAL_NOTFILL          0x0
#define VTL_LOCAL_AUTOFILL         0x1

/** volatile **/
#define IP_SRC_VM     "192.168.130.157"
struct vtl_socket {

        /* Point d'entrée */
        struct xsk_socket_info *xsk_socket;
        bool xsk_poll_mode;

        /* Point de sortie */
        int af_inet_sock;

        /* Type ou le "mode" de la socket */
        int mode;
        //TODO: rewrite in enums ?
#define VTL_MODE_IN                0x1
#define VTL_MODE_OUT               0x2
#define VTL_MODE_INOUT             0x3

};
//Est-ce que ç'a du sens ?
enum vtl_use_mode {
        VTL_USE_MODE_IN,
        VTL_USE_MODE_OUT,
        VTL_USE_MODE_INOUT,
};

struct vtl_ctx {
        struct vtl_socket *sock;
        enum vtl_use_mode mode;
        char ifname[IF_NAMESIZE];
};

struct vtl_endpoint {

        //TODO : use only pointers ?
        char hostname[40];
        char in_addr[INET_ADDRSTRLEN];
        char in6_addr[INET6_ADDRSTRLEN];
        //char ifname[IF_NAMESIZE];
};

/* En-tête de paquet vtl */
typedef struct vtlhdr vtlhdr_t;
struct vtlhdr
{

        uint16_t checksum;
};
struct vtl_rcvbuf {
        uint8_t *rcv_data;
        size_t rcv_datalen;
};
struct vtl_sndbuf {

        struct vtlhdr vtlh;
        struct ip iphdr;
        int *ip_flags;
        struct ifreq ifr;
        uint8_t *snd_data;
        size_t snd_datalen;
        uint8_t *snd_packet;
        
};

struct vtl_channel {

        int state;
        struct vtl_endpoint *remote;
        struct vtl_endpoint *local;
        struct vtl_rcvbuf *rcvbuf;
        struct vtl_sndbuf *sndbuf;
        // Files de reception et d'émission

};
typedef void (*vtl_recv_cb)(void *ctx, uint8_t *data, uint32_t data_size);
struct vtl_recv_params {
        vtl_recv_cb recv_cb;
        void *ctx;
};

struct vtl_socket *vtl_create_socket(enum vtl_use_mode mode, char *ifname, char *err_buf);

void vtl_close_socket(struct vtl_socket *sock);

struct vtl_ctx * vtl_init_ctx(enum vtl_use_mode mode, char *ifname, char *err_buf);

void vtl_destroy_ctx(struct vtl_ctx *ctx);

//void vtl_add_interface(struct vtl_endpoint *endpoint, char *ifname);

void vtl_add_ip4(struct vtl_endpoint *endpoint, char *in_addr);

void vtl_add_hostname(struct vtl_endpoint *endpoint, char *hostname);


struct vtl_channel *vtl_open_channel(struct vtl_ctx *ctx, struct vtl_endpoint *local,
                                        struct vtl_endpoint *remote, int flags, char *err_buf);

//Temporary
struct vtl_channel *vtl_accept_channel(struct vtl_ctx *ctx,
                   struct vtl_endpoint *local,
                   struct vtl_endpoint *remote,
                   int flags,
                   char *err_buf);


int vtl_send(struct vtl_ctx *ctx, struct vtl_channel *ch, uint8_t *data, 
        size_t datalen, char *err_buf);

void vtl_receive(struct vtl_ctx *ctx, struct vtl_recv_params *rp);

#endif /* __VTL_H */