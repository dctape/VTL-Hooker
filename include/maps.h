/*
 *
 * maps 
 * 
 */

#ifndef __MAPS_H
#define __MAPS_H

// Peut-être pas nécessaire
//#include "bpf_helpers.h" // pour bpf_map_def

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

#endif /* __MAPS_H */