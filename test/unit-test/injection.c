
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <linux/ip.h>

#include <libnet.h>
#include <linux/bpf.h>
#include "../../bpf/bpf-manager.h"



static int verbose = 1;

//paramétrage commmande tc
#define CMD_MAX 	2048
#define CMD_MAX_TC	256
static char tc_cmd[CMD_MAX_TC] = "tc";


#define PCKT_LEN	8192
#define IPPROTO_VTL 200
#define TC_BPF_FILE         "injection_tc_kern.o"

static char tc_ingress_ifname[IF_NAMESIZE];
static char tc_egress_ifname[IF_NAMESIZE] = "ens33";
static char xdp_ifname[IF_NAMESIZE] = "ens33"; 
static char buf_ifname[IF_NAMESIZE] = "(unknown-dev)";

struct vtlhdr{

	int value;
	//TODO: add other members according use cases
};


int main(int argc, char **argv)
{   
    //printf("injection - tc");
    char *test_payload = "Test pour voir si ça marche !!!";

    /* Attachage des programmes eBPF à TC */
    int egress_ifindex = if_nametoindex(tc_egress_ifname);

    // test the validity of ifname
    if (!(egress_ifindex)){ //TODO : change this part later...
				fprintf(stderr,
					"ERR: --egress \"%s\" not real dev\n",
					tc_egress_ifname);
				return EXIT_FAILURE;
	}

    /* inject tc-bpf-file in the kernel */
    printf("TC attach BPF object %s to device %s\n",
			       TC_BPF_FILE, tc_egress_ifname); 
    if (tc_egress_attach_bpf(tc_egress_ifname, TC_BPF_FILE)) {
			fprintf(stderr, "ERR: TC attach failed\n");
			exit(EXIT_FAILURE);
	}


    /* Formation du paquet vtl */
    
    char *vtl_pkt = (char *)malloc(PCKT_LEN);
	memset(vtl_pkt, 0, PCKT_LEN);
	struct vtlhdr *vtl_hdr1 = (struct vtlhdr *)vtl_pkt;
    vtl_hdr1->value = 20;

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

    char *dst = "140.93.2.160";  //@IP host vm
    char *src = "192.168.130.143"; //@IP local
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
    printf("TC remove tc-bpf program on device %s\n", tc_egress_ifname);
    tc_remove_egress(tc_egress_ifname);

    return 0;
    
}