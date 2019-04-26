/*
 * Programme XDP bloquant tous les paquets entrant au niveau de la NIC
 */
#define KBUILD_MODNAME "foo"
#include <uapi/linux/bpf.h>
#include "bpf_helpers.h" // contient le moyen de créer une section soit SEC

SEC("xdp_prog")
int xdp_drop_program(struct xdp_md *ctx)
{

	return XDP_DROP;
}

char _license[] SEC("license") = "GPL";
