
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

#define  CGROUP_PATH            "/test_cgroup"
#define BPF_LOG_BUF_SIZE        65536

char bpf_log_buf[BPF_LOG_BUF_SIZE];


int main(int argc, char **argv)
{   

	int nb_sec = 50;
	//enum bpf_attach_type attach_type = BPF_CGROUP_INET_INGRESS;
	//int attach_flags = 0;
	int prog_fd, cgroup_fd;

    void* program = bpf_module_create_c("cgroups.c", 0, NULL, 0, false);
    void* start = bpf_function_start (program, "cgroups");
    size_t size = bpf_function_size (program, "cgroups");
	unsigned int kern_version = bpf_module_kern_version(program);
	

    printf("Loading bpf program in kernel...\n");
    prog_fd = bcc_prog_load(BPF_PROG_TYPE_CGROUP_SKB,
							"cgroups", start, size, "GPL",
							kern_version, 0, bpf_log_buf, BPF_LOG_BUF_SIZE); // voir le log
    

    if (prog_fd < 0) {
            printf("Failed to load bpf program: %s\n",bpf_log_buf);
            goto out;
    }
    printf("prog_fd = %d\tbpf_log_buf = %s\n", prog_fd, bpf_log_buf);

    /* setup cgroup environnment */
    printf("Setup cgroup environnment ....\n");
    	if (setup_cgroup_environment()) {
		printf("Failed to setup cgroup environment\n");
		goto err;
	}
    /* Create a cgroup, get fd and join it */
    printf("Creating test cgroup...\n");
    cgroup_fd = create_and_get_cgroup(CGROUP_PATH);
    if (cgroup_fd < 0) {
            printf("Failed to create test cgroup\n");
            goto err;
    }
    printf("cgroup_fd = %d\n", cgroup_fd);
    printf("joining test cgroup...\n");
    if (join_cgroup(CGROUP_PATH)) {  // est-ce obligatoire ????
        printf("Failed to join test cgroup\n");
        goto err;
    }

    /* Attach the bpf program */
    int ret;
    printf("Attaching bpf program...\n");
    ret = bpf_prog_attach(prog_fd, cgroup_fd, BPF_CGROUP_INET_EGRESS, BPF_F_ALLOW_MULTI);
	if(ret) {

            printf("Failed to attach bpf program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            goto err;
    }

	printf("Sleeping  during : %d\n ", nb_sec);
	sleep(nb_sec);


    /* Removing bpf_program */
	printf("Removing bpf program...\nExit\n");
	bpf_prog_detach2(prog_fd, cgroup_fd, BPF_CGROUP_INET_EGRESS);

err:
    cleanup_cgroup_environment();

out: 
    return 0;
}
