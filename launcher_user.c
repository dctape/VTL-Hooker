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

#include "./bpf/libbpf.h"

static int verbose = 1;
//static const char *mapfile  --- Used maps

//paramétrage commmande tc
#define CMD_MAX 	2048
#define CMD_MAX_TC	256
static char tc_cmd[CMD_MAX_TC] = "tc";

#define TC_BPF_FILE         "launcher_tc_kern.o"


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


/* tc egress attach */
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
		 "egress prio 1 handle 1 bpf da obj %s sec ingress_redirect",
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

/* tc egress remove */
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

static char ingress_ifname[IF_NAMESIZE];
static char egress_ifname[IF_NAMESIZE];
static char buf_ifname[IF_NAMESIZE] = "(unknown-dev)";

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

int main(int argc, char **argv)
{   
    
    int egress_ifindex = -1;
    egress_ifindex = if_nametoindex(egress_ifname); //why ??
    
    // validate egress_ifname
    if (!(egress_ifindex)){ //TODO : change this part later...
				fprintf(stderr,
					"ERR: --egress \"%s\" not real dev\n",
					egress_ifname);
				return EXIT_FAILURE;
	}
   
    /* inject tc-bpf-file in the kernel */
    printf("TC attach BPF object %s to device %s\n",
			       TC_BPF_FILE, egress_ifname);
    
    if (tc_egress_attach_bpf(egress_ifname, TC_BPF_FILE)) {
			fprintf(stderr, "ERR: TC attach failed\n");
			exit(EXIT_FAILURE);
	}

    /* sleep for a specific time */
    int nb_sec = 10;
    printf("Sleep for %d sec\n", nb_sec);   
    sleep(nb_sec);

    /*  remove tc-bpf program */
    printf("TC remove tc-bpf program on device %s\n", egress_ifname);
    tc_remove_egress(egress_ifname);


    return 0;
}