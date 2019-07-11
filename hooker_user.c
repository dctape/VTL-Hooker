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

#define HOOKER_BPF_FILENAME        "hooker_kern.o"


int main(int argc, char*argv[])
{
  
    int cgfd = 0, status = 0;
   
    /* loading bpf program ~ redirector */
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

    
    
    /* Attach bpf programs to... */
    
    // TODO : revoir cette section du code source
    printf("Attaching bpf program...\n");
    int bpf_sockops = prog_fd[0];
    int bpf_redir = prog_fd[1];
    int ret;

    // Attach sk_msg programs 
    hk_map = map_fd[1]; // TODO : changer de position dans le code
    ret = bpf_prog_attach(bpf_redir, hk_map, BPF_SK_MSG_VERDICT,0);
    if(ret) {
            printf("Failed to attach bpf_redir to sockhash\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status = -1;
            goto err_skmsg; // TODO : change
    }

    // add redirection socket to hk_map
    sock_key_t sock_redir_key = {};   
    if(bpf_map_update_elem(hk_map, &sock_redir_key, &sock_redir, BPF_ANY) != 0) {
        printf("bpf_map_update sock_redirhash failed\n");
        perror("bpf_map_update"); // TODO : remove ...
        status = -1;
        goto err_skmsg;
    }

    // attach sockops programs...
    ret = bpf_prog_attach(bpf_sockops, cgfd, BPF_CGROUP_SOCK_OPS, 
                                BPF_F_ALLOW_MULTI);
	if(ret) {
            printf("Failed to attach bpf_sockops to cgroup root program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status = -1;
            goto err_sockops;
    } 
    
    

    char buf[MAXDATASIZE];

    // TODO : change later...
    int token, token_key = 0;
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
            goto err_sockops;

        /* ret = recv(hacpt, buf, MAXDATASIZE, 0);
        if(ret < 0) {
                perror("recv hooker server failed\n");
                return errno;
        } 
        //printf("ret: %d\n", ret);
        printf("sock_server:%s\n",buf); */
    }

   // __hk_listen_app(); // TODO: don't forget test



err_sockops:  

    printf("Removing bpf program...\nExit\n");
    ret = bpf_prog_detach2(bpf_sockops, cgfd, BPF_CGROUP_SOCK_OPS);
    if(ret) {

                printf("Failed to detach bpf program\tret = %d\n", ret);
                perror("bpf_prog_attach");
                status =-1;        
    }

err_skmsg:
    
    printf("Removing bpf_redir program...\nExit\n");
    ret = bpf_prog_detach2(bpf_redir, hk_map, BPF_SK_MSG_VERDICT);
    if(ret) {
                printf("Failed to detach bpf_redir program\tret = %d\n", ret);
                perror("bpf_prog_attach");
                status =-1; 
               
    }

close:
    close(cgfd); 

out: 
    return status;
}