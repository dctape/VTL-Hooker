
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <linux/if_link.h> // XDP flags

//TODO: change with <vtl/..>
#include "../../include/vtl/vtl_macros.h"
#include "../../include/vtl/vtl_structures.h"

#include "../common/util.h"
#include "../adaptor/adaptor_send.h"
#include "../adaptor/adaptor_receive.h"

#include "api.h"

vtl_md_t *
vtl_init(char *ifname, char *src_ip, int mode, char *err_buf)
{
        //TODO: ajouter un flag pour l'utilisation de la vtl
        // en réception comme en émission
        int ret;
        __u32 xdp_flags = 0;
        __u16 xsk_bind_flags = 0;
        int xsk_if_queue = 0;
        //TODO: put it vtl metadata struct
        struct xsk_umem_info umem = {0}; // always initialize!!! 
        vtl_md_t *vtl_md = NULL;
        //TODO: Make test malloc return
        vtl_md = (vtl_md_t *)malloc(sizeof(vtl_md_t));
        memset(vtl_md, 0, sizeof(vtl_md_t));
        switch (mode)
        {
        case VTL_MODE_IN:
                /* xdp => config af_xdp sock */                              
                xdp_flags &= ~XDP_FLAGS_MODES;   /* Clear flags */
                xdp_flags |= XDP_FLAGS_SKB_MODE; /* Set   flag */              
                xsk_bind_flags &= XDP_ZEROCOPY;
                xsk_bind_flags |= XDP_COPY; 
                vtl_md->xsk_poll_mode = false;             
                vtl_md->xsk_socket = adaptor_create_xsk_sock(ifname, xdp_flags, xsk_bind_flags, 
                                        xsk_if_queue, &umem, err_buf);
                if (vtl_md->xsk_socket == NULL) {

                        return NULL;
                }
                vtl_md->rcv_data = allocate_ustrmem(VTL_DATA_SIZE);

                break;
        case VTL_MODE_OUT:
                /* tc => config raw socket */
                vtl_md->af_inet_sock = adaptor_create_raw_sock(AF_INET, IPPROTO_RAW, err_buf);
                if (vtl_md->af_inet_sock < 0) {
                        return NULL;
                }
                ret = adaptor_config_raw_sock(vtl_md->af_inet_sock, ifname, err_buf);
                if (ret < 0) {
                        return NULL;
                }
                vtl_md->snd_data = allocate_ustrmem(VTL_DATA_SIZE);
                vtl_md->snd_packet = allocate_ustrmem (IP_MAXPACKET);
                vtl_md->ip_flags = allocate_intmem(4);
                break;

        case VTL_MODE_INOUT:
                
                xdp_flags &= ~XDP_FLAGS_MODES;   /* Clear flags */
                xdp_flags |= XDP_FLAGS_SKB_MODE; /* Set   flag */
                xsk_bind_flags &= XDP_ZEROCOPY;
                xsk_bind_flags |= XDP_COPY;
                vtl_md->xsk_poll_mode = false;               
                vtl_md->xsk_socket = adaptor_create_xsk_sock(ifname, xdp_flags, xsk_bind_flags, 
                                        xsk_if_queue, &umem, err_buf);
                if (vtl_md->xsk_socket == NULL) {
                        return NULL;
                }
                vtl_md->rcv_data = allocate_ustrmem(VTL_DATA_SIZE);
                vtl_md->af_inet_sock = adaptor_create_raw_sock(AF_INET, IPPROTO_RAW, err_buf);
                if (vtl_md->af_inet_sock < 0) {
                        return NULL;
                }
                ret = adaptor_config_raw_sock(vtl_md->af_inet_sock, ifname, err_buf);
                if (ret < 0) {
                        return NULL;
                }
                vtl_md->snd_data = allocate_ustrmem(VTL_DATA_SIZE);
                vtl_md->snd_packet = allocate_ustrmem (IP_MAXPACKET);
                vtl_md->ip_flags = allocate_intmem(4);
                break;

        default:
                snprintf(err_buf, VTL_ERRBUF_SIZE, "ERR: unknown mode\n");
                return NULL;
                break;
        }

      
        /* configure addressing informations */
        //TODO : Preferably get automatically src_ip
        strcpy(vtl_md->src_ip, src_ip);

        return vtl_md;
}

// vtl_snd: envoie des données via la vtl
int vtl_snd(vtl_md_t *vtl_md, char *target,char *dst_ip, uint8_t *data, 
                size_t datalen, char *err_buf)
{
        int ret;
        /* Configure destination address */
        strcpy(vtl_md->dst_ip, dst_ip);
        strcpy(vtl_md->target, target);

        /* Fill with data to send */
        vtl_md->snd_data = data;
        vtl_md->snd_datalen = datalen;

        //TODO: Revoir cette partie
        /* send vtl packet */
        ret = adaptor_send_packet(vtl_md->af_inet_sock, vtl_md->snd_packet, &vtl_md->vtlh, &vtl_md->iphdr,  
                        vtl_md->target, vtl_md->dst_ip, vtl_md->src_ip, 
                        vtl_md->ip_flags, vtl_md->snd_data, vtl_md->snd_datalen, err_buf);
        if (ret < 0) {
                return -1;
        }

        //TODO: memset snd_data ?

        return 0;
}

//vtl_rcv: recoit des données via la vtl
//TODO: add flags ??
void
vtl_rcv(vtl_md_t *vtl_md, FILE *rx_file)
{
        //TODO: add return code
        adaptor_rcv_data(vtl_md->xsk_socket, vtl_md->xsk_poll_mode, rx_file,
                        &vtl_md->cnt_pkts, &vtl_md->cnt_bytes);

}

/** receive data with perf_event buffer **/
// vtl_listen:
//retval : 0 success , -1 error
int
vtl_listen(vtl_md_t *vtl_md)
{
        return adaptor_listen_thread(vtl_md);
}

int 
vtl_listen_stop(vtl_md_t *vtl_md)
{
        return adaptor_stop_listen_thread(vtl_md);
}

ssize_t
vtl_rcv_perf(vtl_md_t *vtl_md, void *buf, ssize_t len)
{
        vtl_md->rcv_datalen = adaptor_rcv_perf_data(&vtl_md->rcv_sem, 
                                                vtl_md->rcv_data_list,
                                                vtl_md->rcv_data);
        //TODO: Comparer len et rcv_datalen
        
        memcpy(buf, vtl_md->rcv_data, vtl_md->rcv_datalen);

        return vtl_md->rcv_datalen; 
}