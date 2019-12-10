
//TODO: order and name
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>           // close()
#include <string.h>           // strcpy, memset(), and memcpy()

#include <netdb.h>            // struct addrinfo
#include <sys/types.h>        // needed for socket(), uint8_t, uint16_t, uint32_t
#include <sys/socket.h>       // needed for socket()
#include <netinet/in.h>       // IPPROTO_RAW, IPPROTO_IP, IPPROTO_ICMP, INET_ADDRSTRLEN
#include <netinet/ip.h>       // struct ip and IP_MAXPACKET (which is 65535)
#include <netinet/ip_icmp.h>  // struct icmp, ICMP_ECHO
#include <arpa/inet.h>        // inet_pton() and inet_ntop()
#include <sys/ioctl.h>        // macro ioctl is defined
#include <bits/ioctls.h>      // defines values for argument "request" of ioctl.
#include <net/if.h>           // struct ifreq

#include <errno.h>            // errno, perror()


#include <libnet.h> //WARN: Don't forget to install libnet
#include <linux/bpf.h> // or <bpf/bpf.h> ?

#include "raw_sock/raw_sock.h"
#include "../common/tc_user_helpers.h" 


#define PCKT_LEN	                        8192
#define IPPROTO_VTL                             200
#define INJECTION_KERN_FILENAME                 "injection_kern.o"

#define DEV_NAME                                "ens33"

//Définition de la taille des en-tête
#define VTL_HDRLEN                              8

//TODO: mettre la définition de l'en-tête dans ../lib
struct vtlhdr {

	uint16_t checksum;
};


int main(int argc, char **argv)
{   

        int status, datalen, sd;      
        const int on = 1;
        void *tmp;

        struct inject_config inject_cfg;
        struct sockaddr_in *ipv4, sin;
        struct vtlhdr vtlh = {
                .checksum = 0
        };

        //printf("injection - tc");

        /*** Injection et attachage des TFs au niveau de tc_egress ***/

        int ifindex = if_nametoindex(DEV_NAME);
        if (!(ifindex)) { //TODO : change this part later...
                        fprintf(stderr,
                                "ERR: --egress \"%s\" not real dev\n",
                                        DEV_NAME);
                        return EXIT_FAILURE;
        }

        struct tc_config tc_cfg = {
                .filename = INJECTION_KERN_FILENAME,
                .dev = DEV_NAME
        };

        /* inject tc-bpf-file in the kernel */
        printf("TC attach BPF object %s to device %s\n",
                        tc_cfg.filename, tc_cfg.dev); 
        if (tc_egress_attach_bpf(&tc_cfg)) {
                        fprintf(stderr, "ERR: TC attach failed\n");
                        exit(EXIT_FAILURE);
        }

        /*** Transmission des datas ***/
        //TODO: use libnet or not ?

        // a- use directly raw_socket       

        // Allocate memory for various arrays.
        // TODO: put allocate_ func in raw_sock.h
        inject_cfg.data = allocate_ustrmem (IP_MAXPACKET); // Pourquoi la taille est IP_MAXPACKET ?
        inject_cfg.packet = allocate_ustrmem (IP_MAXPACKET);
        inject_cfg.interface = allocate_strmem (40);
        inject_cfg.target = allocate_strmem (40);
        inject_cfg.src_ip = allocate_strmem (INET_ADDRSTRLEN);
        inject_cfg.dst_ip = allocate_strmem (INET_ADDRSTRLEN);
        inject_cfg.ip_flags = allocate_intmem (4);

        /* Interface to send packet through. */
        strcpy (inject_cfg.interface, DEV_NAME);
        /* Source IPv4 address: you need to fill this out */
        strcpy (inject_cfg.src_ip, "192.168.1.132"); //Normal !
        /* Destination URL or IPv4 address: you need to fill this out */
        strcpy (inject_cfg.target, "www.google.com"); // Pourquoi ne pas utiliser dst_ip ?

        /* Configuration de l'en-tête IPv4 */
        ip4_hdr_config(&inject_cfg);
     
        // data = vtl_payload
        inject_cfg.data = "Test";
        datalen = strlen(inject_cfg.data);

        /* Prepare packet */
        ip4_pkt_assemble(&inject_cfg);
        
        
        

        // send data...
        //TODO: Remplir destination pour la cible

        /* 
         * The kernel is going to prepare layer 2 information (ethernet frame header) for us.
         * For that, we need to specify a destination for the kernel in order for it
         * to decide where to send the raw datagram. We fill in a struct in_addr with
         * the desired destination IP address, and pass this structure to the sendto() function.
         */ 
        
        memset (&sin, 0, sizeof (struct sockaddr_in));
        sin.sin_family = AF_INET;
        sin.sin_addr.s_addr = inject_cfg.iphdr.ip_dst.s_addr;

        // Submit request for a raw socket descriptor.
        // TODO: Bizarre l'ouverture d'une nouvelle socket
        if ((sd = socket (AF_INET, SOCK_RAW, IPPROTO_RAW)) < 0) {
                perror ("socket() failed ");
                exit (EXIT_FAILURE);
        }

        // Set flag so socket expects us to provide IPv4 header.
        if (setsockopt (sd, IPPROTO_IP, IP_HDRINCL, &on, sizeof (on)) < 0) {
                perror ("setsockopt() failed to set IP_HDRINCL ");
                exit (EXIT_FAILURE);
        }

        // besoin de &ifr
        // Bind socket to interface index.
        if (setsockopt (sd, SOL_SOCKET, SO_BINDTODEVICE, &inject_cfg.ifr, sizeof (inject_cfg.ifr)) < 0) {
                perror ("setsockopt() failed to bind to interface ");
                exit (EXIT_FAILURE);
        }

        // Send packet.
        if (sendto (sd, inject_cfg.packet, IP4_HDRLEN + VTL_HDRLEN + datalen, 
                        0, (struct sockaddr *) &sin, sizeof (struct sockaddr)) < 0)  {
                perror ("sendto() failed ");
                exit (EXIT_FAILURE);
        }

        // Close socket descriptor.
        close (sd);

        /* Formation du paquet vtl */
                
        char *vtl_pkt = (char *)malloc(PCKT_LEN);
        memset(vtl_pkt, 0, PCKT_LEN);
        struct vtlhdr *vtl_hdr1 = (struct vtlhdr *)vtl_pkt;
        vtl_hdr1->value = 10;

        int vtlhdr_len = sizeof(struct vtlhdr);
                
        struct vtlhdr *vtl_hdr2 = (struct vtlhdr *)vtl_pkt;
        char *vtl_payload = (char *)(vtl_pkt + vtlhdr_len);

        memcpy(vtl_payload, test_payload, strlen(test_payload));

        printf("vtl_hdr->value: %d, vtl_payload : %s size :%ld\n",
                vtl_hdr2->value, vtl_payload, sizeof(vtl_pkt) + LIBNET_IPV4_H);

        /* Ecriture du paquet sur IP avec libnet */
                
        //fabricate the IP header

        // b- libnet
        //TODO: install libnet library
        char *device = NULL;
        char errbuf[LIBNET_ERRBUF_SIZE];
        libnet_t *l = libnet_init(LIBNET_RAW4, device, errbuf);
        if (l == NULL) {
                fprintf(stderr, "ERR: libnet_init() failed: %s", errbuf);
                return 1; 
        }

        char *dst = "192.168.130.153";  //@IP host vm
        char *src = "192.168.130.155"; //@IP local
        __u_long src_ip, dst_ip;

        //TODO : LIBNET_RESOLVE or LIBNET_DONT_RESOLVE
        if ((dst_ip = libnet_name2addr4(l, dst, LIBNET_RESOLVE)) == -1) {
                fprintf(stderr, "Bad destination IP address: %s\n", dst);
                return 1;
        }  
        if ((src_ip = libnet_name2addr4(l, src, LIBNET_RESOLVE)) == -1){
                fprintf(stderr, "Bad source IP address: %s\n", src);
                return 1;
        }
        u_long vtl_pkt_s = strlen(vtl_pkt); // or sizeof ??

        //build libnet packet
        //int ip_tos, ip_id, ip_frag_o;
        uint8_t ip_tos, ip_ttl;
        uint16_t ip_id, ip_frag_offset, ip_checksum;
        libnet_ptag_t ip_ptag = 0;

        //TODO : find ideal values (notably checksum)
        ip_tos = 0;
        ip_id = 242;
        ip_frag_offset = 0;
        ip_ttl = 64;
        ip_checksum = 0; // if sum == 0, then libnet autofills

        ip_ptag = libnet_build_ipv4(
                        LIBNET_IPV4_H + vtl_pkt_s,                  /* longueur du paquet */
                        ip_tos,                                          /* TOS */
                        ip_id,                                     /* IP ID */
                        ip_frag_offset,                                          /* IP Frag */
                        ip_ttl,                                      /* TTL */  /* Trouver la valeur optimale du ttl pour la communication */
                        IPPROTO_VTL,                                /* upper layer protocol - protocole couche transport */
                        ip_checksum,                                          /* checksum, 0 = autofill */
                        src_ip,                                     /* IP source*/
                        dst_ip,                                     /* IP destination */
                        (const uint8_t *)vtl_pkt,                                    /* payload */
                        vtl_pkt_s,                 //payload_s           /*  taille du payload */
                        l,                                          /* libnet handle */
                        ip_ptag                                     /* protocol tag */
                );


        if (ip_ptag == -1) {
                fprintf(stderr, "ERR: Can't build IP header: %s\n", libnet_geterror(l));
                return 1;
        }

        /*
        *  Write it to the wire.
        */

        int c = libnet_write(l);
        if (c == -1) {
                fprintf(stderr, "ERR: Write error: %s\n", libnet_geterror(l));
                return 1;
        }
        else {
                fprintf(stderr, "Wrote %d byte IP packet; check the wire.\n", c);
        }


        free(vtl_pkt);
        libnet_destroy(l);

        /*  remove tc-bpf program */
        printf("TC remove tc-bpf program on device %s\n", tc_cfg.dev);
        tc_remove_egress(&tc_cfg);

        return 0;
    
}