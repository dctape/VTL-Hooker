
#ifndef __ADAPTOR_RECEIVE_H
#define __ADAPTOR_RECEIVE_H

//#include "../include/vtl/vtl_structures.h"
#include "../common/xsk_user_helpers.h" // For struct xsk_socket_info

struct xsk_socket_info *
adaptor_create_xsk_sock(char *ifname, __u32 xdp_flags, __u16 xsk_bind_flags,
			int xsk_if_queue, char *err_buf);

void adaptor_rcv_data(vtl_md_t *vtl_md);

#endif /* __ADAPTOR_RECEIVE_H */