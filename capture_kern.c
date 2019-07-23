/*
 * kernel code of launcher
 */


#define KBUILD_MODNAME "foo"

#include <linux/if_ether.h>
#include <linux/ip.h>

#include <linux/bpf.h>
#include "./bpf/bpf_helpers.h"
#include "./bpf/bpf_endian.h"

#include "config.h"
#include "./lib/maps.h"

#define IPPROTO_VTL 200
struct vtlhdr{
	int value;
};

struct bpf_map_def SEC("maps") my_map = {
	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
	.key_size = sizeof(int),
	.value_size = sizeof(u32),
	.max_entries = 2,
};

SEC("xdp")
int xdp_capture_vtl_program(struct xdp_md *ctx)
{
    void *data_end = (void *)(long)ctx->data_end;
	void *data     = (void *)(long)ctx->data;

    struct ethhdr *eth = data;

    if (data + sizeof(*eth) > data_end)
		return XDP_DROP; // Est-ce la bonne action ?

    if((void *)eth + 1 > data_end)
        return XDP_DROP;

    if(eth->h_proto != ETH_P_IP)
        return XDP_PASS;
    
    struct iphdr *iph = data + sizeof(*eth);
    u8 iph_len = iph->ihl << 2;

    if((void *)iph + 1 > data_end)
        return XDP_PASS;

    if(iph->protocol != IPPROTO_VTL)
        return XDP_PASS;

    void *ip_pkt = data + ETH_HLEN; 

    //void *vtl_pkt = data + ETH_HLEN + iph_len;

    bpf_perf_event_output(ctx, &my_map, 0, ip_pkt, sizeof(ip_pkt *));

    //struct vtlhdr *vtlh = (struct vtlhdr *)(data + ETH_HLEN + iph_len);
    //transmit data to userspace
    

    return XDP_PASS;
}

char _license[] SEC("license") = "GPL";