#include <linux/bpf.h>
#include "bpf/bpf_helpers.h" // juste suffisant pour xdp_md

struct bpf_count
{
        int xdp_cnt;
        int tc_cnt;
        int tot_cnt;
};


struct bpf_map_def SEC("maps") map_shared = {
        .type = BPF_MAP_TYPE_ARRAY,
        .key_size = sizeof(__u32),
        .value_size = sizeof(struct bpf_count),
        .max_entries = 2,
        .map_flags = 0,
}; 

SEC("xdp_count")
int xdp_count_prog(struct xdp_md *ctx)
{
        int key = 0;
        struct bpf_count *cnt;     
        cnt = bpf_map_lookup_elem(&map_shared, &key);
        if (!cnt)
                return XDP_ABORTED;
        cnt->xdp_cnt = cnt->xdp_cnt + 1;

        return XDP_PASS;
        
}

char _license[] SEC("license") = "GPL";