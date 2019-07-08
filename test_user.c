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
int sock_server, sock_redir,sock_redir2, hacpt,hacpt2; // hooker sockets
int hooker_map;
typedef struct sockaddr_in sockaddr_in_t;


typedef struct sock_key sock_key_t;
struct sock_key {

    __u32 sip4;
    __u32 dip4;
    __u32 sport;
    __u32 dport;

};

/** Fonctions secondaires **/

/* retourne le chemin du cgroup root */
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

/* injecte les programmes eBPF */
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


/* récupère le descripteur du cgroup root   */
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

/* Initialise les sockets utilisés durant la redirection */
int hk_init_sock(void)
{
 
    int err, one;
    struct sockaddr_in addr;
    
    // create redirection socket
    // hooker userspace server
    if((sock_server= socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket server failed");
        return errno;
	}

    // redirection socket
    if((sock_redir = socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror(" Creation of hooker redirection socket failed");
        return errno;
	}

    // hooker server configuration
    // Allow reuse
    err = setsockopt(sock_server, SOL_SOCKET, SO_REUSEADDR,
                        (char *)&one, sizeof(one));
    if(err) {
        perror("setsockopt sock server failed");
        return errno;
    } 

    // Non-blocking sockets
    err = ioctl(sock_server, FIONBIO, (char*)&one); 
    if (err < 0)
    {
            perror("ioctl server failed");
            return errno;
    }

    // Bind server socket
    memset(&addr, 0, sizeof(struct sockaddr_in));
    addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = inet_addr("0.0.0.0");
    addr.sin_port = htons(H_SERV_PORT);
	err = bind(sock_server, (struct sockaddr *)&addr, sizeof(addr));
	if (err < 0) {
		perror("bind server failed()\n");
		return errno;
	}
    
    // listen server socket
    addr.sin_port = htons(H_SERV_PORT);
	err = listen(sock_server, 32);
	if (err < 0) {
		perror("listen server failed()\n");
		return errno;
	}   


    //hooker redirection socket 

    // Bind sock_redir
    struct sockaddr_in caddr;
    memset(&caddr, 0, sizeof(struct sockaddr_in));
    caddr.sin_family = AF_INET;
	caddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    caddr.sin_port = htons(H_PORT);
	err = bind(sock_redir, (struct sockaddr *)&caddr, sizeof(caddr));
	if (err < 0) {
		perror("bind socket failed()\n");
		return errno;
	}

    // Initiate Connect 
	addr.sin_port = htons(H_SERV_PORT);
	err = connect(sock_redir, (struct sockaddr *)&addr, sizeof(addr));
	if (err < 0 && errno != EINPROGRESS) {
		perror("connect socket client failed()\n");
		return errno;
	}

    // accept connection
    hacpt = accept(sock_server, NULL, NULL);
	if (hacpt < 0) {
		perror("accept server failed()\n");
		return errno;
	}

    
    return 0;
}

/* Ajoute la socket de redirection à la sockhash */
int hk_addsock_hmap(void)
{
  
    // add redirection socket to sockhash 
    sock_key_t sock_redir_key = {};  
    hooker_map = map_fd[0];  
    if(bpf_map_update_elem(hooker_map, &sock_redir_key, &sock_redir, BPF_ANY) != 0) {
        printf("bpf_map_update sock_redirhash failed\n");
        perror("bpf_map_update"); // TODO : remove ...
        return -1;
    }

    return 0; 
}

/* wrapper pour la récupération des données de l'application legacy */
int hk_get_datafrom_redirector(char *rcv_buf)
{   
    return recv(sock_redir, rcv_buf, MAXDATASIZE, 0); //sock_redir global
}


/* wrapper pour l'envoi des données vers l'application legacy */
int hk_snd_datato_redirector(char *snd_buf)
{
    return send(sock_redir, snd_buf, strlen(snd_buf), 0);
}

/** end fonctions secondaires **/




int hk_adapter_config(void)
{

    int ret;
    /* Initialisation des sockets */
    ret = hk_init_sock();
    if(ret < 0)
        return ret;

    /* Ajout de la socket de redirection à la sockhash */
    ret = hk_addsock_hmap();
    if(ret < 0)
        return ret;

    return 0;
}


/* fonction qui récupère les données de l'application legacy et les envoie vers le destinataire */

// retourne les données redirigées par redirector
int hk_recvfrom_redirector(char *rcv_data)
{
    int ret;
    //char buffer[MAXDATASIZE];
    bzero(rcv_data, sizeof(rcv_data));

    ret = hk_get_datafrom_redirector(rcv_data);
    if(ret < 0) {
        perror("Get data from redirector failed\n"); // TODO : change error message
        return errno;
    }  
    //rcv_data = buffer;
    return 0;

}

int hk_sendto_redirector(char *snd_data)
{
    int ret;
    ret = hk_snd_datato_redirector(snd_data);
    if(ret < 0) {
        perror("Send data to redirector failed\n"); //TODO : change error message
        return errno;
    }

    return 0; // or return ret
}



/* int hk_recvfrom_redirector(void)
{
    
    char buf[MAXDATASIZE];
    char *snd_buf = "First data...\n";
    int ret;

    ret = hk_snd_data(snd_buf);
    if(ret < 0){
        perror("first send failed");
        return errno;
    }
        
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
            printf("sock_server buf:%s\n",buf);
    }
    
           
    return 0;

} */




int main(int argc, char*argv[])
{
  
    int cgfd = 0, status = 0;
   

    printf("Loading bpf program redirector in kernel...\n");
    status = hk_inject_bpf(TEST_BPF_FILENAME);
    
    if(status)
        goto out;


    /* get cgroup root descriptor */

    cgfd = hk_get_cgroup_root_fd();
    if(cgfd < 0)
        goto out;
    

    /* Configure adapter */
    status = hk_adapter_config();
    if(status)
        goto close;


    /* Attach ebpf programs to... */
    // TODO : revoir cette section du code source
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
    
    ret = bpf_prog_attach(bpf_redir, hooker_map, BPF_SK_MSG_VERDICT,0);
    if(ret) {
            printf("Failed to attach bpf_redir to sockhash\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status = -1;
            goto err_skmsg;
    }

    char buf[MAXDATASIZE];

    for(;;){

        /*Recupérer les données provenant de Redirector */
        ret = hk_recvfrom_redirector(buf);
        if(ret < 0)   
            goto err_skmsg;
        

        /* Afficher ces données */
        printf("%s\n", buf);
        
        /* Les renvoyer à l'application émettrice */
        ret = hk_sendto_redirector(buf);
        if(ret < 0)
            goto err_skmsg;

        ret = recv(hacpt, buf, MAXDATASIZE, 0);
        if(ret < 0) {
                perror("recv hooker server failed\n");
                return errno;
        }
        //printf("ret: %d\n", ret);
        printf("sock_server:%s\n",buf);
    }

   // __hk_listen_app(); // TODO: don't forget test


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