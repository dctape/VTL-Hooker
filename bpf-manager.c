
#include "bpf-manager.h"

#include <stdio.h>

#include <linux/bpf.h>
#include "./bpf/bpf_load.h"
#include "./bpf/libbpf.h"

int sock_key_map, hooker_map;


/* injecte les programmes eBPF */
int bpf_inject(char *bpf_filename)
{
   if (load_bpf_file(bpf_filename)) {
        printf("erreur!");
        fprintf(stderr, "ERR in load_bpf_file(): %s\n", bpf_log_buf);
        return -1;
    } 

    if (!prog_fd[0])  {
        fprintf(stderr, "ERR: load_bpf_file : %s\n", strerror(errno));
        return -1;
    }

    return 0; 
}


int bpf_init_maps(void) // pas vraiment nécessaire
{
    __u32 key = 0;
    sock_key_t value = {};
    sock_key_map = map_fd[0];
    if(bpf_map_update_elem(sock_key_map, &key, &value, BPF_ANY) != 0){
        printf("update  sock_key_map failed\n");
        return -1;
    }

    return 0; 
}
