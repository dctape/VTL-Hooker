/* SPDX-License-Identifier: GPL-2.0 */

#include <linux/if_ether.h>
#include <linux/ip.h>

#include <linux/bpf.h>
#include "bpf/bpf_helpers.h"
#include "../lib/vtl_util.h"

struct bpf_map_def SEC("maps") xsks_map = {
	.type = BPF_MAP_TYPE_XSKMAP,
	.key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 64,  /* Assume netdev has no more than 64 queues */
};

/*struct bpf_map_def SEC("maps") xdp_stats_map = {
	.type        = BPF_MAP_TYPE_PERCPU_ARRAY,
	.key_size    = sizeof(int),
	.value_size  = sizeof(__u32),
	.max_entries = 64,
}; */

#define bpf_printk(fmt, ...)					\
({								\
	       char ____fmt[] = fmt;				\
	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
				##__VA_ARGS__);			\
})


SEC("xdp_sock")
int xdp_sock_prog(struct xdp_md *ctx)
{
        
        //__u32 *pkt_count;

        /* pkt_count = bpf_map_lookup_elem(&xdp_stats_map, &index);
        if (pkt_count) {

            // We pass every other packet 
            if ((*pkt_count)++ & 1)
                return XDP_PASS;
        } */

        // void *data = (void *)(long)ctx->data;
        // void *data_end = (void *)(long)ctx->data_end;

        // struct ethhdr *eth = (struct ethhdr *)data;
        // if(eth + 1 > data_end)
        //     return XDP_DROP;
        
        // struct iphdr *iph = (struct iphdr *)(eth + 1);
        // if(iph + 1 > data_end)
        //     return XDP_DROP;
        
        // bpf_printk("ip protocol : %d\n", iph->protocol);

        int index = ctx->rx_queue_index;

        void *data = (void *)(long)ctx->data;
        void *data_end = (void *)(long)ctx->data_end;

        struct ethhdr *eth = (struct ethhdr *)data;
        if(eth + 1 > data_end)
        	return XDP_DROP;
        
        struct iphdr *iph = (struct iphdr *)(eth + 1);
        if(iph + 1 > data_end)
             return XDP_DROP;

        if(iph->protocol != IPPROTO_VTL) {		
		return XDP_PASS;
	    }

	/* A set entry here means that the correspnding queue_id
        * has an active AF_XDP socket bound to it. */
        if (bpf_map_lookup_elem(&xsks_map, &index))
            return bpf_redirect_map(&xsks_map, index, 0);

        return XDP_PASS;
}

char _license[] SEC("license") = "GPL";
