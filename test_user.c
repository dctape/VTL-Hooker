/*
 *
 * userspace test program
 * 
*/
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdarg.h>
#include <mntent.h>
#include <stdbool.h>
#include <signal.h>
#include <fcntl.h>
#include <errno.h>

#include <semaphore.h>
#include <pthread.h>
#include <mqueue.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <netdb.h>

#include <sys/ioctl.h>
#include <sys/resource.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <linux/bpf.h>
#include "bpf_load.h"
#include "libbpf.h"

#define TEST_BPF_FILENAME        "test_kern.o"
#define MAXDATASIZE 100

#define clean_errno() (errno == 0 ? "None" : strerror(errno))
#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)



char *find_cgroup_root(void)
{
	struct mntent *mnt;
	FILE *f;

	f = fopen("/proc/mounts", "r");
	if(f == NULL)
		return NULL;
	while ((mnt = getmntent(f))) {
		if(strcmp(mnt->mnt_type, "cgroup2") == 0) {
			fclose(f);
			return strdup(mnt-> mnt_dir);
		}
	}

	fclose(f);
	return NULL;
}

int hk_inject_bpf(char *bpf_filename)
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

int hk_get_cgroup_root_fd(void)
{   
    int cgfd;
    char *cgroup_root_path = find_cgroup_root();
    cgfd = open(cgroup_root_path, O_RDONLY);
	if (cgfd < 0) {
		log_err("Opening Cgroup");
        return -1; // Revoir...
	}
    return cgfd;
}

int main(int argc, char*argv[])
{
  
    int cgfd = 0, status = 0;
   

    printf("Loading bpf program in kernel...\n");
    status = hk_inject_bpf(TEST_BPF_FILENAME);
    
    if(status)
        goto out;


    /* get cgroup root descriptor */

    cgfd = hk_get_cgroup_root_fd();
    if(cgfd < 0)
        goto out;

    
    /* Attach ebpf programs to... */
    
    printf("Attaching bpf program...\n");
    int bpf_sockops = prog_fd[0];
    int ret;

    ret = bpf_prog_attach(bpf_sockops, cgfd, BPF_CGROUP_SOCK_OPS, 
                                BPF_F_ALLOW_MULTI);
	if(ret) {
            printf("Failed to attach bpf_sockops to cgroup root program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status = -1;
            goto err_sockops;
    } 
    
    sleep(50);


err_sockops:  

    printf("Removing bpf program...\nExit\n");
    ret = bpf_prog_detach2(bpf_sockops, cgfd, BPF_CGROUP_SOCK_OPS);
    if(ret) {

                printf("Failed to detach bpf program\tret = %d\n", ret);
                perror("bpf_prog_attach");
                status =-1;        
    }


close:
    close(cgfd); 

out: 
    return status;
}