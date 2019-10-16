/*
 *
 * hooker userspace program
 * 
*/

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdarg.h>

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

//#include <linux/bpf.h> //TODO: replace with bpf/bpf.h
#include <bpf/bpf.h>
#include <bpf/libbpf.h>

#include "../common/defines.h" // for struct config or common_params ??
#include "../common/cgroup_helpers.h"
#include "../common/sock_user_helpers.h"

//TODO: mettre toutes les dépendances dans un dossier ?
#include "./adapter/adapter.h"
#include "./udp/udp.h"

// TODO: le configurer dans le makefile
#define REDIRECTOR_KERN_FILENAME       "redirector_kern_1.o" // hooker1
//#define REDIRECTOR_SOCKOPS_OBJ	   "redir1_sockops.o"

// temporary
#define CLIENT  1 
#define SERVER  2

int cgroup_fd = 0; //TODO: use a better way...
int host = CLIENT;

#define IO_BUFSIZE  1024

/* send data over an other protocol */
// hackish way : for now, not very portable, depend on host: client or server
//TODO : use switch for handle the different used protocols
// TODO: handle error code
void *adapter_snd(void *arg)
{ 
    
	int numBytes;
	char *io_buffer;
	char hooker_buffer[MAX_DATA_SIZE];

	io_buffer = (char *)malloc(IO_BUFSIZE);
	while (1)
	{
		/* data (+ metadata) received by adapter from redirector */
		numBytes = adapter_recvfrom_redirector(hooker_buffer);
		if(numBytes < 0){ // TODO: change this later...
			free(io_buffer); 
			return NULL;
		}

		fprintf(stderr,"Redirector : %s", hooker_buffer); // for tests

		/* copy data from hooker_buffer to io_buffer : is it optimal ? */
		if(memcpy(io_buffer, hooker_buffer, strlen(hooker_buffer)) == NULL){
		fprintf(stderr, "Error memcpy\n");
		return NULL;
		}

		fprintf(stderr,"io_buffer : %s", io_buffer);

		/* send data to host */
		if(host == CLIENT){

		numBytes = udp_snd(udpsock1, io_buffer, udpsock1_to);
		if (numBytes < 0){
			perror("Send data to server failed\n");
			free(io_buffer); 
			return NULL;
		}
		}
		else if (host == SERVER)
		{
		numBytes = udp_snd(udpsock2, io_buffer, udpsock2_to);
		if (numBytes < 0){
			perror("Send data to client failed\n");
			free(io_buffer); 
			return NULL;
		}
		}
		fprintf(stderr,"numBytes : %d", numBytes);
	}

	free(io_buffer); // is it compulsory ?   
}


/* receive data over an other protocol */
// hackish way : for now, not very portable, depend on host: client or server
//TODO : use switch for handle the different used protocols
//TODO : handle error code
void *adapter_rcv(void *arg){

	int numBytes;
	char *io_buffer;
	char hooker_buffer[MAX_DATA_SIZE];
	
	io_buffer = (char *)malloc(IO_BUFSIZE);
	while (1)
	{
		/* receive data over udp or udp-lite */
		if(host == CLIENT){

		numBytes = udp_rcv(udpsock1, io_buffer, IO_BUFSIZE - 1, udpsock1_to);
		if (numBytes < 0){
			perror("rcv data from server failed\n");
			free(io_buffer);
			return NULL;
		}
		}
		else if (host == SERVER)
		{
		numBytes = udp_rcv(udpsock1, io_buffer, IO_BUFSIZE - 1, udpsock1_to);
		if (numBytes < 0){
			perror("rcv data from client failed\n");
			free(io_buffer);
			return NULL;
		}
		}

		io_buffer[numBytes] = '\0';
		printf("udp_rcv : %s", io_buffer); // for tests 

		/* copy data from io_buffer to hooker_buffer */
		memcpy(hooker_buffer, io_buffer, strlen(io_buffer));

		/* send data to redirector */
		numBytes = adapter_sendto_redirector(hooker_buffer);
		if(numBytes < 0){
			free(io_buffer);
			return NULL;
		}

	}
    

}

int main(int argc, char*argv[])
{
  
        pthread_t thread_adapter_snd;
        pthread_t thread_adapter_rcv;
	int prog_fd[2]; /* skmsg_fd & sockops_fd */
	int status = 0; 
	int err; // TODO : err or status ? choose
	

	struct config redirector_cfg = {
		.filename = REDIRECTOR_KERN_FILENAME
	};
	redirector_cfg.prog_type[0] = BPF_PROG_TYPE_SK_MSG;
	redirector_cfg.prog_type[1] = BPF_PROG_TYPE_SOCK_OPS;

	redirector_cfg.prog_attach_type[0] = BPF_SK_MSG_VERDICT;
	redirector_cfg.prog_attach_type[1] = BPF_CGROUP_SOCK_OPS;

	/* get cgroup root descriptor */
	int cgroup_root_fd;
        cgroup_root_fd = get_cgroup_root_fd();
        if (cgroup_root_fd < 0)
            goto out;
	

	/* charger redirector_kern dans le noyau */
	printf("Loading bpf program redirector in kernel...\n");
	struct bpf_object *bpf_obj = NULL;
	bpf_obj = load_bpf_progs(&redirector_cfg);

	/* récupérer les descripteurs des ebpf progs */
	int i = 0;
	struct bpf_program *bpf_prog = NULL;
	bpf_object__for_each_program(bpf_prog, bpf_obj) {
		prog_fd[i] = bpf_program__fd(bpf_prog);
		i++;
	}

	/* récupérer sock_map_fd */
	struct bpf_map *sock_map = NULL;
	sock_map =bpf_object__find_map_by_name(bpf_obj, "hooker_map");
	int sock_map_fd;
	sock_map_fd = bpf_map__fd(sock_map);
	if (sock_map_fd < 0) {
		fprintf(stderr, "ERR: no sockmap found: %s\n",
			strerror(sock_map_fd));
		exit(EXIT_FAILURE);
	}

	/** Configurations **/

	/* Configure adapter */
	printf("Configure adapter module...\n");
        status = adapter_config();
        if (status)
            goto close;
	
	/* Configure communication over udp...change */
	printf("Configure udp module...\n");
        status = udp_config();
        if (status)
            goto close;
	
	
	/* Attacher skmsg_fd à sock_map */ 
	err =  bpf_prog_attach(prog_fd[0], sock_map_fd, BPF_SK_MSG_VERDICT,
				0);
	if (err) {
		fprintf(stderr, "ERR: bpf_prog_attach (skmsg_prog): %d (%s)\n",
			err, strerror(errno));
		goto close;
	}
	
	
	/* loading bpf program ~ redirector */
        // printf("Loading bpf program redirector in kernel...\n");
	// struct bpf_object *skmsg_bpf_obj = NULL;	
	// skmsg_bpf_obj =  load_bpf_and_skmsg_attach(&skmsg_cfg, sock_redir);
	// if (!skmsg_bpf_obj) {
	// 	exit(EXIT_FAILURE);
	// }

	/* ajouter la socket de redirection à la sockmap */
	sock_key_t sock_redir_key = {};
	err = bpf_map_update_elem(sock_map_fd, &sock_redir_key, 
	 			  &sock_redir, BPF_ANY); 	
	if (err != 0) {
	 	fprintf(stderr, "ERR: fail to add redirection socket to sockmap\n");
	 	exit(err); //goto or return;
	}

	/* load and attach redirector sockops program */

	err =  bpf_prog_attach(prog_fd[1], cgroup_root_fd, BPF_CGROUP_SOCK_OPS,
				BPF_F_ALLOW_MULTI);
	if (err) {
		fprintf(stderr, "ERR: bpf_prog_attach (skmsg_prog): %d (%s)\n",
			err, strerror(errno));
		goto close;
	}

	// struct bpf_object *sockops_bpf_obj = NULL;
	// sockops_bpf_obj = load_bpf_and_sockops_attach(&sockops_cfg);
	// if (!sockops_bpf_obj) {
	// 	exit(EXIT_FAILURE);
	// }
                     

        /* creation des threads pour l'envoi et la réception des données */
        err = pthread_create(&thread_adapter_snd, NULL, adapter_snd, NULL);
        if (err != 0) {
            perror("Error creation of adapter send thread");
            status = -1;
            goto detach; // don't forget  err =...
        }

        err = pthread_create(&thread_adapter_rcv, NULL, adapter_rcv, NULL);
        if(err != 0){
            perror("Error creation of adapter recv thread");
            status = -1;
            goto detach; // don't forget  err =...
        }

        /* wait created threads */
        err = pthread_join(thread_adapter_snd, NULL);
        err = pthread_join(thread_adapter_rcv, NULL);

detach:
close:
        close(cgroup_root_fd); // TODO : don'forget to close sockets.

out: 
        return status;
}