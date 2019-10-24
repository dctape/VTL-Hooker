
//TODO: order and name
#include <errno.h>            // errno, perror()
#include <stdio.h>
#include <stdlib.h>
#include <string.h>           // strcpy, memset(), and memcpy()
#include <unistd.h>           // close()

#include <netinet/in.h>       // IPPROTO_RAW, IPPROTO_IP, IPPROTO_ICMP, INET_ADDRSTRLEN
#include <netinet/ip.h>       // struct ip and IP_MAXPACKET (which is 65535)
#include <sys/types.h>        // needed for socket(), uint8_t, uint16_t, uint32_t
#include <sys/socket.h>       // needed for socket()

#include <bpf/bpf.h> // or <bpf/bpf.h> ?

#include "./raw_sock/raw_sock.h"
#include "../common/tc_user_helpers.h" 
#include "../lib/vtl_util.h"

#define DATASIZE        100

#define INJECTION_KERN_FILENAME                 "injection_kern.o"
#define DEV_NAME                                "ens33"

#define SRC_IP                                  "192.168.130.158"
#define DST_IP                                  "192.168.130.157"



int main(int argc, char **argv)
{   

        int sd;
        int ifindex;      
        const int on = 1;

        struct sockaddr_in sin;
        struct inject_config inject_cfg = {};
        struct tc_config tc_cfg = {
                .filename = INJECTION_KERN_FILENAME,
                .dev = DEV_NAME
        };

        
        ifindex = if_nametoindex(DEV_NAME);
        if (!(ifindex)) { //TODO : change this part later...
                        fprintf(stderr,
                                "ERR: --egress \"%s\" not real dev\n",
                                        DEV_NAME);
                        return EXIT_FAILURE;
        }
        
        /* inject tc-bpf-file in the kernel */
        printf("Inject tc-bpf-file in the kernel...\n");
        printf("TC attach BPF object %s to device %s\n", tc_cfg.filename, tc_cfg.dev); 
        if (tc_egress_attach_bpf(&tc_cfg)) {
                        fprintf(stderr, "ERR: TC attach failed\n");
                        exit(EXIT_FAILURE);
        }

        /* Allocate memory for various arrays */
        //or DATASIZE ?
        inject_cfg.data = allocate_ustrmem (IP_MAXPACKET); // Pourquoi la taille est IP_MAXPACKET ?
        inject_cfg.packet = allocate_ustrmem (IP_MAXPACKET);
        inject_cfg.interface = allocate_strmem (40);
        inject_cfg.target = allocate_strmem (40);
        inject_cfg.src_ip = allocate_strmem (INET_ADDRSTRLEN);
        inject_cfg.dst_ip = allocate_strmem (INET_ADDRSTRLEN);
        inject_cfg.ip_flags = allocate_intmem (4);

        /* Build data block */
        
        // For now, send a string!
        strcpy(inject_cfg.data, "TEST");
        inject_cfg.datalen = strlen(inject_cfg.data ); //or sizeof ?

        /* Build vtl header block */

        // Just for test
        inject_cfg.vtlh.checksum = 50;


        strcpy (inject_cfg.interface, DEV_NAME);
        strcpy (inject_cfg.src_ip, SRC_IP);
        strcpy (inject_cfg.target, DST_IP); // TODO: use dst_ip later

        /* Configuration de l'en-tête IPv4 */
        ip4_hdr_config(&inject_cfg);


        /* Prepare packet */
        ip4_pkt_assemble(&inject_cfg);
        

        memset (&sin, 0, sizeof (struct sockaddr_in));
        sin.sin_family = AF_INET;
        sin.sin_addr.s_addr = inject_cfg.iphdr.ip_dst.s_addr;

        /* Submit request for a raw socket descriptor */
        if ((sd = socket (AF_INET, SOCK_RAW, IPPROTO_RAW)) < 0) {
                perror ("socket() failed ");
                exit (EXIT_FAILURE);
        }

        /* Set flag so socket expects us to provide IPv4 header */
        if (setsockopt (sd, IPPROTO_IP, IP_HDRINCL, &on, sizeof (on)) < 0) {
                perror ("setsockopt() failed to set IP_HDRINCL ");
                exit (EXIT_FAILURE);
        }

        /* Bind socket to interface index */
        if (setsockopt (sd, SOL_SOCKET, SO_BINDTODEVICE, &inject_cfg.ifr, sizeof (inject_cfg.ifr)) < 0) {
                perror ("setsockopt() failed to bind to interface ");
                exit (EXIT_FAILURE);
        }

        /* Send packet */
        printf("Send data : %s 5 times\n", inject_cfg.data);
        for (size_t i = 0; i < 5; i++)
        {
                if (sendto (sd, inject_cfg.packet, IP4_HDRLEN + sizeof(struct vtlhdr) + inject_cfg.datalen, 
                        0, (struct sockaddr *) &sin, sizeof (struct sockaddr)) < 0)  {
                perror ("sendto() failed ");
                exit (EXIT_FAILURE);
                }       
        }

        // if (sendto (sd, inject_cfg.packet, IP4_HDRLEN + VTL_HDRLEN + inject_cfg.datalen, 
        //                 0, (struct sockaddr *) &sin, sizeof (struct sockaddr)) < 0)  {
        //         perror ("sendto() failed ");
        //         exit (EXIT_FAILURE);
        // }  
        

        /* Close socket descriptor */
        close (sd);


        /* Free allocated memory */
        free (inject_cfg.data);
        free (inject_cfg.packet);
        free (inject_cfg.interface);
        free (inject_cfg.target);
        free (inject_cfg.src_ip);
        free (inject_cfg.dst_ip);
        free (inject_cfg.ip_flags);

        /*  remove tc-bpf program */
        printf("TC remove tc-bpf program on device %s\n", tc_cfg.dev);
        tc_remove_egress(&tc_cfg);

        return 0;
    
}