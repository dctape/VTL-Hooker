
//TODO: order and name
#include <errno.h>            // errno, perror()
#include <stdio.h>
#include <stdlib.h>
#include <string.h>           // strcpy, memset(), and memcpy()
#include <unistd.h>           // close()

#include <netinet/in.h>       // IPPROTO_RAW, IPPROTO_IP,  INET_ADDRSTRLEN
#include <netinet/ip.h>       // IP_MAXPACKET (which is 65535)
#include <sys/types.h>        // needed for socket(), uint8_t, uint16_t, uint32_t
#include <sys/socket.h>       // needed for socket()

#include <bpf/bpf.h> 

#include "./raw_sock/raw_sock.h"
#include "../common/tc_user_helpers.h" 
#include "../lib/vtl_util.h"


#define INJECTION_KERN_FILENAME                 "injection_kern.o"
#define DEV_NAME                                "ens33"

#define SRC_IP                                  "192.168.130.158"
#define DST_IP                                  "192.168.130.157"



int main(int argc, char **argv)
{   

        int sock_fd;
        int ifindex;
        int cnt_pkt = 0;
        int cnt_bytes = 0;

        FILE *tx_file = NULL;
      
        struct sockaddr_in to;
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
        inject_cfg.data = allocate_ustrmem (DATASIZE); //TODO: DATASIZE or IP_MAXPACKET
        inject_cfg.packet = allocate_ustrmem (IP_MAXPACKET);
        inject_cfg.interface = allocate_strmem (40);
        inject_cfg.target = allocate_strmem (40);
        inject_cfg.src_ip = allocate_strmem (INET_ADDRSTRLEN);
        inject_cfg.dst_ip = allocate_strmem (INET_ADDRSTRLEN);
        inject_cfg.ip_flags = allocate_intmem (4);

        
        /* Configuration des informations d'adressage */
        // Possible car j'envoie à les données à la même cible
        // A adapter pour d'autres cas d'utilisation
        strcpy (inject_cfg.interface, DEV_NAME);
        strcpy (inject_cfg.src_ip, SRC_IP);
        strcpy (inject_cfg.target, DST_IP); // TODO: use dst_ip later

        /* Config vtl header */   
        inject_cfg.vtlh.checksum = 50; // Just for test


        /* Ouverture du fichier de test */
        // TODO: close test_file
        tx_file = fopen("../files/lion.jpg", "rb"); // or ../files/file.txt
        if (tx_file == NULL){
                fprintf(stderr, "ERR: failed to open test file\n");
                exit(EXIT_FAILURE);
        }


        /* Création d'une socket brut */
        sock_fd = create_raw_sock();

        /* activer la génération d'en-tête ip4 */
        enable_ip4_hdr_gen(sock_fd);

        /* Attacher une interface à la raw socket */
        bind_raw_sock_to_interface(inject_cfg.interface, sock_fd);


        /* Lecture du contenu puis formation du paquet */
        printf("\n");
        printf("Sending data...");

        while (!feof(tx_file)) {

                inject_cfg.datalen = fread(inject_cfg.data, 1, DATASIZE, tx_file);

                create_ip4_hdr(&inject_cfg); //or ip4_hdr_config(&inject_cfg)

                /* fill destination sock_addr_in */
                fill_sockaddr_in(&to, &inject_cfg);

                ip4_pkt_assemble(&inject_cfg);

                send_packet(sock_fd, &inject_cfg, &to);            
                
                memset(inject_cfg.data, 0, inject_cfg.datalen);
                cnt_pkt++;
                cnt_bytes += inject_cfg.datalen;
                
        }
        printf("Done\n");
        printf("\n");

        printf("Nbrs of sent packets: %d pkts\n", cnt_pkt);
        printf("Nbrs of sent bytes: %d bytes\n", cnt_bytes);
        printf("\n");

        
        /* Close test file  */
        fclose(tx_file);

        /* Close socket descriptor */
        close (sock_fd);


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