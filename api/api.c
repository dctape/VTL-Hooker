
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


//TODO: change with <vtl/..>
#include "../include/vtl/vtl_macros.h"
#include "../include/vtl/vtl_structures.h"
// Make compilation failed
//#include "../include/vtl/vtl_util.h" 

#include "../common/util.h"

#include "../adaptor/adaptor_send.h"
#include "../adaptor/adaptor_receive.h"


// vtl_config: configure vtl_md object
int
vtl_config(vtl_md_t *vtl_md, char *interface, char *src_ip)
{
        //TODO: ajouter un flag pour l'utilisation de la vtl
        // en réception comme en émission

        /* Allocate memory for various arrays */
        vtl_md->rcv_data = allocate_ustrmem(DATASIZE);
        vtl_md->snd_data = allocate_ustrmem(DATASIZE);
        vtl_md->snd_packet = allocate_ustrmem(IP_MAXPACKET);
        vtl_md->interface = allocate_strmem(40); //Est-ce encore utile ?
        vtl_md->target = allocate_strmem(40);
        vtl_md->src_ip = allocate_strmem(INET_ADDRSTRLEN);
        vtl_md->dst_ip = allocate_strmem(INET_ADDRSTRLEN);
        vtl_md->ip_flags = allocate_intmem (4);

        /* configure addressing informations */
        //TODO : Preferably get automatically src_ip
        strcpy(vtl_md->src_ip, src_ip); 
        
        //TODO: return code
        /* configure output socket */ 
        vtl_md->af_inet_sock =  adaptor_create_raw_sock(AF_INET, IPPROTO_RAW);      
        adaptor_config_raw_sock(vtl_md->af_inet_sock, interface);

        /* Configure input socket */
        adaptor_config_and_open_xsk_sock(vtl_md);

        return 0;
}

// vtl_snd: envoie des données via la vtl
int 
vtl_snd(vtl_md_t *vtl_md, char *dst_ip, uint8_t *data,  size_t datalen)
{
        /* Configure destination address */
        strcpy(vtl_md->dst_ip, dst_ip);

        /* Fill with data to send */
        vtl_md->snd_data = data;
        vtl_md->snd_datalen = datalen;

        //TODO: Revoir cette partie
        /* send vtl packet */
        adaptor_send_packet(vtl_md->af_inet_sock, vtl_md);

        //TODO: memset snd_data ?


        return 0;

}

//vtl_rcv: recoit des données via la vtl
//TODO: add flags ??
ssize_t
vtl_rcv(vtl_md_t *vtl_md, void *buf)
{       
        //TODO: add return code
        adaptor_rcv_data(vtl_md);
        //buf = vtl_md->rcv_data;
        memcpy(buf, vtl_md->rcv_data, vtl_md->rcv_datalen);

        return vtl_md->rcv_datalen;
}