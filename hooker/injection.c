#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <linux/ip.h>

#include <libnet.h>
//#include <libnet-functions.h>
#include <linux/bpf.h>

#include "../../bpf/bpf_load.h"
#include "../../bpf/libbpf.h"
//#include "bpf_helpers.h"
//#include "../../bpf-manager.h"

static int verbose = 1;

//paramétrage commmande tc
#define CMD_MAX 	2048
#define CMD_MAX_TC	256
static char tc_cmd[CMD_MAX_TC] = "sudo tc";


#define PCKT_LEN			8192
#define IPPROTO_VTL 		253
#define TC_BPF_FILE         "injection_tc_kern.o"

static char tc_ingress_ifname[IF_NAMESIZE];
static char tc_egress_ifname[IF_NAMESIZE] = "enp0s3";
static char xdp_ifname[IF_NAMESIZE] = "enp0s3"; 
static char buf_ifname[IF_NAMESIZE] = "(unknown-dev)";

/* Attach bpf program on tc egress path */
static int tc_egress_attach_bpf(const char* dev, const char* bpf_obj)
{
	char cmd[CMD_MAX];
	int ret = 0;

	/* Step-1: Delete clsact, which also remove filters */
	memset(&cmd, 0, CMD_MAX);
	snprintf(cmd, CMD_MAX,
		 "%s qdisc del dev %s clsact 2> /dev/null",
		 tc_cmd, dev);
	if (verbose) printf(" - Run: %s\n", cmd);
	ret = system(cmd); // Very interesting !!!
	if (!WIFEXITED(ret)) {
		fprintf(stderr,
			"ERR(%d): Cannot exec tc cmd\n Cmdline:%s\n",
			WEXITSTATUS(ret), cmd);
		exit(EXIT_FAILURE);
	} else if (WEXITSTATUS(ret) == 2) {
		/* Unfortunately TC use same return code for many errors */
		if (verbose) printf(" - (First time loading clsact?)\n");
	}

	/* Step-2: Attach a new clsact qdisc */
	memset(&cmd, 0, CMD_MAX);
	snprintf(cmd, CMD_MAX,
		 "%s qdisc add dev %s clsact",
		 tc_cmd, dev);
	if (verbose) printf(" - Run: %s\n", cmd);
	ret = system(cmd);
	if (ret) {
		fprintf(stderr,
			"ERR(%d): tc cannot attach qdisc hook\n Cmdline:%s\n",
			WEXITSTATUS(ret), cmd);
		exit(EXIT_FAILURE);
	}

	/* Step-3: Attach BPF program/object as ingress filter */
	memset(&cmd, 0, CMD_MAX);
	snprintf(cmd, CMD_MAX,
		 "%s filter add dev %s "
		 "egress prio 1 handle 1 bpf da obj %s sec tf_tc_egress",
		 tc_cmd, dev, bpf_obj); // TODO: adapt that line for our use cases
    //TODO : - find why prio 1 handle 1
    //       - change sec ingress_redirect to section name of my bpf file    
	if (verbose) printf(" - Run: %s\n", cmd);
	ret = system(cmd);
	if (ret) {
		fprintf(stderr,
			"ERR(%d): tc cannot attach filter\n Cmdline:%s\n",
			WEXITSTATUS(ret), cmd); //TODO : change error message
		exit(EXIT_FAILURE);
	}

	return ret;
}

/* Remove bpf program on tc egress path  */
static int tc_remove_egress(const char* dev)
{
	char cmd[CMD_MAX];
	int ret = 0;

	memset(&cmd, 0, CMD_MAX);
	snprintf(cmd, CMD_MAX,
		 /* Remove all ingress filters on dev */
		 "%s filter delete dev %s egress",
		 /* Alternatively could remove specific filter handle:
		 "%s filter delete dev %s ingress prio 1 handle 1 bpf",
		 */
		 tc_cmd, dev);
	if (verbose) printf(" - Run: %s\n", cmd);
	ret = system(cmd);
	if (ret) {
		fprintf(stderr,
			"ERR(%d): tc cannot remove filters\n Cmdline:%s\n",
			ret, cmd); //TODO: change error message
		exit(EXIT_FAILURE);
	}
	return ret;
}

int main(int argc, char **argv)
{   
    //printf("injection - tc");
    //char *test_payload = "Test pour voir si ça marche !!!";

    /* Attachage des programmes eBPF à TC */
    int egress_ifindex = if_nametoindex(tc_egress_ifname);
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
    
    //fabricate the IP header

    libnet_t *l;
    char *device = NULL;
	char *dst = "140.93.2.160", *src = "10.0.2.15";
    u_long src_ip, dst_ip;
    char errbuf[LIBNET_ERRBUF_SIZE];
    libnet_ptag_t ip_ptag = 0;
    u_short proto = IPPROTO_VTL;
    //u_char payload[255] = "Test pour voir si ca marche !";
    u_char payload[255] = {0x11, 0x11, 0x22, 0x22, 0x00, 0x00, 0x00, 0x00};
    u_long payload_s = 4;
    u_long vtl_hdr_s = 4;
    u_long header_s = payload_s + vtl_hdr_s;

    printf("libnet 1.1 packet shaping: IP + payload[raw]\n");
    
    // Initialize the library.  Root priviledges are required.
    l = libnet_init(LIBNET_RAW4,			// injection type
    					device, 			// network interface
    					errbuf 				// error buffer
    					);
    if (l == NULL) {
        fprintf(stderr, "ERR: libnet_init() failed: %s", errbuf);
        return 1; 
    }
    printf("Using device %s\n", l->device);

    //TODO : LIBNET_RESOLVE or LIBNET_DONT_RESOLVE
    if ((dst_ip = libnet_name2addr4(l, dst, LIBNET_RESOLVE)) == -1) {
        fprintf(stderr, "Bad destination IP address: %s\n", dst);
        return 1;
    }  
    if ((src_ip = libnet_name2addr4(l, src, LIBNET_RESOLVE)) == -1){
        fprintf(stderr, "Bad source IP address: %s\n", src);
        return 1;
    }

    // Build the packet
    ip_ptag = libnet_build_ipv4(
        LIBNET_IPV4_H + header_s,                  /* longueur du paquet */
        0,                                          /* TOS */
        242,                                     /* IP ID */
        0,                                          /* IP Frag */
        64,                                      /* TTL */  /* Trouver la valeur optimale du ttl pour la communication */
        proto,                                /* upper layer protocol - protocole couche transport */
        0,                                          /* checksum, 0 = autofill */
        src_ip,                                     /* IP source*/
        dst_ip,                                     /* IP destination */
        payload,                                    /* payload */
        header_s,                            /*  taille du payload */
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
        fprintf(stderr, "Wrote %d byte IP packet; check the wire.\n\n", c);
    }

	libnet_destroy(l);

    /*  remove tc-bpf program */
    printf("TC remove tc-bpf program on device %s\n", tc_egress_ifname);
    tc_remove_egress(tc_egress_ifname);

    return 0;
    
}