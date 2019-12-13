#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>           // close()
#include <sys/types.h>        // needed for socket(), uint8_t, uint16_t, uint32_t

#include <netdb.h>
#include <sys/socket.h>       // needed for socket()
#include <arpa/inet.h>        // inet_pton() and inet_ntop()


#include <string.h>           // strcpy, memset(), and memcpy()
#include <errno.h>            // errno, perror()

#include "../../include/vtl/vtl_macros.h"
#include "../../include/vtl/vtl_structures.h"
#include "../common/util.h"

#include "adaptor_send.h"




int
adaptor_create_raw_sock(int domain, int protocol, char *err_buf)
{
        int sock_fd;
        
        /* Submit request for a raw socket descriptor */
        if ((sock_fd = socket (domain, SOCK_RAW, protocol)) < 0) {
                snprintf(err_buf, VTL_ERRBUF_SIZE, "ERR: socket() failed \"%s\"\n",
                strerror(errno));
                return -1; //TODO: change
        }

        return sock_fd;

}

/**
 * Set flag so socket expects us to provide IPv4 header 
 * @param sock_fd -
 * @retval 0 on success
 * @retval -1 on failure
 **/
static int 
enable_ip4_hdr_gen(int sock_fd)
{
        const int on = 1;
        if (setsockopt (sock_fd, IPPROTO_IP, IP_HDRINCL, &on, sizeof (on)) < 0) {
                perror ("ERR: setsockopt() failed to set IP_HDRINCL ");
                return -1;
        }

        return 0;
}

/**
 * @param
 * @retval 0 on success
 * @retval -1 on failure
 **/ 
static int
bind_raw_sock_to_interface(char *interface, int sock_fd)
{
        int sd;
        struct ifreq ifr;

        /* Submit request for a socket descriptor to look up interface. */
        if ((sd = socket (AF_INET, SOCK_RAW, IPPROTO_RAW)) < 0) {
                perror ("socket() failed to get socket descriptor for using ioctl() ");
                return -1; //TODO: change exit() into return 
        }

        // TODO: Is it necessary ?
        /* 
         * Use ioctl() to look up interface index which we will use to
         * bind socket descriptor sd to specified interface with setsockopt() since
         * none of the other arguments of sendto() specify which interface to use.
         */

        memset (&ifr, 0, sizeof (ifr));
        snprintf (ifr.ifr_name, sizeof (ifr.ifr_name), "%s", interface);
        if (ioctl (sd, SIOCGIFINDEX, &ifr) < 0) {
                perror ("ioctl() failed to find interface ");
                return -1;
        }
        close (sd); //Pourquoi ?
        // printf ("Index for interface %s is %i\n", 
        //                 interface, ifr.ifr_ifindex); 

        /* Bind socket to interface index */
        //TODO : use bind  ?
        if (setsockopt (sock_fd, SOL_SOCKET, SO_BINDTODEVICE, &ifr, sizeof (ifr)) < 0) {
                perror ("setsockopt() failed to bind to interface ");
                return -1;
        }

        return 0;   

}


int
adaptor_config_raw_sock(int sockfd, char* interface, char *err_buf)
{       
        int ret;

        ret = enable_ip4_hdr_gen(sockfd);
        if (ret != 0) {
                snprintf(err_buf, VTL_ERRBUF_SIZE, "ERR: enable_ip4_hdr_gen() failed\n");
                return ret;
        }

        ret = bind_raw_sock_to_interface(interface, sockfd);
        if (ret != 0) {
                snprintf(err_buf, VTL_ERRBUF_SIZE, "ERR: enable_ip4_hdr_gen() failed\n");
                return ret;
        }

        return 0;
}

/**
 * 
 * @param
 * @retval 0 on success
 * @retval -1 on failure
 **/ 
static int 
create_ip4_hdr(struct ip *iphdr, char *target, char *dst_ip, char *src_ip, int *ip_flags,
                size_t snd_datalen)
{       

        int status; 
        void *tmp;

        struct addrinfo hints, *res;
        struct sockaddr_in *ipv4;
             
        // Pour l'instant, pas très important
        // TODO: revoir cette partie...
        /* Fill out hints for getaddrinfo(). */
        memset (&hints, 0, sizeof (struct addrinfo));
        hints.ai_family = AF_INET;
        hints.ai_socktype = SOCK_STREAM;
        hints.ai_flags = hints.ai_flags | AI_CANONNAME;

        //TODO: is it necessary ?
        /* Resolve target using getaddrinfo(). */
        if ((status = getaddrinfo (target, NULL, &hints, &res)) != 0) {
                fprintf (stderr, "ERR: getaddrinfo() failed: %s\n", gai_strerror (status));
                return -1;
        }
        
        // struct sockaddr_in *ipv4
        ipv4 = (struct sockaddr_in *) res->ai_addr;
        tmp = &(ipv4->sin_addr);
        if (inet_ntop (AF_INET, tmp, dst_ip, INET_ADDRSTRLEN) == NULL) {
                status = errno;
                fprintf (stderr, 
                         "ERR: inet_ntop() failed.\nError message: %s", 
                        strerror (status));
                return -1;
        }
        freeaddrinfo (res);

        /** IPv4 header **/

        /* IPv4 header length (4 bits): Number of 32-bit words in header = 5 */
        iphdr->ip_hl = IP4_HDRLEN / sizeof (uint32_t);

        /* Internet Protocol version (4 bits): IPv4 */
        iphdr->ip_v = 4;

        /* Type of service (8 bits) */
        iphdr->ip_tos = 0;

        /* Total length of datagram (16 bits): IP header + VTL header + VTL data */
        iphdr->ip_len = htons (IP4_HDRLEN + sizeof(vtlhdr_t) + snd_datalen);

        /* ID sequence number (16 bits): unused, since single datagram */
        iphdr->ip_id = htons (0);

        /* Flags, and Fragmentation offset (3, 13 bits): 0 since single datagram */

        /* Zero (1 bit) */
        ip_flags[0] = 0;

        /* Do not fragment flag (1 bit) */
        ip_flags[1] = 0;

        /* More fragments following flag (1 bit) */
        ip_flags[2] = 0;

        /* Fragmentation offset (13 bits) */
        ip_flags[3] = 0;

        iphdr->ip_off = htons ((ip_flags[0] << 15)
                                + (ip_flags[1] << 14)
                                + (ip_flags[2] << 13)
                                +  ip_flags[3]);

        /* Time-to-Live (8 bits): default to maximum value */
        iphdr->ip_ttl = 255;


        /* Transport layer protocol (8 bits) */
        iphdr->ip_p = IPPROTO_VTL;

        /* Source IPv4 address (32 bits) */
        if ((status = inet_pton (AF_INET, src_ip, &iphdr->ip_src)) != 1) {
                fprintf (stderr, "inet_pton() failed.\nError message: %s", strerror (status));
                return -1;
        }

        /* Destination IPv4 address (32 bits) */
        if ((status = inet_pton (AF_INET, dst_ip, &iphdr->ip_dst)) != 1) {
                fprintf (stderr, "inet_pton() failed.\nError message: %s", strerror (status));
                return -1;
        }

        /* IPv4 header checksum (16 bits): set to 0 when calculating checksum */
        iphdr->ip_sum = 0;
        iphdr->ip_sum = checksum ((uint16_t *) iphdr, IP4_HDRLEN);


        return 0;
}

static void
fill_sockaddr_in(struct sockaddr_in *to,  struct ip *iphdr)
{
      memset (to, 0, sizeof (struct sockaddr_in));
      to->sin_family = AF_INET;
      to->sin_addr.s_addr = iphdr->ip_dst.s_addr; 
}


//TODO: add return codes
static void 
ip4_pkt_assemble(uint8_t *snd_packet, struct ip *iphdr, vtlhdr_t *vtlh, uint8_t *snd_data,
                size_t snd_datalen)
{
        /* First part is an IPv4 header */
        memcpy (snd_packet, iphdr, IP4_HDRLEN);

        /* Next part of packet is upper layer protocol header : VTL header */
        memcpy ((snd_packet + IP4_HDRLEN), vtlh, 
                        sizeof(vtlhdr_t));

        /* Finally, add the VTL data = app payload */
        memcpy (snd_packet + IP4_HDRLEN + sizeof(vtlhdr_t), 
                snd_data, snd_datalen);

}


/**
 * 
 * @param
 * @retval 0 on success
 * @retval -1 on failure
 **/ 
static int
send_packet(int sock_fd, struct sockaddr_in *to, uint8_t *snd_packet, size_t snd_datalen)
{
        size_t ip_pkt_size = IP4_HDRLEN + sizeof(vtlhdr_t) + snd_datalen;
        if (sendto (sock_fd, snd_packet, ip_pkt_size, 
                                0, (struct sockaddr *) to, sizeof (struct sockaddr)) < 0)  {
                        perror ("ERR: sendto() failed ");
                        return -1;
        }

        return 0;
}


int
adaptor_send_packet(int sock_fd, uint8_t *snd_packet, vtlhdr_t *vtlh, struct ip *iphdr,  
                        char *target, char *dst_ip, char *src_ip, 
                        int *ip_flags, uint8_t *snd_data, size_t snd_datalen, char *err_buf)
{
        int ret;
        struct sockaddr_in to;
        //TODO: redundancy ??
        ret = create_ip4_hdr(iphdr, target, dst_ip, src_ip, ip_flags, snd_datalen);
        if (ret != 0) {
                snprintf(err_buf, VTL_ERRBUF_SIZE, "ERR: create_ip4_hdr() failed\n");
                return ret;
        }
        
        /* fill destination sock_addr_in */
        fill_sockaddr_in(&to, iphdr);

        ip4_pkt_assemble(snd_packet, iphdr, vtlh, snd_data, snd_datalen);

        ret = send_packet(sock_fd, &to, snd_packet, snd_datalen);
        if (ret != 0) {
                snprintf(err_buf, VTL_ERRBUF_SIZE, "ERR: send_packet() failed\n");
                return ret;
        }

        return 0;


} 
