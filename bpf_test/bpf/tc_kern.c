#include <linux/bpf.h>
#include <linux/pkt_cls.h>
#include "bpf/bpf_helpers.h"

#define __uint(name, val) int (*name)[val]

struct bpf_count
{
        int xdp_cnt;
        int tc_cnt;
        int tot_cnt;
};

/* iproute2 use another ELF map layout than libbpf.  The PIN_GLOBAL_NS
 * will cause map to be exported to /sys/fs/bpf/tc/globals/
 */
#define PIN_GLOBAL_NS	2
struct bpf_elf_map {
        __u32 type;
        __u32 size_key;
        __u32 size_value;
        __u32 max_elem;
        __u32 flags;
        __u32 id;
        __u32 pinning;
	__u32 inner_id;
	__u32 inner_idx;
};


//Don't work with clang 8 or 9
// struct bpf_map_def SEC("maps") tc_map = {
//         .type = BPF_MAP_TYPE_ARRAY_OF_MAPS,
//         .key_size = sizeof(__u32),
//         .value_size = sizeof(__u32),
//         .max_entries = 1,
//         .map_flags = 0,
// };

// struct {
// 	__uint(type, BPF_MAP_TYPE_ARRAY_OF_MAPS);
// 	__uint(max_entries, 1);
// 	__uint(map_flags, 0);
// 	__uint(key_size, sizeof(__u32));
// 	/* must be sizeof(__u32) for map in map */
// 	__uint(value_size, sizeof(__u32));
// } tc_map SEC(".maps");
// BPF_ANNOTATE_KV_PAIR(tc_map, __u32, __u32);

struct bpf_elf_map SEC("maps") map_shared = {
        .type   = BPF_MAP_TYPE_ARRAY,
        .size_key = sizeof(__u32),
        .size_value = sizeof(struct bpf_count),
        .max_elem = 2,
        .pinning = PIN_GLOBAL_NS,
};


SEC("tc_count")
int tc_count_prog(struct __sk_buff *skb)
{

        int key = 0;
        struct bpf_count *cnt;
        cnt = bpf_map_lookup_elem(&map_shared, &key);
        if (!cnt)
                return TC_ACT_OK;
        cnt->tc_cnt = cnt->tc_cnt + 1;
        cnt->tot_cnt = cnt->xdp_cnt + cnt->tc_cnt;

        return TC_ACT_OK;
}

char _license[] SEC("license") = "GPL";