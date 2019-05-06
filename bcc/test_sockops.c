
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <mntent.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/syscall.h>

#include <bcc/bcc_common.h>
#include <bcc/libbpf.h>
#include <linux/bpf.h>

#include <stdbool.h>

#include "cgroup_helpers.h"
#include "common.h"

#define BPF_LOG_BUF_SIZE        65536

char bpf_log_buf[BPF_LOG_BUF_SIZE];

int main(int argc, char *argv[])
{

    int prog_fd;
    int cgfd;
    void* program = bpf_module_create_c("sockops.c", 0, NULL, 0, false);
    void* start = bpf_function_start (program, "sockops");
    size_t size = bpf_function_size (program, "sockops");
    unsigned int kern_version = bpf_module_kern_version(program);

    printf("Loading bpf program in kernel...\n");
    prog_fd = bcc_prog_load(BPF_PROG_TYPE_SOCK_OPS,
							"sockops", start, size, "GPL",
							kern_version, 0, bpf_log_buf, BPF_LOG_BUF_SIZE);


    if (prog_fd < 0) {
            printf("Failed to load bpf program: %s\n",bpf_log_buf);
            goto out;
    }

    int mapfd  = bpf_table_fd(program, "counter");
     int key = 0, cnt = 0;
    bpf_update_elem(mapfd, &key, &cnt, BPF_ANY);

    char *cg_root_path = find_cgroup_root();
    cgfd = open(cg_root_path, O_RDONLY);
	if (cgfd < 0) {
		log_err("Opening Cgroup");
		return -1;
	}

     /* Attach the bpf program */

    printf("Attaching bpf program...\n");
    int ret = bpf_prog_attach(prog_fd, cgfd, BPF_CGROUP_SOCK_OPS, BPF_F_ALLOW_MULTI);
	if(ret) {

            printf("Failed to attach bpf program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            goto err;
    }

    
   
    for (int i = 0; i < 30; i++)
    {
        if(bpf_lookup_elem(mapfd, &key, &cnt))
            goto rem;
        printf("sock : %d\n", cnt);
        sleep(6);
    }
   /* int nb_sec = 30;
	printf("Sleeping  during : %d\n ", nb_sec);
	sleep(nb_sec); */



rem: 
    /* Removing bpf_program */
	printf("Removing bpf program...\nExit\n");
	ret = bpf_prog_detach2(prog_fd,cgfd, BPF_CGROUP_SOCK_OPS);
    if(ret) {

            printf("Failed to detach bpf program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            goto err;//cleanup_cgroup_environment();
    } 

    
err:

    close(cgfd); // La raison la plus probable pour laquelle detach ne fonctionnait pas.


out: 
    return 0;

}