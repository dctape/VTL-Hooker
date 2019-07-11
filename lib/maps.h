/*
 *
 * maps 
 * 
 */

#ifndef __HK_MAPS_
#define __HK_MAPS_

#include "../bpf/bpf_helpers.h"


/* map stockant la clé socket du client ou du serveur */ 
struct bpf_map_def SEC("maps") sock_key_map = {
    .type = BPF_MAP_TYPE_ARRAY,
    .key_size = sizeof(int),
    .value_size = sizeof(sock_key_t), // sock_key
    .max_entries = 1,
};

/* la sockhash associant sock_key et sockfd */
struct bpf_map_def SEC("maps") hooker_map = {
	.type = BPF_MAP_TYPE_SOCKHASH,
	.key_size = sizeof(sock_key_t),
	.value_size = sizeof(int),
	.max_entries = 20
};

#endif