#ifndef __ADAPTOR_H
#define __ADAPTOR_H

#include <netinet/ip.h>       // struct ip and IP_MAXPACKET (which is 65535)
#include <net/if.h>           // struct ifreq
#include <sys/ioctl.h>        // macro ioctl is defined
#include <sys/types.h>        // needed for socket(), uint8_t, uint16_t, uint32_t

//TODO : Découpler adaptor de vtl_structures
//#include "../../include/vtl/vtl_structures.h"
#include "../../include/vtl.h"
#include "../../src/common/xsk_user_helpers.h" // For struct xsk_socket_info

/**
 * 
 * @param
 * @retval sockfd on success
 * @retval -1 on failure
 **/ 
int 
adaptor__create_raw_sock(int domain, int protocol, char *err_buf);

/**
 * 
 * @param
 * @retval 0 on success
 * @retval -1 on failure
 **/ 
int 
adaptor__config_raw_sock(int sockfd, char* interface, char *err_buf);


/**
 * 
 * @param
 * @retval 0 on success
 * @retval -1 on failure
 **/ 
int 
adaptor__send_packet(int sock_fd, uint8_t *snd_packet, vtlhdr_t *vtlh, struct ip *iphdr,  
                        char *target, char *dst_ip, char *src_ip, 
                        int *ip_flags, uint8_t *snd_data, size_t snd_datalen, char *err_buf);


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
adaptor__create_xsk_sock(char *ifname, __u32 xdp_flags, __u16 xsk_bind_flags,
			int xsk_if_queue, struct xsk_umem_info *umem, char *err_buf);


void 
adaptor__rcv_data(struct xsk_socket_info *xsk_socket, bool xsk_poll_mode,
		struct vtl_recv_params *rp);

// int 
// adaptor__listen_thread(vtl_md_t *vtl_md);

// int
// adaptor__stop_listen_thread(vtl_md_t *vtl_md);

// ssize_t
// adaptor__rcv_perf_data(sem_t *sem, struct perf_rcv_data_list *rcv_list,
// 			uint8_t *data);
// struct perf_rcv_data_list *
// adaptor__init_rlist(void);


#endif /* __ADAPTOR_H */