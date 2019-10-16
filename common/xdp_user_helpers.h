/* Common BPF/XDP functions used by userspace side programs */
#ifndef __XDP_USER_HELPERS_H
#define __XDP_USER_HELPERS_H

#include <linux/types.h>
#include <net/if.h>

//#include <bpf/libbpf.h>
//#include "common_libbpf.h"

struct xdp_config {
	
	char filename[512];
	char progsec[32];
	char pin_dir[512];
	bool do_unload;
	bool reuse_maps;

	__u32 xdp_flags;
	int ifindex;
	char *ifname;
	char ifname_buf[IF_NAMESIZE];

	/* af_xdp */
	__u16 xsk_bind_flags;
	int xsk_if_queue;
	bool xsk_poll_mode;
	// int redirect_ifindex;
	// char *redirect_ifname;
	// char redirect_ifname_buf[IF_NAMESIZE];	
	// char src_mac[18];
	// char dest_mac[18];
	
};


int xdp_link_attach(int ifindex, __u32 xdp_flags, int prog_fd);
int xdp_link_detach(int ifindex, __u32 xdp_flags, __u32 expected_prog_id);

struct bpf_object *load_bpf_and_xdp_attach(struct xdp_config *xdp_cfg);


#endif /*__XDP_USER_HELPERS_H */