/*
 *
 * libbpf's wrapper
 * 
*/ 


#include "bpf-manager.h"
#include "../lib/config.h" //TODO: chercher à rendre indépendant de config.h

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#include <sys/wait.h>



#include <linux/bpf.h>

/*#include <linux/bpf.h>
#include "bpf_load.h"
#include "libbpf.h" */

static char tc_cmd[CMD_MAX_TC] = "tc";
static int verbose = 1; // TODO : delete later...

int sock_key_map, hooker_map;
int redirector_sockops_prog, redirector_skmsg_prog;

//TODO: Find a way to initialize from there 

/*int sock_key_map = map_fd[0];
int hooker_map = map_fd[1];

int redirector_sockops_prog = prog_fd[0];
int redirector_skmsg_prog = prog_fd[1]; */


/* injecte les programmes eBPF */
int bpf_inject(char *bpf_filename)
{
   if (load_bpf_file(bpf_filename)) {
        fprintf(stderr, "ERR in load_bpf_file(): %s\n", bpf_log_buf);
        return -1;
    } 
    return 0; 
}


/* int bpf_init_maps(void) // pas vraiment nécessaire
{
    __u32 key = 0;
    sock_key_t value = {};
    //sock_key_map = map_fd[0];
    if(bpf_map_update_elem(sock_key_map, &key, &value, BPF_ANY) != 0){
        printf("update  sock_key_map failed\n");
        return -1;
    }

    return 0; 
} */


int bpf_attach_redirector_prog(int sock_redir, int cgfd) {

    
    int err;
    // TODO : find another way
    sock_key_map = map_fd[0];
    hooker_map = map_fd[1];
    redirector_sockops_prog = prog_fd[0];
    redirector_skmsg_prog = prog_fd[1];

    /* Attach redirector_skmsg program */
    err = bpf_prog_attach(redirector_skmsg_prog, hooker_map, BPF_SK_MSG_VERDICT,0);
    if(err) {   
            perror("Attach redirector to hooker map failed\n");
            return ERR_REDIRECTOR_SKMSG;
    }

    /* add redirection socket to hooker_map */
    sock_key_t sock_redir_key = {};   
    if(bpf_map_update_elem(hooker_map, &sock_redir_key, &sock_redir, BPF_ANY) != 0) {
        perror("Add redirection socket failed\n"); // TODO : remove ...
        return ERR_REDIRECTOR_SKMSG;
    }

    /* attach redirector_sockops program */
    err = bpf_prog_attach(redirector_sockops_prog, cgfd, BPF_CGROUP_SOCK_OPS, 
                                BPF_F_ALLOW_MULTI);
	if(err) {
            perror("Failed to attach redirector to cgroup root\n");
            return ERR_REDIRECTOR_SOCKOPS;
    }

    return 0;

}


int bpf_detach_redirector_prog(int err_attach, int cgfd){

    int err;
    switch (err_attach)
    {
        case ERR_REDIRECTOR_SOCKOPS:
            
            err = bpf_prog_detach2(redirector_sockops_prog, cgfd, BPF_CGROUP_SOCK_OPS);
            if(err){
                perror("Failed to detach redirector sockops\n");
                return -1;
            }
            
            /* *err = bpf_prog_detach2(redirector_skmsg_prog, hooker_map, BPF_SK_MSG_VERDICT);
            if(err){
                perror("Failed to detach redirector sk_msg\n");
                return -1;
            }
            break; */

        case ERR_REDIRECTOR_SKMSG:

            err = bpf_prog_detach2(redirector_skmsg_prog, hooker_map, BPF_SK_MSG_VERDICT);
            if(err){
                perror("Failed to detach redirector sk_msg\n");
                return -1;
            }
            break; 
        default:
            break;
    }

    return 0;
}


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