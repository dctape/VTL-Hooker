/* 
 *
 * Code dans l'espace utilisateur de sockops
 * 
*/ 

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
#include <signal.h>
#include <sys/resource.h>
#include <linux/bpf.h>

//#include <bpf/bpf.h> // à revoir !!!
#include "bpf_load.h"
#include "libbpf.h"


#define  CGROUP_PATH            "/test_cgroup"
#define clean_errno() (errno == 0 ? "None" : strerror(errno))
#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)


/* globals */
int cg_fd;

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

void detach_cgroup_root(int sig)
{
    fprintf(stderr,"Removing bpf program...\nExit\n");
	int ret = bpf_prog_detach2(prog_fd[0], cg_fd, BPF_CGROUP_SOCK_OPS);
    if(ret) {

            printf("Failed to detach bpf program\tret = %d\n", ret);
            perror("bpf_prog_attach");          
    }
    close(cg_fd);
    exit(0); 
}


int main(int argc, char*argv[])
{
    char bpf_file[256];
    int status = 0;


    snprintf(bpf_file, sizeof(bpf_file), "%s_kern.o", argv[0]);
    
    printf("Loading bpf program in kernel...\n");
    if (load_bpf_file(bpf_file)) {
        fprintf(stderr, "ERR in load_bpf_file(): %s\n", bpf_log_buf);
        status = -1;
        goto out;
    } 

    if (!prog_fd[0])  {
        fprintf(stderr, "ERR: load_bpf_file : %s\n", strerror(errno));
        status = -1;
        goto out;
    } 

    /****** Attachage au cgroup root *******/

    /* Trouver le cgroup root */
    char *cgroup_root_path = find_cgroup_root();
    cg_fd = open(cgroup_root_path, O_RDONLY);
	if (cg_fd < 0) {
		log_err("Opening Cgroup");
        status = -1;
		goto out;
	}

    __u32 key = 0;
    long value = 0;

    //initialisation
    bpf_map_update_elem(map_fd[0], &key, &value, BPF_ANY);
    
    printf("Attaching bpf program...\n");
    int ret = bpf_prog_attach(prog_fd[0], cg_fd, BPF_CGROUP_SOCK_OPS, 
                                BPF_F_ALLOW_MULTI);
	if(ret) {
            printf("Failed to attach bpf program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status = -1;
            goto err;
    } 


    for (int i = 0; i < 30; i++)
    {
        if(bpf_map_lookup_elem(map_fd[0], &key, &value) != 0) // voir la description
            printf("DEBUG: bpf_map_lookup_elem failed\n");    
        
        printf("sock : %ld\n", value);
        sleep(6);
    }
    

    printf("Removing bpf program...\nExit\n");
    ret = bpf_prog_detach2(prog_fd[0], cg_fd, BPF_CGROUP_SOCK_OPS);
    if(ret) {

            printf("Failed to detach bpf program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status =-1;
            goto err;          
    }

    
err:
    close(cg_fd); // La raison la plus probable pour laquelle detach ne fonctionnait pas.


out: 
    return status;
}



