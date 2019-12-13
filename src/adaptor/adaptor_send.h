
#ifndef __ADAPTOR_SEND_H
#define __ADAPTOR_SEND_H

#include <netinet/ip.h>       // struct ip and IP_MAXPACKET (which is 65535)
#include <net/if.h>           // struct ifreq
#include <sys/ioctl.h>        // macro ioctl is defined
#include <sys/types.h>        // needed for socket(), uint8_t, uint16_t, uint32_t

#include "../../include/vtl/vtl_structures.h"

/**
 * 
 * @param
 * @retval sockfd on success
 * @retval -1 on failure
 **/ 
int 
adaptor_create_raw_sock(int domain, int protocol, char *err_buf);

/**
 * 
 * @param
 * @retval 0 on success
 * @retval -1 on failure
 **/ 
int 
adaptor_config_raw_sock(int sockfd, char* interface, char *err_buf);

/**
 * 
 * @param
 * @retval 0 on success
 * @retval -1 on failure
 **/ 
int 
adaptor_send_packet(int sock_fd, uint8_t *snd_packet, vtlhdr_t *vtlh, struct ip *iphdr,  
                        char *target, char *dst_ip, char *src_ip, 
                        int *ip_flags, uint8_t *snd_data, size_t snd_datalen, char *err_buf);



#endif /* __ADAPTOR_SEND_H */