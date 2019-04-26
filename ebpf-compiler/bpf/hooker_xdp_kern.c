/*
 * module du hooker capturant les données montantes
 */

#define KBUILD_MODNAME "foo"
#include <uapi/linux/bpf.h>
#include "bpf_helpers.h"

SEC("hooker_xdp")
int hooker_xdp_program(struct xdp_md *ctx){


}

char _license[] SEC("license") = "GPL";