
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


//#include <libnet.h> //WARN: Don't forget to install libnet
#include <linux/bpf.h> // or <bpf/bpf.h> ?

#include "./raw_sock/raw_sock.h"
#include "../common/tc_user_helpers.h" 
#include "../lib/vtl_util.h"


#define INJECTION_KERN_FILENAME                 "injection_kern.o"
#define DEV_NAME                                "ens33"



int main(int argc, char **argv)
{   

        int sd;      
        const int on = 1;
       
        
        struct sockaddr_in sin;
        struct inject_config inject_cfg = {};

        struct tc_config tc_cfg = {
                .filename = INJECTION_KERN_FILENAME,
                .dev = DEV_NAME
        };

        

        int ifindex = if_nametoindex(DEV_NAME);
        if (!(ifindex)) { //TODO : change this part later...
                        fprintf(stderr,
                                "ERR: --egress \"%s\" not real dev\n",
                                        DEV_NAME);
                        return EXIT_FAILURE;
        }
        
        /* inject tc-bpf-file in the kernel */
        printf("Inject tc-bpf-file in the kernel...\n");
        printf("TC attach BPF object %s to device %s\n",
                        tc_cfg.filename, tc_cfg.dev); 
        if (tc_egress_attach_bpf(&tc_cfg)) {
                        fprintf(stderr, "ERR: TC attach failed\n");
                        exit(EXIT_FAILURE);
        }

        /* Allocate memory for various arrays */
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
        strcpy (inject_cfg.src_ip, "192.168.130.157"); //Normal !
        /* Destination URL or IPv4 address: you need to fill this out */
        strcpy (inject_cfg.target, "www.google.com"); // Pourquoi ne pas utiliser dst_ip ?

        /* Configuration de l'en-tête IPv4 */
        ip4_hdr_config(&inject_cfg);
        
        //TODO: déterminer la taille exacte de struct vtlhdr
        inject_cfg.vtlh.checksum = 30;
        // data = vtl_payload
        // inject_cfg.data[0] = 'T';
        // inject_cfg.data[1] = 'e';
        // inject_cfg.data[2] = 's';
        // inject_cfg.data[3] = 't';
        inject_cfg.data = "Test";
        inject_cfg.datalen = strlen(inject_cfg.data);

        /* Prepare packet */
        ip4_pkt_assemble(&inject_cfg);
        
        /* send data... */

        /* 
         * The kernel is going to prepare layer 2 information (ethernet frame header) for us.
         * For that, we need to specify a destination for the kernel in order for it
         * to decide where to send the raw datagram. We fill in a struct in_addr with
         * the desired destination IP address, and pass this structure to the sendto() function.
         */ 

        memset (&sin, 0, sizeof (struct sockaddr_in));
        sin.sin_family = AF_INET;
        sin.sin_addr.s_addr = inject_cfg.iphdr.ip_dst.s_addr;

        /* Submit request for a raw socket descriptor */
        // TODO: Bizarre l'ouverture d'une nouvelle socket
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
        printf("Send data : %s\n", inject_cfg.data);
        if (sendto (sd, inject_cfg.packet, IP4_HDRLEN + VTL_HDRLEN + inject_cfg.datalen, 
                        0, (struct sockaddr *) &sin, sizeof (struct sockaddr)) < 0)  {
                perror ("sendto() failed ");
                exit (EXIT_FAILURE);
        }

        /* Close socket descriptor */
        close (sd);

        /*  remove tc-bpf program */
        printf("TC remove tc-bpf program on device %s\n", tc_cfg.dev);
        tc_remove_egress(&tc_cfg);

        return 0;
    
}