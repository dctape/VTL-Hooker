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

#define HOOKER_BPF_FILENAME        "hooker_kern.o"


int main(int argc, char*argv[])
{
  
    int cgfd = 0, status = 0, err;
   
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

    
    
    /* Attach bpf programs to... */
    
    // TODO : revoir cette section du code source
    printf("Attaching bpf program...\n");

    err = bpf_attach_prog_redirector(cgfd);
    if(err != 0){
        bpf_detach_redirector_prog(err, cgfd);
        goto close;
    } 


    char buf[MAX_DATA_SIZE];

    for(;;){

      
        /*Recupérer les données provenant de Redirector */
        err = adapter_recvfrom_redirector(buf);
        if(err < 0){
            err = ERR_REDIRECTOR_SOCKOPS;
            goto detach;
        }   
            
        /* Afficher ces données */
        printf("%s\n", buf);
              
        /* Les renvoyer à l'application émettrice */
        err = adapter_sendto_redirector(buf);
        if(err < 0){
            err = ERR_REDIRECTOR_SOCKOPS;
            goto detach;
        }

    }

detach: 
    bpf_detach_redirector_prog(err, cgfd); // TODO : bad!!!

close:
    close(cgfd); 

out: 
    return status;
}