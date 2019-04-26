/*
 * Programme en mode userspace affichant les statistiques
 * des paquets recus.
 */


#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <net/if.h>
#include <sys/resource.h>
#include <unistd.h>
 
#include <bpf/bpf.h>
#include "libbpf.h"
#include "bpf_load.h"
#include "bpf_util.h" // Pas trop utile pour ce programme


/* Exit return codes */
#define EXIT_OK             0
#define EXIT_FAIL			1
#define EXIT_FAIL_XDP       2



static int ifindex = -1;
static __u32 xdp_flags = 0; 
static char *ifname = "ens33"; // à modifier


static int attach_xdp_program(int fd)
{
	int err;
	fprintf(stderr, "Attaching XDP program on ifindex:%d device:%s\n",
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
    __u32 key = 0;
    long value = 0;

    bpf_map_update_elem(map_fd[0], &key, &value, BPF_ANY);
    bpf_map_update_elem(map_fd[1], &key, &value, BPF_ANY);
    bpf_map_update_elem(map_fd[2], &key, &value, BPF_ANY);
}

int main(int argc, char **argv){

    char filename[256];
    __u32 key = 0; // on peut l'utiliser en mode userspace
    long value;
    long tcp, udp, total;
 
    
    /* Copie du nom du programme eBPF, précisément du .o */
	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);

	
    /* Chargement et attachage du programme eBPF */
	fprintf(stdout, "Loading XDP program in Kernel\n");
	if (load_bpf_file(filename)){
		fprintf(stderr, "ERR in load_bpf_file(): %s", bpf_log_buf);
		return EXIT_FAIL;  // à modifier
	}

	
    /* Test sur le descripteur retourné */
	if (!prog_fd[0]) {
		fprintf(stderr, "ERR: load_bpf_file : %s\n", strerror(errno));
		return EXIT_FAIL; // à modifier 
	}

	ifindex = if_nametoindex(ifname);
	//xdp_flags = 0;

    /* Enlever XDP program quand le programme est interrompu */
    signal(SIGINT, remove_xdp_program);

    /* Initialisation */
    init_maps();
    /* Attacher le programme XDP */
    printf("Après attach_XDP\n");
	if(attach_xdp_program(prog_fd[0]) < 0)
    {
        fprintf(stdout, "link set xdp fd failed\n");
		return EXIT_FAIL_XDP;
    }
         
    printf("Après attach_XDP\n");

    
    /* Afficher les statistiques de capture */
    fprintf(stdout, "*******Statistics Packet*******\n\n");
    while(1)
    {
        if(bpf_map_lookup_elem(map_fd[0], &key, &value) != 0) // voir la description
            printf("DEBUG: bpf_map_lookup_elem failed\n");
        else
            tcp = value;
        
        if(bpf_map_lookup_elem(map_fd[1], &key, &value) != 0) 
            printf("DEBUG: bpf_map_lookup_elem failed\n");
        else
            udp = value;
        
        if(bpf_map_lookup_elem(map_fd[2], &key, &value) != 0)
            printf("DEBUG: bpf_map_lookup_elem failed\n");
        else
            total = value;
        
        fprintf(stdout, "tcp : %ld, udp : %ld, total : %ld\n", tcp, udp, total);
        sleep(6);
    }

    return 0;
}
