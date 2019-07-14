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

/* envoie  des datas par le hooker */
void *adapter_snd(void *arg){ // a  hackish way to avoid code duplication
    
    int err;
    char buf[MAX_DATA_SIZE]; //TODO : instead use malloc()

    while (1)
    {
         /* reception des données par adapter de redirector */
        err = adapter_recvfrom_redirector(buf);
        if(err < 0){ // TODO: change this later...
                //err = ERR_REDIRECTOR_SOCKOPS;
                //goto detach;
                return NULL;
        }
        printf("Redirector : %s", buf);
        /* envoie des datas */
        //TODO : faire un switch pour les différents protocoles sur lesquels envoyés
        if(host == CLIENT){

            err = udp_snd(udpsock1, buf, udpsock1_to);
            if (err < 0){
                perror("Send data to server failed\n");
                return NULL;
            }
        }
        else if (host == SERVER)
        {
            err = udp_snd(udpsock2, buf, udpsock2_to);
            if (err < 0){
                perror("Send data to client failed\n");
                return NULL;
            }
        }
    }
        

}

/* reception des datas par le hooker */
//TODO : error code
void *adapter_rcv(void *arg){

    int numBytes;
    char buf[MAX_DATA_SIZE];

    

    while (1)
    {
        /* reception des datas sur udp ou udp-lite : utiliser switch  */
        if(host == CLIENT){

            numBytes = udp_rcv(udpsock1, buf, udpsock1_to);
            if (numBytes < 0){
                perror("rcv data from server failed\n");
                return NULL;
            }
        }
        else if (host == SERVER)
        {
            numBytes = udp_rcv(udpsock2, buf, udpsock2_to);
            if (numBytes < 0){
                perror("rcv data from client failed\n");
                return NULL;
            }
        }
        buf[numBytes] = '\0';
        printf("udp_rcv : %s", buf);
        /* envoie des datas à redirector */
        numBytes = adapter_sendto_redirector(buf);
        if(numBytes < 0){
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