#ifndef __DEFINES_H
#define __DEFINES_H

#include <net/if.h>
#include <linux/types.h>
#include <stdbool.h>

// Esssai recompilation
//TODO: supprimer struct config car pas plus nécessaire
struct config {
	
	int prog_type[3]; /* Nombre maximal de programme eBPF par fichier */
	int prog_attach_type[3];
	char filename[512];
	char progsec[32];
	char pin_dir[512];
	bool do_unload;
	bool reuse_maps;
	unsigned int attach_flags;

	/* skmsg */
	int sock_map_fd;

	/* sockops */
	int cgroup_fd;

	/* XDP */
	__u32 xdp_flags;
	int ifindex;
	char *ifname;
	char ifname_buf[IF_NAMESIZE];

	/* af_xdp */
	__u16 xsk_bind_flags;
	int xsk_if_queue;
	bool xsk_poll_mode;
	int redirect_ifindex;
	char *redirect_ifname;
	char redirect_ifname_buf[IF_NAMESIZE];	
	char src_mac[18];
	char dest_mac[18];
	
};

/* Defined in common_params.o */
extern int verbose;

/* Exit return codes */
#define EXIT_OK 		 0 /* == EXIT_SUCCESS (stdlib.h) man exit(3) */
#define EXIT_FAIL		 1 /* == EXIT_FAILURE (stdlib.h) man exit(3) */
#define EXIT_FAIL_OPTION	 2
#define EXIT_FAIL_XDP		30
#define EXIT_FAIL_BPF		40

#endif /*__DEFINES_H */
