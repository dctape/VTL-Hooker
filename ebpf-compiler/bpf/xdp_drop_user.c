/*
 * Programme userspace de xdp_drop : Attache le programme xdp_drop_kern
 * puis le détache après un certain temps
 */

 #include <stdio.h>
 #include <stdlib.h>
 #include <net/if.h>
 #include <sys/resource.h>
 #include <unistd.h>
 
 #include <bpf/bpf.h>
 #include "libbpf.h"
 #include "bpf_load.h"
 #include "bpf_util.h" // Pas trop utile pour ce programme

 #define EXIT_FAIL			1


 static int attach_xdp_program(int ifindex, int fd, char *ifname, __u32 xdp_flags)
{
	int err;
	fprintf(stderr, "Attaching XDP program on ifindex:%d device:%s\n",
		ifindex, ifname);
	err = set_link_xdp_fd(ifindex, fd, xdp_flags);
	if (err < 0)
		printf("ERROR: failed to attach program to %s\n", ifname);

	return err;
}

static int remove_xdp_program(int ifindex, char *ifname, __u32 xdp_flags)
{
	int err;
  	fprintf(stderr, "Removing XDP program on ifindex:%d device:%s\n",
		ifindex, ifname);

	err = set_link_xdp_fd(ifindex, -1, xdp_flags);
	if (err < 0)
		printf("ERROR: failed to detach program from %s\n", ifname);

	exit(0);
}


int main(int argc, char **argv)
{
	char filename[256];
	char *ifname = "ens33"; // à modifier 
	int ifindex;
	__u32 xdp_flags = 0;
	unsigned int nb_sec = 10;

	/* Copie du nom du programme eBPF, précisément du .o */
	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);

	/* Chargement et attachage du programme eBPF */
	fprintf(stderr, "Loading XDP program in Kernel \n");
	if (load_bpf_file(filename)){
		fprintf(stderr, "ERR in load_bp_file(): %s", bpf_log_buf);
		return EXIT_FAIL;
	}

	/* Test sur le descripteur retourné */
	if (!prog_fd[0]) {
		fprintf(stderr, "ERR: load_bpf_file : %s\n", strerror(errno));
		return EXIT_FAIL;
	}

	ifindex = if_nametoindex(ifname);
	//xdp_flags = 0;

	if(attach_xdp_program(ifindex, prog_fd[0], ifname, xdp_flags) < 0)
		return -1;

	fprintf(stderr, "Sleeping XDP program during : %d\n ", nb_sec);
	sleep(nb_sec);
	
	if(remove_xdp_program(ifindex, ifname, xdp_flags) < 0)
		return -1;
	

	return 0;

}