
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




#include <bcc/bcc_common.h>
#include <bcc/libbpf.h>
#include <linux/bpf.h>

#include <stdbool.h>

#include "cgroup_helpers.h"
#include "common.h"

#define  CGROUP_PATH            "/test_cgroup"
#define BPF_LOG_BUF_SIZE        65536

char bpf_log_buf[BPF_LOG_BUF_SIZE];
// Define the Ping Loop 



int main(int argc, char **argv)
{   

	
    int prog_fd;
    int cgroup_fd;

    void* program = bpf_module_create_c("cgroups.c", 0, NULL, 0, false);
    void* start = bpf_function_start (program, "cgroup");
    size_t size = bpf_function_size (program, "cgroup");
    unsigned int kern_version = bpf_module_kern_version(program);
	

    printf("Loading bpf program in kernel...\n");
    prog_fd = bcc_prog_load(BPF_PROG_TYPE_CGROUP_SKB,
							"cgroup", start, size, "GPL",
							kern_version, 0, bpf_log_buf, BPF_LOG_BUF_SIZE); // voir le log
    
    if (prog_fd < 0) {
            printf("Failed to load bpf program: %s\n",bpf_log_buf);
            goto out;
    }
    printf("prog_fd = %d\tbpf_log_buf = %s\n", prog_fd, bpf_log_buf); 

    /* setup cgroup environnment */
    /*printf("Setup cgroup environnment ....\n");
    	if (setup_cgroup_environment()) {
		printf("Failed to setup cgroup environment\n");
		goto err;
	} */
    /* Create a cgroup, get fd and join it */
   /* printf("Creating test cgroup...\n");
    cgroup_fd = create_and_get_cgroup(CGROUP_PATH);
    if (cgroup_fd < 0) {
            printf("Failed to create test cgroup\n");
            goto err;
    } 
    printf("cgroup_fd = %d\n", cgroup_fd);
    printf("joining test cgroup...\n");
    if (join_cgroup(CGROUP_PATH)) {  // est-ce obligatoire ????
        printf("Failed to join test cgroup\n");
        goto err;
    }  */

    /* Attachage au cgroup root */
    
    char *cgroup_root_path;
    /* Trouver le cgroup root */
    cgroup_root_path = find_cgroup_root();
     /* Ouverture en.... */
    cgroup_fd = open(cgroup_root_path, O_RDONLY);
	if (cgroup_fd < 0) {
		log_err("Opening Cgroup");
		return -1;
	}
  

    /* Attach the bpf program */
    int ret;
    printf("Attaching bpf program...\n");
    ret = bpf_prog_attach(prog_fd, cgroup_fd, BPF_CGROUP_INET_EGRESS, BPF_F_ALLOW_MULTI);
	if(ret) {

            printf("Failed to attach bpf program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            goto err;
    } 

    int nb_sec = 30;
	printf("Sleeping  during : %d\n ", nb_sec);
	sleep(nb_sec);

    /* ping */
    /*int sockfd; 
	char *ip_addr , *addr = "www.google.com", *reverse_hostname; 
	struct sockaddr_in addr_con; 

	ip_addr = dns_lookup(addr, &addr_con); 
	if(ip_addr==NULL) 
	{ 
		printf("\nDNS lookup failed! Could not resolve hostname!\n"); 
		return 0; 
	} 

	reverse_hostname = reverse_dns_lookup(ip_addr); 
	printf("\nTrying to connect to '%s' IP: %s\n", addr, ip_addr); 
	printf("\nReverse Lookup domain: %s", reverse_hostname); 

	//socket() 
	sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_ICMP); 
	if(sockfd<0) 
	{ 
		printf("\nSocket file descriptor not received!!\n"); 
		return 0; 
	} 
	else
		printf("\nSocket file descriptor %d received\n", sockfd); 

	send_ping(sockfd, &addr_con, reverse_hostname, 
								ip_addr, addr);  */


    /* Removing bpf_program */
	printf("Removing bpf program...\nExit\n");
	ret = bpf_prog_detach2(prog_fd,cgroup_fd, BPF_CGROUP_INET_EGRESS);
    if(ret) {

            printf("Failed to detach bpf program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            goto err;
    } 

    
err:
    //cleanup_cgroup_environment();
    close(cgroup_fd); // La raison la plus probable pour laquelle detach ne fonctionnait pas.


out: 
    return 0;
}
