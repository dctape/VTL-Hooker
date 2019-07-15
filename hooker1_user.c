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

#include <linux/bpf.h>
#include "./bpf/bpf_load.h"
#include "./bpf/libbpf.h"

#include "./lib/util.h"
#include "adapter.h"
#include "bpf-manager.h"
#include "udp.h"

#define HOOKER_BPF_FILENAME        "hooker1_kern.o"

#define CLIENT  1 // temporary
#define SERVER 2

int cgfd = 0; //TODO: use a better way...
int host = CLIENT;

#define IO_BUFSIZE  1024

/* envoie  des datas par le hooker */
void *adapter_snd(void *arg){ // a  hackish way to avoid code duplication
    
    int numBytes;
    char *io_buffer;
    char hooker_buffer[MAX_DATA_SIZE];

    io_buffer = (char *)malloc(IO_BUFSIZE);
    while (1)
    {
         /* reception des données par adapter de redirector */
        numBytes = adapter_recvfrom_redirector(hooker_buffer);
        if(numBytes < 0){ // TODO: change this later...
                //err = ERR_REDIRECTOR_SOCKOPS;
                //goto detach;
                free(io_buffer); 
                return NULL;
        }

        fprintf(stderr,"Redirector : %s", hooker_buffer);
        /* envoie des datas */
        //TODO : faire un switch pour les différents protocoles sur lesquels envoyés

        /* copy data from hooker_buffer to io_buffer : is it optimal ? */
        memcpy(io_buffer, hooker_buffer, strlen(hooker_buffer));

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
    }

    //free(io_buffer);    
}

/* reception des datas par le hooker */
//TODO : error code
void *adapter_rcv(void *arg){

    int numBytes;
    char *io_buffer;
    char hooker_buffer[MAX_DATA_SIZE];
    
    io_buffer = (char *)malloc(IO_BUFSIZE);
    while (1)
    {
        /* reception des datas sur udp ou udp-lite : utiliser switch  */
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
        //TODO: mettre à zéro le buffer et ajouter '\0'
        io_buffer[numBytes] = '\0';
        printf("udp_rcv : %s", io_buffer);

        /* copy data from io_buffer to hooker_buffer */

        memcpy(hooker_buffer, io_buffer, strlen(io_buffer));
        /* envoie des datas à redirector */
        numBytes = adapter_sendto_redirector(hooker_buffer);
        if(numBytes < 0){
                free(io_buffer);
                return NULL;
        }

    }
    

}

int main(int argc, char*argv[])
{
  
        int status = 0, err; // TODO : choose btw status or err
        pthread_t thread_adapter_snd;
        pthread_t thread_adapter_rcv;
    
        /* loading bpf program ~ redirector */
        printf("Loading bpf program redirector in kernel...\n");
        status = bpf_inject(HOOKER_BPF_FILENAME); 
        if(status)
            goto out;


        /* get cgroup root descriptor */

        cgfd = get_cgroup_root_fd();
        if(cgfd < 0)
            goto out;
        

        /* Configure adapter */
        status = adapter_config();
        if(status)
            goto close;

        /* Configure communication over udp...change */
        status = udp_config();
        if(status)
            goto close;
        
        
        /* Attach bpf programs to... */
        
        // TODO : revoir cette section du code source
        printf("Attaching bpf program...\n");
        err = bpf_attach_prog_redirector(sock_redir,cgfd);
        if(err != 0){
            bpf_detach_redirector_prog(err, cgfd);
            goto close;
        } 

        /* creation des threads pour l'envoi et la réception des données */
        err = pthread_create(&thread_adapter_snd, NULL, adapter_snd, NULL);
        if(err != 0){
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
        err = ERR_REDIRECTOR_SOCKOPS; //hackish way...
        bpf_detach_redirector_prog(err, cgfd); // TODO : bad!!!

close:
        close(cgfd); // TODO : don'forget to close sockets.

out: 
        return status;
}