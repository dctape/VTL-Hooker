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

// gestion de thread
#include <semaphore.h>
#include <pthread.h>
#include <mqueue.h>

#include <sys/socket.h>


//#include <bpf/bpf.h> // à revoir !!!
#include "bpf_load.h"
#include "libbpf.h"


#define  CGROUP_PATH            "/test_cgroup"
#define clean_errno() (errno == 0 ? "None" : strerror(errno))
#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)

#define MAXDATASIZE 100


int cg_fd;

struct sock_key{

    __u32 sip4;
    __u32 dip4;
    __u32 sport;
    __u32 dport;

} ;

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

/* fonction d'écoute */
// Tester d'abord sans thread.

int sk_listen(int sockfd)
{
    char buffer[MAXDATASIZE];
    int numbytes;
    /* réception des données venant de l'application legacy */
    bzero(buffer, sizeof(buffer));
    if((numbytes = recv(sockfd, buffer, MAXDATASIZE, 0)) == -1){
			perror("recv");
			return -1;
	}
    // affichage du message
    printf("message rédirigé: %s", buffer);
    return 0;

}


int main(int argc, char*argv[])
{
    char bpf_file[256];
    int status = 0;

    /* Charger le programme ebpf dans le noyau */
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
     
    
    /* création de socket de redirection */
    int sockfd;
    if((sockfd = socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket");
        status = -1;
		goto out;
	}
    

    /* Récupération du descripteur du cgroup root */
    char *cgroup_root_path = find_cgroup_root();
    cg_fd = open(cgroup_root_path, O_RDONLY);
	if (cg_fd < 0) {
		log_err("Opening Cgroup");
        status = -1;
		goto out;
	}

    /* Initialisation de la map de comptage */
    __u32 key = 0;
    long value = 0;
    int cnt_map = map_fd[0];
    if(bpf_map_update_elem(cnt_map, &key, &value, BPF_ANY) != 0){
        printf("update  cnt_map failed\n");
        status = -1;
        goto close; 
    }

    /* ajout de la socket de redirection à la sockhash */
    /*struct sock_key redir_key = {};
    redir_key.dip4 = 0;
    redir_key.sip4 = 0;
    redir_key.dport = 0;
    redir_key.sport = 0;*/
    
    int sockhash2 = map_fd[2];
    /*if(bpf_map_update_elem(sockhash2, &key, &sockfd, BPF_ANY) != 0) {
        printf("update sockhash2 failed\n");
        perror("bpf_map_update");
        status = -1;
        goto close;
    } */

    int sockhash = map_fd[1];
    /*if(bpf_map_update_elem(sockhash, &redir_key, &sockfd, BPF_ANY) != 0) {
        printf("update sockhash failed\n");
        status = -1;
        goto close;
    } */


    /* Attachage des programmes ebpf */
    
    printf("Attaching bpf program...\n");
    int bpf_sockops = prog_fd[0];
    int ret = bpf_prog_attach(bpf_sockops, cg_fd, BPF_CGROUP_SOCK_OPS, 
                                BPF_F_ALLOW_MULTI);
	if(ret) {
            printf("Failed to attach bpf_sockops to cgroup root program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status = -1;
            goto err_sockops;
    } 
    int bpf_redir = prog_fd[1];
    ret = bpf_prog_attach(bpf_redir, sockhash2, BPF_SK_MSG_VERDICT,0); //revoir le flag
    if(ret) {
            printf("Failed to attach bpf_redir to sockhash\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status = -1;
            goto err_skmsg;
    } 

    //int sockhash2 = map_fd[2];
    if(bpf_map_update_elem(sockhash2, &key, &sockfd, BPF_ANY) != 0) {
        printf("update sockhash2 failed\n");
        perror("bpf_map_update");
        status = -1;
        goto close;
    }

    printf("ajout réussi !");
    goto err_skmsg;
    /** hooker userspace **/

    for (int i = 0; i < 5; i++)
    {
        if(sk_listen(sockfd) != 0){

            status = -1; 
            goto err_skmsg;
        }
            
    }
    

    /*for (int i = 0; i < 30; i++)
    {
        if(bpf_map_lookup_elem(map_fd[0], &key, &value) != 0) // voir la description
            printf("DEBUG: bpf_map_lookup_elem failed\n");    
        
        printf("sock : %ld\n", value);
        sleep(6);
    } */

err_skmsg:
    
    printf("Removing bpf_redir program...\nExit\n");
    ret = bpf_prog_detach2(bpf_redir, sockhash2, BPF_SK_MSG_VERDICT);
    if(ret) {
                printf("Failed to detach bpf_redir program\tret = %d\n", ret);
                perror("bpf_prog_attach");
                status =-1; // attention au doublon
                //goto err2;          
    }


err_sockops:  

    printf("Removing bpf program...\nExit\n");
    ret = bpf_prog_detach2(bpf_sockops, cg_fd, BPF_CGROUP_SOCK_OPS);
    if(ret) {

                printf("Failed to detach bpf program\tret = %d\n", ret);
                perror("bpf_prog_attach");
                status =-1;
                //goto err2;          
    }


close:
    close(cg_fd); // La raison la plus probable pour laquelle detach ne fonctionnait pas.
    close(sockfd);

out: 
    return status;
}



