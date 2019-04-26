/*
 * Programme en mode userspace affichant les statistiques
 * des paquets recus.
 */


#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <net/if.h> // if_nammetoindex()
#include <netinet/in.h>
#include <sys/resource.h> // pas nécessaire
#include <unistd.h> // Appel système
//#include <arpa/inet.h>
 
#include <bpf/bpf.h>
#include "libbpf.h"
#include "bpf_load.h"
#include "bpf_util.h" // Pas trop utile pour ce programme

static int ifindex = -1;
static __u32 xdp_flags = 0; 
static char *ifname = "ens33"; // à modifier

static int attach_xdp_program(int fd)
{
	int err;
	fprintf(stderr, "Attaching XDP program on ifindex:%d device:%s\n\n",
		ifindex, ifname);
	err = set_link_xdp_fd(ifindex, fd, xdp_flags);
	if (err < 0)
		printf("ERROR: failed to attach program to %s\n", ifname);

	return err;
}

static void remove_xdp_program(int sig)
{
	int err; // à modifier ??
  fprintf(stderr, "Removing XDP program on ifindex:%d device:%s\n",
		ifindex, ifname);

	err = set_link_xdp_fd(ifindex, -1, xdp_flags);
	if (err < 0)
		printf("ERROR: failed to detach program from %s\n", ifname);

	exit(0);
}

static void init_maps()
{
    int key = 0;
    long long value = 0;
    int max_entries = 256;

    for(key = 0; key < max_entries; key++)
    {
       bpf_map_update_elem(map_fd[0], &key, &value, BPF_ANY); 
    }
}

static void poll_stats(int intervall)
{
    long long tcp_cnt, udp_cnt, icmp_cnt, pkt_cnt;
    int key;

    fprintf(stdout, "****** Packets captured statistics ******\n\n");
    while(1)
    {
        key = IPPROTO_UDP;
        if (bpf_map_lookup_elem(map_fd[0], &key, &udp_cnt) != 0)
            printf("DEBUG: bpf_map_lookup_elem failed\n");
        
        key = IPPROTO_TCP;
        if (bpf_map_lookup_elem(map_fd[0], &key, &tcp_cnt) != 0)
            printf("DEBUG: bpf_map_lookup_elem failed\n");

        key = IPPROTO_ICMP;
        if (bpf_map_lookup_elem(map_fd[0], &key, &icmp_cnt) != 0)
            printf("DEBUG: bpf_map_lookup_elem failed\n");
        
        key = IPPROTO_IP; // Nombre total de paquets IP
        if (bpf_map_lookup_elem(map_fd[0], &key, &pkt_cnt) != 0)
            printf("DEBUG: bpf_map_lookup_elem failed\n");
        
        printf("tcp: %lld  |  udp: %lld  | icmp: %lld  | total: %lld\n", tcp_cnt,
                udp_cnt, icmp_cnt, pkt_cnt);
        
        sleep(intervall); // intervall pas "nécessaire"

    }
}


int main(int argc, char **argv)
{

    char filename[256];
    //__u32 key = 0; // on peut l'utiliser en mode userspace
    //long value;
    //long tcp, udp, total;
 
    
    /* Copie du nom du programme eBPF, précisément du .o */
	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);

	
    /* Chargement et attachage du programme eBPF */
	fprintf(stdout, "Loading XDP program in Kernel\n");
	if (load_bpf_file(filename)){
		fprintf(stderr, "ERR in load_bpf_file(): %s", bpf_log_buf);
		return 1;  // à modifier
	}

	
    /* Test sur le descripteur retourné */
	if (!prog_fd[0]) {
		fprintf(stderr, "ERR: load_bpf_file : %s\n", strerror(errno));
		return 1; // à modifier 
	}

	ifindex = if_nametoindex(ifname);
	//xdp_flags = 0;

    /* Enlever XDP program quand le programme est interrompu */
    signal(SIGINT, remove_xdp_program);

    /* Initialisation */
    init_maps();
    
    /* Attacher le programme XDP */
    //printf("Après attach_XDP\"n");
	if(attach_xdp_program(prog_fd[0]) < 0)
    {
        fprintf(stdout, "link set xdp fd failed\n");
		return 1;
    }
         
    //printf("Après attach_XDP\n");
   
    poll_stats(2);
  

    return 0;
}