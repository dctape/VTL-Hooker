/*
 * kernel code of launcher
 */
#define KBUILD_MODNAME "foo"
#include <linux/bpf.h>
#include "./bpf/bpf_helpers.h"
#include "./bpf/bpf_endian.h"

#include "config.h"
#include "./lib/maps.h"

SEC("xdp_tf")
int tf_xdp_program(struct xdp_md *ctx)
{
    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";