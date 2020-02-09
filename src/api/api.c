
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <linux/if_link.h> // XDP flags





#include "../common/util.h"
#include "../adaptor/adaptor.h"
//TODO: change with <vtl/..>
#include "../../include/vtl.h"


/*** Fonctions de gestion d'un VTL socket ***/

/**
 *  Success xsk_socket or NULL on failure
 **/ 
static struct xsk_socket_info *
vtl_create_insock(char *ifname, char *err_buf)
{
        /* af_xdp socket */
        __u32 xdp_flags = 0;
        __u16 xsk_bind_flags = 0;
        int xsk_if_queue = 0;
        struct xsk_umem_info umem = {0};

        struct xsk_socket_info *xsk_socket = NULL;

        xdp_flags &= ~XDP_FLAGS_MODES;   /* Clear flags */
        xdp_flags |= XDP_FLAGS_SKB_MODE; /* Set   flag */              
        xsk_bind_flags &= XDP_ZEROCOPY;
        xsk_bind_flags |= XDP_COPY;

        //INFO: NIC essentiel pour la création d'un socket af_xdp.
        xsk_socket = adaptor__create_xsk_sock(ifname, xdp_flags, xsk_bind_flags, 
                                        xsk_if_queue, &umem, err_buf);
        
        return xsk_socket;
}

/**
 * >= 0 success ; < 0 failure
 **/ 
static int
vtl_create_outsock(char *err_buf)
{
        return adaptor__create_raw_sock(AF_INET, IPPROTO_RAW, err_buf);
}

struct vtl_socket *
vtl_create_socket(int mode, char *ifname, char *err_buf)
{
        struct vtl_socket *sock = NULL;
        sock = malloc(sizeof(struct vtl_socket));
        if (sock == NULL) {
                snprintf(err_buf, VTL_ERRBUF_SIZE, 
                "ERR: memory allocation for vtl socket failed\n");
                return NULL;
        }
        memset(sock, 0, sizeof(struct vtl_socket));

        sock->mode = mode;

        /* Socket creation according mode */
        switch (sock->mode) {
        
        case VTL_MODE_INOUT:
        case VTL_MODE_IN :
                sock->xsk_socket = vtl_create_insock(ifname, err_buf);
                if (sock->xsk_socket == NULL)
                        return NULL;
                
                if (sock->mode != VTL_MODE_INOUT)
                        break;

        case VTL_MODE_OUT:
                sock->af_inet_sock = vtl_create_outsock(err_buf);
                if (sock->af_inet_sock < 0)
                        return NULL;
                break;
        
        default :
                snprintf(err_buf, VTL_ERRBUF_SIZE, "ERR: unknown mode\n");
                return NULL;  

        }

        // TODO : assign an ID or port number to application ?

        return sock;
}

void
vtl_close_socket(struct vtl_socket *sock)
{
        // TODO: Select according mode ?
        if (sock->xsk_socket != NULL)
                xsk_socket__delete(sock->xsk_socket->xsk);

        // TODO: CLose af_inet descriptor
}

/*** Fonctions de gestion d'un vtl_endpoint ***/
void
vtl_add_interface(struct vtl_endpoint *endpoint, char *ifname)
{
        //TODO: Verify that sizeof(ifname) < sizeof(endpoint->ifname)
        // Signal an error when verification failed
        strcpy(endpoint->ifname, ifname);

}

void
vtl_add_ip4(struct vtl_endpoint *endpoint, char *in_addr)
{
        //TODO: Verify that sizeof(ifname) < sizeof(endpoint->ifname)
        // Signal an error when verification failed
        strcpy(endpoint->in_addr, in_addr);
}

// void
// vtl_add_ip6()
// {

// }

void
vtl_add_hostname(struct vtl_endpoint *endpoint, char *hostname)
{
        //TODO: Verify that sizeof(ifname) < sizeof(endpoint->ifname)
        // Signal an error when verification failed
        strcpy(endpoint->hostname, hostname);
}

/*** Fonctions de gestion d'un canal de communication VTL ***/
struct vtl_channel *
vtl_open_channel(struct vtl_socket *sock, 
                struct vtl_endpoint *local,
                struct vtl_endpoint *remote,
                int flags,
                char *err_buf)
{
        struct vtl_channel *ch = NULL;
        ch = malloc(sizeof(struct vtl_channel));
        memset(ch, 0, sizeof(struct vtl_channel));

        /** VTL channel preparation **/
        // Test before assignment
        if (local == NULL && remote == NULL){
                snprintf(err_buf, VTL_ERRBUF_SIZE,
                "ERR: Endpoints not correct\n");
                return NULL;
        }
        else if(local == NULL && flags == VTL_LOCAL_AUTOFILL) {
                //auto fill local endpoint
                //TODO : get automatically ip src
                strcpy(local->in_addr, IP_SRC_VM);
        }
        ch->local = local;
        ch->remote = remote;

        // allocation rcvbuf according sock type
        switch (sock->mode) {
        case VTL_MODE_INOUT:
        case VTL_MODE_IN :
                ch->rcvbuf->rcv_data = allocate_ustrmem(VTL_DATA_SIZE);
                if (sock->mode != VTL_MODE_INOUT)
                        break;
        case VTL_MODE_OUT:
                ch->sndbuf->ip_flags = allocate_intmem(4);
                ch->sndbuf->snd_data = allocate_ustrmem(VTL_DATA_SIZE);
                ch->sndbuf->snd_packet = allocate_ustrmem (IP_MAXPACKET);
                break;

        }

        /** vtl negotiation **/

        return ch;

}

// void
// vtl_close_channel()
// {

// }

// struct vtl_channel *
// vtl_accept()
// {

// }

/*** Fonctions d'émission et de réception ***/
int
vtl_send(struct vtl_socket *sock, struct vtl_channel *ch,
        uint8_t *data, size_t datalen,
        char *err_buf)
{
        int ret;

        /* Fill with data to send */
        ch->sndbuf->snd_data = data;
        ch->sndbuf->snd_datalen = datalen;

        //TODO: Revoir cette partie
        /* send vtl packet */
        ret = adaptor__send_packet(sock->af_inet_sock, ch->sndbuf->snd_packet,
                                &ch->sndbuf->vtlh, &ch->sndbuf->iphdr,
                                ch->remote->hostname, ch->remote->in_addr,
                                ch->local->in_addr, ch->sndbuf->ip_flags,
                                ch->sndbuf->snd_data, ch->sndbuf->snd_datalen,
                                err_buf);
        
        if (ret < 0) 
                return -1;
        
        //TODO: memset snd_data ??

        return 0;

}

void 
vtl_receive(struct vtl_socket *sock, struct vtl_recv_params *rp)
{
        adaptor__rcv_data(sock->xsk_socket, sock->xsk_poll_mode, rp);
}












/*** Autres fonctions ***/
// vtl_md_t *
// vtl_init(char *ifname, char *src_ip, int mode, char *err_buf)
// {
//         //TODO: ajouter un flag pour l'utilisation de la vtl
//         // en réception comme en émission
//         int ret;
//         __u32 xdp_flags = 0;
//         __u16 xsk_bind_flags = 0;
//         int xsk_if_queue = 0;
//         //TODO: put it vtl metadata struct
//         struct xsk_umem_info umem = {0}; // always initialize!!! 
//         vtl_md_t *vtl_md = NULL;
//         //TODO: Make test malloc return
//         vtl_md = (vtl_md_t *)malloc(sizeof(vtl_md_t));
//         memset(vtl_md, 0, sizeof(vtl_md_t));
//         switch (mode)
//         {
//         case VTL_MODE_IN:
//                 /* xdp => config af_xdp sock */
//                 /* Utilisation de socket af_xdp */                              
//                 xdp_flags &= ~XDP_FLAGS_MODES;   /* Clear flags */
//                 xdp_flags |= XDP_FLAGS_SKB_MODE; /* Set   flag */              
//                 xsk_bind_flags &= XDP_ZEROCOPY;
//                 xsk_bind_flags |= XDP_COPY; 
//                 vtl_md->xsk_poll_mode = false;             
//                 vtl_md->xsk_socket = adaptor__create_xsk_sock(ifname, xdp_flags, xsk_bind_flags, 
//                                         xsk_if_queue, &umem, err_buf);
//                 if (vtl_md->xsk_socket == NULL) {

//                         return NULL;
//                 }

//                 /* utilisation de perf_event buffer */

//                 sem_init(&vtl_md->rcv_sem, 0, 0);
//                 vtl_md->rcv_data_list = adaptor__init_rlist();
//                 vtl_md->rcv_data = allocate_ustrmem(VTL_DATA_SIZE);

//                 break;
//         case VTL_MODE_OUT:
//                 /* tc => config raw socket */
//                 vtl_md->af_inet_sock = adaptor__create_raw_sock(AF_INET, IPPROTO_RAW, err_buf);
//                 if (vtl_md->af_inet_sock < 0) {
//                         return NULL;
//                 }
//                 ret = adaptor__config_raw_sock(vtl_md->af_inet_sock, ifname, err_buf);
//                 if (ret < 0) {
//                         return NULL;
//                 }
//                 vtl_md->snd_data = allocate_ustrmem(VTL_DATA_SIZE);
//                 vtl_md->snd_packet = allocate_ustrmem (IP_MAXPACKET);
//                 vtl_md->ip_flags = allocate_intmem(4);
//                 break;

//         case VTL_MODE_INOUT:
//                 /** af_xdp **/
//                 // xdp_flags &= ~XDP_FLAGS_MODES;   /* Clear flags */
//                 // xdp_flags |= XDP_FLAGS_SKB_MODE; /* Set   flag */
//                 // xsk_bind_flags &= XDP_ZEROCOPY;
//                 // xsk_bind_flags |= XDP_COPY;
//                 // vtl_md->xsk_poll_mode = false;               
//                 // vtl_md->xsk_socket = adaptor_create_xsk_sock(ifname, xdp_flags, xsk_bind_flags, 
//                 //                         xsk_if_queue, &umem, err_buf);
//                 // if (vtl_md->xsk_socket == NULL) {
//                 //         return NULL;
//                 // }

//                 /** perf_event buffer **/
//                 sem_init(&vtl_md->rcv_sem, 0, 0);
//                 vtl_md->rcv_data_list = adaptor__init_rlist();

//                 /** raw socket **/
//                 vtl_md->rcv_data = allocate_ustrmem(VTL_DATA_SIZE);
//                 vtl_md->af_inet_sock = adaptor__create_raw_sock(AF_INET, IPPROTO_RAW, err_buf);
//                 if (vtl_md->af_inet_sock < 0) {
//                         return NULL;
//                 }
//                 ret = adaptor__config_raw_sock(vtl_md->af_inet_sock, ifname, err_buf);
//                 if (ret < 0) {
//                         return NULL;
//                 }
//                 vtl_md->snd_data = allocate_ustrmem(VTL_DATA_SIZE);
//                 vtl_md->snd_packet = allocate_ustrmem (IP_MAXPACKET);
//                 vtl_md->ip_flags = allocate_intmem(4);
//                 break;

//         default:
//                 snprintf(err_buf, VTL_ERRBUF_SIZE, "ERR: unknown mode\n");
//                 return NULL;
//                 break;
//         }

      
//         /* configure addressing informations */
//         //TODO : Preferably get automatically src_ip
//         strcpy(vtl_md->src_ip, src_ip);

//         return vtl_md;
// }

// struct vtl_socket *
// vtl_socket_create(int mode, char *ifname, char *err_buf)
// {
//         struct vtl_socket *vtl_sock = NULL;
//         vtl_sock = malloc(sizeof(struct vtl_socket));
//         if (vtl_sock == NULL) {
//                 snprintf(err_buf, ERRBUF_SIZE, 
//                 "ERR: memory allocation for vtl socket failed\n");
//                 return NULL;
//         }

//         /* Socket creation according mode */
//         switch (mode) {
//         case VTL_MODE_INOUT :
//         case VTL_MODE_IN : /* af_xdp socket */
//                 break;
//         case VTL_MODE_OUT : /* af_inet socket */
//                 break;
//         default :
//                 snprintf(err_buf, VTL_ERRBUF_SIZE, "ERR: unknown mode\n");
//                 return NULL;
//                 break;
//         }

// }


// // vtl_snd: envoie des données via la vtl
// int vtl_snd(vtl_md_t *vtl_md, char *target,char *dst_ip, uint8_t *data, 
//                 size_t datalen, char *err_buf)
// {
//         int ret;
//         /* Configure destination address */
//         strcpy(vtl_md->dst_ip, dst_ip);
//         strcpy(vtl_md->target, target);

//         /* Fill with data to send */
//         vtl_md->snd_data = data;
//         vtl_md->snd_datalen = datalen;

//         //TODO: Revoir cette partie
//         /* send vtl packet */
//         ret = adaptor__send_packet(vtl_md->af_inet_sock, vtl_md->snd_packet, &vtl_md->vtlh, &vtl_md->iphdr,  
//                         vtl_md->target, vtl_md->dst_ip, vtl_md->src_ip, 
//                         vtl_md->ip_flags, vtl_md->snd_data, vtl_md->snd_datalen, err_buf);
//         if (ret < 0) {
//                 return -1;
//         }

//         //TODO: memset snd_data ?

//         return 0;
// }

// //vtl_rcv: recoit des données via la vtl
// //TODO: add flags ??
// void
// vtl_rcv(vtl_md_t *vtl_md, FILE *rx_file)
// {
//         //TODO: add return code
//         adaptor__rcv_data(vtl_md->xsk_socket, vtl_md->xsk_poll_mode, rx_file,
//                         &vtl_md->cnt_pkts, &vtl_md->cnt_bytes);

// }

// /** receive data with perf_event buffer **/
// // vtl_listen:
// //retval : 0 success , -1 error
// int
// vtl_listen(vtl_md_t *vtl_md)
// {
//         /* Vérifier que la fonction ARQ a été déployée */
//         vtl_md->perf_map_fd = perf_map_fd;
//         return adaptor__listen_thread(vtl_md);
// }

// int 
// vtl_listen_stop(vtl_md_t *vtl_md)
// {
//         return adaptor__stop_listen_thread(vtl_md);
// }

// ssize_t
// vtl_rcv_perf(vtl_md_t *vtl_md, void *buf, ssize_t len)
// {
//         vtl_md->rcv_datalen = adaptor__rcv_perf_data(&vtl_md->rcv_sem, 
//                                                 vtl_md->rcv_data_list,
//                                                 vtl_md->rcv_data);
//         //TODO: Comparer len et rcv_datalen
        
//         memcpy(buf, vtl_md->rcv_data, vtl_md->rcv_datalen);

//         return vtl_md->rcv_datalen; 
// }