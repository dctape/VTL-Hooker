
#include "bpf-manager.h"
#include "./lib/config.h"

#include <stdio.h>
#include <string.h>
#include <errno.h>


#include <linux/bpf.h>
#include "./bpf/bpf_load.h"
#include "./bpf/libbpf.h"

int sock_key_map = map_fd[0];
int hooker_map = map_fd[1];

int redirector_sockops_prog = prog_fd[0];
int redirector_skmsg_prog = prog_fd[1];


/* injecte les programmes eBPF */
int bpf_inject(char *bpf_filename)
{
   if (load_bpf_file(bpf_filename)) {
        fprintf(stderr, "ERR in load_bpf_file(): %s\n", bpf_log_buf);
        return -1;
    } 
    return 0; 
}


int bpf_init_maps(void) // pas vraiment nécessaire
{
    __u32 key = 0;
    sock_key_t value = {};
    //sock_key_map = map_fd[0];
    if(bpf_map_update_elem(sock_key_map, &key, &value, BPF_ANY) != 0){
        printf("update  sock_key_map failed\n");
        return -1;
    }

    return 0; 
}


int bpf_attach_prog_redirector(int sock_redir, int cgfd) {

    
    int err;
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
