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
#include "./bpf/bpf_load.h"
#include "./bpf/libbpf.h"
#include "bpf-manager.h"

static int verbose = 1; // TODO : delete later...
//static const char *mapfile  --- Used maps

//paramétrage commmande tc
#define CMD_MAX 	2048
#define CMD_MAX_TC	256
static char tc_cmd[CMD_MAX_TC] = "tc";

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
/*
 * Prototype kernel :
 * TC require attaching the bpf-object via the TC cmdline tool.
 *
 * Manually like:
 *  $TC qdisc   del dev $DEV clsact
 *  $TC qdisc   add dev $DEV clsact
 *  $TC filter  add dev $DEV ingress bpf da obj $BPF_OBJ sec ingress_redirect
 *  $TC filter show dev $DEV ingress
 *  $TC filter  del dev $DEV ingress
 *
 * (The tc "replace" command does not seem to work as expected)
 */


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

// list_egress ???

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

// Why ???
bool validate_ifname(const char* input_ifname, char *output_ifname)
{
	size_t len;
	int i;

	len = strlen(input_ifname);
	if (len >= IF_NAMESIZE) {
		return false;
	}
	for (i = 0; i < len; i++) {
		char c = input_ifname[i];

		if (!(isalpha(c) || isdigit(c)))
			return false;
	}
	strncpy(output_ifname, input_ifname, len);
	return true;
}

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
   
    /* inject tc-bpf-file in the kernel */
    printf("TC attach BPF object %s to device %s\n",
			       TC_BPF_FILE, tc_egress_ifname); 
    if (tc_egress_attach_bpf(tc_egress_ifname, TC_BPF_FILE)) {
			fprintf(stderr, "ERR: TC attach failed\n");
			exit(EXIT_FAILURE);
	}

	/* inject and attach xdp-bpf-file */
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