
#ifndef __ADAPTOR_RECEIVE_H
#define __ADAPTOR_RECEIVE_H

#include "../../include/vtl/vtl_structures.h"
#include "../../src/common/xsk_user_helpers.h" // For struct xsk_socket_info

/**
 *  Create an af_xdp socket.
 * @param ifname - interface for attaching af_xdp socket
 * @param xdp_flags - required => a dependency with launcher
 * @param xsk_bind_flags - Creation mode
 * @param xsk_if_queue - ??
 * @param err_buf - Error buffer
 * @return pointer on 'af_xdp socket' or NULL on failure
 **/ 
struct xsk_socket_info *
adaptor_create_xsk_sock(char *ifname, __u32 xdp_flags, __u16 xsk_bind_flags,
			int xsk_if_queue, struct xsk_umem_info *umem, char *err_buf);

void 
adaptor_rcv_data(struct xsk_socket_info *xsk_socket, uint8_t *rcv_data,
		 size_t *rcv_datalen, bool xsk_poll_mode);

#endif /* __ADAPTOR_RECEIVE_H */