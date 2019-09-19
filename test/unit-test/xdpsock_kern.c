
#define KBUILD_MODNAME "foo"
//#include <uapi/linux/bpf.h>
#include <linux/bpf.h>
#include "../../bpf/bpf_helpers.h"

struct bpf_map_def SEC("maps") xsks_map = {
	.type = BPF_MAP_TYPE_XSKMAP,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 2, //MAX_SOCKS
};

SEC("xdp_sock")
int xdp_sock_prog(struct xdp_md *ctx)
{
    int idx = 0;

    //qidconf: la file sur laquelle, il faut recevoir les datas

    return bpf_redirect_map(&xsks_map, idx, 0);
}