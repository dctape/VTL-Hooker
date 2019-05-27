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
#define H_SERV_PORT 10000 // TODO : change name later...
#define H_PORT 10002

#define clean_errno() (errno == 0 ? "None" : strerror(errno))
#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)


/* globals */
int hserv, hsock, hacpt; // hooker sockets
int hooker_map;
typedef struct sockaddr_in sockaddr_in_t;


typedef struct sock_key sock_key_t;
struct sock_key {

    __u32 sip4;
    __u32 dip4;
    __u32 sport;
    __u32 dport;

};


char *find_cgroup_root(void)  // pas nécessaire
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

int hk_init_sock(void)
{
 
    int err, one;
    struct sockaddr_in addr;

    // create redirection socket
    // hooker userspace server
    if((hserv= socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket server failed");
        return errno;
	}

    // redirection socket
    if((hsock = socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket hooker failed");
        return errno;
	}

    // hooker server configuration
    // Allow reuse
    /*err = setsockopt(hserv, SOL_SOCKET, SO_REUSEADDR,
                        (char *)&one, sizeof(one));
    if(err) {
        perror("setsockopt server failed");
        return errno;
    } */

    // Non-blocking sockets
    err = ioctl(hserv, FIONBIO, (char*)&one); 
    if (err < 0)
    {
            perror("ioctl server failed");
            return errno;
    }

    // Bind server socket
    memset(&addr, 0, sizeof(struct sockaddr_in));
    addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    addr.sin_port = htons(H_SERV_PORT);
	err = bind(hserv, (struct sockaddr *)&addr, sizeof(addr));
	if (err < 0) {
		perror("bind server failed()\n");
		return errno;
	}
    
    // listen server socket
    addr.sin_port = htons(H_SERV_PORT);
	err = listen(hserv, 32);
	if (err < 0) {
		perror("listen server failed()\n");
		return errno;
	}   


    //hooker redirection socket 

    // Bind hsock
    struct sockaddr_in caddr;
    memset(&caddr, 0, sizeof(struct sockaddr_in));
    caddr.sin_family = AF_INET;
	caddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    caddr.sin_port = htons(H_PORT);
	err = bind(hsock, (struct sockaddr *)&caddr, sizeof(caddr));
	if (err < 0) {
		perror("bind socket failed()\n");
		return errno;
	}

    // Initiate Connect 
	addr.sin_port = htons(H_SERV_PORT);
	err = connect(hsock, (struct sockaddr *)&addr, sizeof(addr));
	if (err < 0 && errno != EINPROGRESS) {
		perror("connect socket client failed()\n");
		return errno;
	}

    // accept connection
    hacpt = accept(hserv, NULL, NULL);
	if (hacpt < 0) {
		perror("accept server failed()\n");
		return errno;
	}

    
    return 0;
}

int hk_get_data(char *rcv_buf)
{   
    return recv(hacpt, rcv_buf, MAXDATASIZE, 0); //hsock global
}

int hk_snd_data(char *snd_buf)
{
    return send(hsock, snd_buf, strlen(snd_buf), 0);
}

int __hk_listen_app(void)
{
    
    char buf[MAXDATASIZE];
    int ret;
    printf("******Données redirigées*******\n");
    while(1)
    {
            // récupérer les données redirigées
            bzero(buf, sizeof(buf));
            ret = hk_get_data(buf);
            if(ret < 0) {
                perror("Get data from app failed\n");
                return errno;
            }
            printf("%s\n",buf);

            // renvoyer les datas

            ret = hk_snd_data(buf);
            if(ret < 0) {
                perror("send data to app failed\n");
                return errno;
            }
            ret = recv(hacpt, buf, MAXDATASIZE, 0);
            if(ret < 0) {
                perror("recv hooker server failed\n");
                return errno;
            }
            printf("ret: %d\n", ret);
            printf("hserv buf:%s\n",buf);
    }
    
           
    return 0;

}


int hk_init_map(void)
{
  
    // add redirection socket to sockhash 
    sock_key_t hsock_key = {};  
    hooker_map = map_fd[0];  
    if(bpf_map_update_elem(hooker_map, &hsock_key, &hsock, BPF_ANY) != 0) {
        printf("bpf_map_update hsockhash failed\n");
        perror("bpf_map_update"); // TODO : remove ...
        return -1;
    }

    return 0; 
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
    int bpf_redir = prog_fd[1];
    int ret;

    ret = bpf_prog_attach(bpf_sockops, cgfd, BPF_CGROUP_SOCK_OPS, 
                                BPF_F_ALLOW_MULTI);
	if(ret) {
            printf("Failed to attach bpf_sockops to cgroup root program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status = -1;
            goto err_sockops;
    } 
    
    if(hk_init_sock())
        goto out;

    status = hk_init_map();
    if(status)
        goto close;


    ret = bpf_prog_attach(bpf_redir, hooker_map, BPF_SK_MSG_VERDICT,0);
    if(ret) {
            printf("Failed to attach bpf_redir to sockhash\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status = -1;
            goto err_skmsg;
    }


    __hk_listen_app(); // TODO: don't forget test


err_skmsg:
    
    printf("Removing bpf_redir program...\nExit\n");
    ret = bpf_prog_detach2(bpf_redir, hooker_map, BPF_SK_MSG_VERDICT);
    if(ret) {
                printf("Failed to detach bpf_redir program\tret = %d\n", ret);
                perror("bpf_prog_attach");
                status =-1; 
               
    }

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