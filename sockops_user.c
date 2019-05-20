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
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <netdb.h>

#include <sys/ioctl.h>

//#include <bpf/bpf.h> // à revoir !!!
#include "bpf_load.h"
#include "libbpf.h"


#define  CGROUP_PATH            "/test_cgroup"
#define clean_errno() (errno == 0 ? "None" : strerror(errno))
#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)

#define MAXDATASIZE 100
#define SA struct sockaddr
#define PORT 8080
#define S1_PORT 10000
#define S2_PORT 10001
#define H_PORT 10002

/* globals */
int cg_fd;
int hserv, hsock, hacpt, hsockUDP;
char *serv_addr = "192.168.130.137";
struct sockaddr_in to;

struct sock_key{

   // __u32 sip4;
   // __u32 dip4;
    __u32 sport;
   // __u32 dport;

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


int h_init_sockets(void)
{
    // server socket
    int err, one;
    struct sockaddr_in addr;

    // create redirection socket
    if((hserv= socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket server failed");
        return errno;
	}

    if((hsock = socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket hooker failed");
        return errno;
	}

    // Allow reuse
    err = setsockopt(hserv, SOL_SOCKET, SO_REUSEADDR,
                        (char *)&one, sizeof(one));
    if(err) {
        perror("setsockopt server failed");
        return errno;
    }

    // Non-blocking sockets => pour le accept
    err = ioctl(hserv, FIONBIO, (char*)&one); // changer pour fcntl
    if (err < 0)
    {
            perror("ioctl server failed");
            return errno;
    }

    // Bind server socket
    memset(&addr, 0, sizeof(struct sockaddr_in));
    addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = inet_addr("127.0.0.1");

    addr.sin_port = htons(S1_PORT);
	err = bind(hserv, (struct sockaddr *)&addr, sizeof(addr));
	if (err < 0) {
		perror("bind server failed()\n");
		return errno;
	}
    
    // listen server socket
    addr.sin_port = htons(S1_PORT);
	err = listen(hserv, 32);
	if (err < 0) {
		perror("listen server failed()\n");
		return errno;
	}   


    //socket client

    // Bind client
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

    /* Initiate Connect */
	addr.sin_port = htons(S1_PORT);
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

    // augmenter SND_BUF ???

    // socket UDP for sending and receiving

    hsockUDP = socket(AF_INET, SOCK_DGRAM, 0);
    if(hsockUDP < 0) {
        perror("creation socket UDP failed!");
        return errno;
    }

    // Bind socket UDP , for, server or socket
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(S2_PORT);
    err = bind(hsockUDP, (struct sockaddr *)&addr, sizeof(addr));
	if (err < 0) {
		perror("bind socket UDP failed()\n");
		return errno;
	}

    // Fill destination information
    // server
    to.sin_family = AF_INET;
    to.sin_port = htons(S2_PORT);
    to.sin_addr.s_addr = inet_addr(serv_addr);

    
    return 0;
}

int h_listen_app(void)
{
    char buffer[MAXDATASIZE];
    int ret;
    while(1){
            /* réception des données venant de l'application legacy */
            bzero(buffer, sizeof(buffer));
            if((ret = recv(hsock, buffer, MAXDATASIZE, 0)) == -1){
                    perror("recv");
                    return -1;
            }
            // affichage du message
            printf("message rédirigé: %s", buffer);

            // Transmission pour l'injection des données vers la destination
            if((ret = sendto(hsockUDP, buffer, strlen(buffer), 0, 
                    (const struct sockaddr *) &to, sizeof(to))) < 0 ) {

                        perror("sendto()");
                        return errno;

            }
    }
    
           
    return 0;

}

int h_sendto_app(void)
{
    // read data from server
    char buffer[MAXDATASIZE];
    int ret;
    int tosize = sizeof(to);
    while(1){
            bzero(buffer, sizeof(buffer));
            ret = recvfrom(hsockUDP, buffer, MAXDATASIZE, 0, 
                            (struct sockaddr *)&to, (socklen_t *)&tosize);
            if(ret < 0) {
                perror("recvfrom ()");
                return errno;
            }

            // send read data to legacy app
            if (send(hsock, buffer, strlen(buffer), 0) == -1){
                    perror("send ");
                    return errno;
             }
    }
    


    return 0;
}

void *thread_listen(void *arg)
{
    (void) arg;
    h_listen_app();
    pthread_exit(NULL);
}

void *thread_sendto(void *arg)
{
    (void) arg;
    h_sendto_app();
    pthread_exit(NULL);
}

int main(int argc, char*argv[])
{
    char bpf_file[256];
    int status = 0;

    /* Charger le programme ebpf dans le noyau */
    snprintf(bpf_file, sizeof(bpf_file), "%s_kern.o", argv[0]);
    
    printf("Loading bpf program in kernel...\n");
    if (load_bpf_file(bpf_file)) {
        printf("erreur!");
        fprintf(stderr, "ERR in load_bpf_file(): %s\n", bpf_log_buf);
        status = -1;
        goto out;
    } 

    if (!prog_fd[0])  {
        fprintf(stderr, "ERR: load_bpf_file : %s\n", strerror(errno));
        status = -1;
        goto out;
    } 
    
    
    if(h_init_sockets())
        goto out;


    /* Récupération du descripteur du cgroup root */
    char *cgroup_root_path = find_cgroup_root();
    cg_fd = open(cgroup_root_path, O_RDONLY);
	if (cg_fd < 0) {
		log_err("Opening Cgroup");
        status = -1;
		goto out;
	}

    /* Initialisation de la map de comptage */
    /*__u32 key = 0;
    long value = 0;
    int cnt_map = map_fd[0];
    if(bpf_map_update_elem(cnt_map, &key, &value, BPF_ANY) != 0){
        printf("update  cnt_map failed\n");
        status = -1;
        goto close; 
    } */

    /* ajout de la socket de redirection à la sockhash */
    struct sock_key hsock_key = {};
    /*redir_key.dip4 = 0;
    redir_key.sip4 = 0;
    redir_key.dport = 0;
    redir_key.sport = 0;*/
    
    int hmap = map_fd[1];  
    if(bpf_map_update_elem(hmap, &hsock_key, &hsock, BPF_ANY) != 0) {
        printf("bpf_map_update hsockhash failed\n");
        perror("bpf_map_update");
        status = -1;
        goto close;
    } 
 

    /* Attachage des programmes ebpf */
    
    printf("Attaching bpf program...\n");
    int bpf_sockops = prog_fd[0];
    int bpf_redir = prog_fd[1];
    int ret;

    ret = bpf_prog_attach(bpf_sockops, cg_fd, BPF_CGROUP_SOCK_OPS, 
                                BPF_F_ALLOW_MULTI);
	if(ret) {
            printf("Failed to attach bpf_sockops to cgroup root program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status = -1;
            goto err_sockops;
    } 
    
    ret = bpf_prog_attach(bpf_redir, hmap, BPF_SK_MSG_VERDICT,0); //revoir le flag
    if(ret) {
            printf("Failed to attach bpf_redir to sockhash\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status = -1;
            goto err_skmsg;
    } 
    
    /*printf("ajout réussi !\n");
    goto err_skmsg; */


    /** hooker userspace **/


    // Création de threads
    //thread d'écoute
    pthread_t h_listen_thread;
    pthread_t h_send_thread;

    ret = pthread_create(&h_listen_thread, NULL, thread_listen, NULL);
    if(ret)
    {
        perror("Erreur pthread d'écoute");
        status = -1;
        goto err_skmsg;
    }
    ret = pthread_create(&h_send_thread, NULL, thread_sendto, NULL);
    if(ret)
    {
        perror("Erreur pthread d'envoi");
        status = -1;
        goto err_skmsg;
    }


   /* printf("Hooker listen ...\n");
    for (int i = 0; i < 5; i++)
    {
        if(h_listen(hsock) != 0){

            status = -1; 
            goto err_skmsg;
        }
            
    } */
    

    /*for (int i = 0; i < 30; i++)
    {
        if(bpf_map_lookup_elem(map_fd[0], &key, &value) != 0) // voir la description
            printf("DEBUG: bpf_map_lookup_elem failed\n");    
        
        printf("sock : %ld\n", value);
        sleep(6);
    } */

    ret = pthread_join(h_listen_thread, NULL);
    if(ret)
    {
        perror("join listen failed");
        status = -1;
        goto err_skmsg;
    }
    ret = pthread_join(h_send_thread, NULL);
    if(ret)
    {
        perror("join sendto failed");
        status = -1;
        goto err_skmsg;
    }

err_skmsg:
    
    printf("Removing bpf_redir program...\nExit\n");
    ret = bpf_prog_detach2(bpf_redir, hmap, BPF_SK_MSG_VERDICT);
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
    close(hsock);

out: 
    return status;
}



