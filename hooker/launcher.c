/*
 *
 * launcher source code
 * Copyright(c) 2017 Jesper Dangaard Brouer, Red Hat, Inc.(Not sure!)
 * 
 * 
*/

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <unistd.h>
#include <locale.h>

#include <getopt.h>
#include <net/if.h>
#include <time.h>

#include <linux/ip.h>

#include <linux/bpf.h>
#include "../bpf/bpf-manager.h"


//static const char *mapfile  --- Used maps




//paramétrage raw sockets
#define PCKT_LEN	8192 //TODO: find an ideal length.

#define TC_BPF_FILE         "launcher_tc_kern.o"

#define LAUNCHER_BPF_FILE	"launcher_kern.o"

//TODO :
// - put in config file
// - make it interactive and optimal
static char tc_ingress_ifname[IF_NAMESIZE];
static char tc_egress_ifname[IF_NAMESIZE] = "ens33";
static char xdp_ifname[IF_NAMESIZE] = "ens33"; 
static char buf_ifname[IF_NAMESIZE] = "(unknown-dev)";

struct vtlhdr{

	int value;
	//TODO: add other members according use cases

};



//TODO : handle error code
int main(int argc, char **argv)
{   
       
    int egress_ifindex = if_nametoindex(tc_egress_ifname); //why : test ifname
	int ifindex_xdp = if_nametoindex(tc_egress_ifname);

	//snprintf(egress_ifname, )
    
    // test the validity of ifname
    if (!(egress_ifindex)){ //TODO : change this part later...
				fprintf(stderr,
					"ERR: --egress \"%s\" not real dev\n",
					tc_egress_ifname);
				return EXIT_FAILURE;
	}
   
    /* set up tfs(tc + xdp) in the kernel */
    printf("TC attach BPF object %s to device %s\n",
			       TC_BPF_FILE, tc_egress_ifname); 
    if (tc_egress_attach_bpf(tc_egress_ifname, TC_BPF_FILE)) {
			fprintf(stderr, "ERR: TC attach failed\n");
			exit(EXIT_FAILURE);
	}

	printf("XDP load BPF file in kernel\n");
	if(bpf_inject(LAUNCHER_BPF_FILE)){
		printf("ERROR - Loading xdp file");
		return 1;
	}

	printf("XDP attach BPF object to device %s\n",
			xdp_ifname);
	/* Attach xdp-bpf-file */
	if (set_link_xdp_fd(ifindex_xdp, prog_fd[0], 0) < 0) {
		printf("link set xdp fd failed\n");
		return 1;
	}

	/* Inject data with raw sockets */

	// Formation du paquet vtl
	char *vtl_pkt = (char *)malloc(PCKT_LEN);
	memset(vtl_pkt, 0, PCKT_LEN);
	struct vtlhdr *vtl_hdr = (struct vtlhdr *)vtl_pkt;
	
	int vtlhdr_len = sizeof(struct vtlhdr);
	char *vtl_payload = (char *)(vtl_pkt + vtlhdr_len);

	

	char buffer[PCKT_LEN];
	struct iphdr *ip = (struct iphdr *)buffer;
	struct vtldhr *vtl = (struct vtlhdr *)(buffer + sizeof(struct iphdr));
	

    /* sleep for a specific time */
    int nb_sec = 50;
    printf("Sleep for %d sec\n", nb_sec);   
    sleep(nb_sec);

    /*  remove tc-bpf program */
    printf("TC remove tc-bpf program on device %s\n", tc_egress_ifname);
    tc_remove_egress(tc_egress_ifname);

	/* remove xdp-bpf-file */
	printf("XDP remove xdp-bpf program on device %s\n", tc_egress_ifname);
	set_link_xdp_fd(ifindex_xdp, -1, 0);

    return 0;
}