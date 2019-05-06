/*
 *
 *
 * Programme userspace pour  cgroup_kern
 *  
 * 
*/

#include <bpf/bpf.h>
#include "bpf_load.h"

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
#include <stdbool.h>
//#include "cgroup_helpers.h"


//#include "common.h"

#define  CGROUP_PATH            "/test_cgroup"
#define clean_errno() (errno == 0 ? "None" : strerror(errno))
#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)

//#define BPF_LOG_BUF_SIZE        65536

//char bpf_log_buf[BPF_LOG_BUF_SIZE];

char *find_cgroup_root(void);

int main(int argc, char **argv)
{   

    char filename[256];
    int status = 0;

    snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
    
    printf("Loading bpf program in kernel...\n");
    if (load_bpf_file(filename)) {
        fprintf(stderr, "ERR in load_bpf_file(): %s", bpf_log_buf);
        status = -1;
        goto out;
    }

    if (!prog_fd[0])  {
        fprintf(stderr, "ERR: load_bpf_file : %s\n", strerror(errno));
        status = -1;
        goto out;
    }

    printf("prog_fd = %d\tbpf_log_buf = %s\n", prog_fd[0], bpf_log_buf); 


    /* Attachage au cgroup root */
    
    char *cgroup_root_path;
    /* Trouver le cgroup root */
    cgroup_root_path = find_cgroup_root();
     /* Ouverture en lecture seule... */
    int cgroup_fd = open(cgroup_root_path, O_RDONLY);
    if (cgroup_fd < 0) {
	log_err("Opening root cgroup");
        status = -1;
	goto out;
    }
  

    /* Attach the bpf program */

    printf("Attaching bpf program...\n");
    int ret = bpf_prog_attach(prog_fd[0], cgroup_fd, BPF_CGROUP_INET_EGRESS, BPF_F_ALLOW_MULTI);
    if(ret) {

          printf("Failed to attach bpf program\tret = %d\n", ret);
          perror("bpf_prog_attach");
          status = -1;
          goto err;
    } 

    int nb_sec = 30;
    printf("Sleeping  during : %d\n ", nb_sec);
    sleep(nb_sec);


    /* Removing bpf_program */
    printf("Removing bpf program...\nExit\n");
    ret = bpf_prog_detach2(prog_fd[0], cgroup_fd, BPF_CGROUP_INET_EGRESS);
    if(ret) {

            printf("Failed to detach bpf program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status = -1;
            goto err;
    } 

    
err:
    close(cgroup_fd); // La raison la plus probable pour laquelle detach ne fonctionnait pas.


out: 
    return status;
}

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
