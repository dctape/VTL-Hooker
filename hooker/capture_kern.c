/*
 * kernel code of launcher
 */


#define KBUILD_MODNAME "foo"

#include <linux/version.h>
#include <linux/ptrace.h>

#include <linux/if_ether.h>
#include <linux/ip.h>

#include <linux/bpf.h>
#include "../bpf/bpf_helpers.h"
#include "../bpf/bpf_endian.h"

#include "../lib/config.h"
#include "../lib/maps.h"

#define IPPROTO_VTL 200
struct vtlhdr{
	int value;
};

#define SAMPLE_SIZE 64ul
#define MAX_CPUS 128

#define bpf_printk(fmt, ...)					\
({								\
	       char ____fmt[] = fmt;				\
	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
				##__VA_ARGS__);			\
})

struct bpf_map_def SEC("maps") my_map = {
	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
	.key_size = sizeof(int),
	.value_size = sizeof(u32),
	.max_entries = MAX_CPUS, //TODO : Find why MAX_CPUS
};

struct vtl_data {
    __u16 eth_proto;

};

SEC("xdp_capture")
/*int xdp_capture_vtl_program(struct xdp_md *ctx)
{
    void *data_end = (void *)(long)ctx->data_end;
	void *data     = (void *)(long)ctx->data;

    struct ethhdr *eth = data;

    if (data + ETH_HLEN > data_end)
		return XDP_DROP; // Est-ce la bonne action ?

    struct vtl_data data_s = {
        .eth_proto = eth->h_proto,
    };

    bpf_perf_event_output(ctx, &my_map, 0, &data_s, sizeof(data_s));

    //if((void *)eth + 1 > data_end)
    //    return XDP_DROP;



    /* if(eth->h_proto != ETH_P_IP)
        return XDP_PASS;
    
    struct iphdr *iph = data + sizeof(*eth);
    u8 iph_len = iph->ihl << 2;

    if((void *)iph + 1 > data_end)
        return XDP_PASS;

    if(iph->protocol != IPPROTO_VTL)
        return XDP_PASS;

    u8 proto = iph->protocol; */

    //void *ip_pkt = data + ETH_HLEN; 

    //void *vtl_pkt = data + ETH_HLEN + iph_len;

    /* int err;
    err = xdp_event_output(ctx, &my_map, 0, &test, sizeof(test));
    if (err < 0)
        return XDP_PASS; */

    //struct vtlhdr *vtlh = (struct vtlhdr *)(data + ETH_HLEN + iph_len);
    //transmit data to userspace
    

    //return XDP_DROP;
//}

int xdp_capture_prog(struct xdp_md *ctx)
{
    void *data_end = (void *)(long)ctx->data_end;
	void *data = (void *)(long)ctx->data;

    struct S {
        u16 cookie;
        u16 eth_proto;
    } __packed metadata; // TODO: find a better name

    struct ethhdr *eth = data;

    if (data + ETH_HLEN > data_end)
		return XDP_DROP;
    
    u64 flags = BPF_F_CURRENT_CPU;
    u16 sample_size;

    metadata.cookie = 0xdead;
    metadata.eth_proto = eth->h_proto;
    sample_size = min(metadata.pkt_len, SAMPLE_SIZE);
	flags |= (u64)sample_size << 32;

    bpf_perf_event_output(ctx, &my_map, flags,
					    &metadata, sizeof(metadata));

    return XDP_PASS;
}


char _license[] SEC("license") = "GPL";
u32 _version SEC("version") = LINUX_VERSION_CODE;