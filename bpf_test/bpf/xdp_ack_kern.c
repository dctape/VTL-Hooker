#include <linux/ptrace.h>
#include <linux/version.h>
#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <netinet/in.h> // IPPROTO_ICMP
#include <linux/ip.h>
#include <linux/icmp.h>
#include "bpf/bpf_helpers.h" 

#define min(a, b) ((a) < (b) ? (a) : (b))


/* Helper macro to print out debug messages */
#define bpf_printk(fmt, ...)				\
({							\
	char ____fmt[] = fmt;				\
	bpf_trace_printk(____fmt, sizeof(____fmt),	\
			 ##__VA_ARGS__);		\
})


#define SAMPLE_SIZE 64ul
#define MAX_CPUS 128

struct bpf_map_def SEC("maps") my_map = {
	.type = BPF_MAP_TYPE_PERF_EVENT_ARRAY,
	.key_size = sizeof(int),
	.value_size = sizeof(__u32),
	.max_entries = MAX_CPUS,
};

/*
 * Swaps destination and source MAC addresses inside an Ethernet header
 */
static __always_inline void swap_src_dst_mac(struct ethhdr *eth)
{
	__u8 h_tmp[ETH_ALEN];

	__builtin_memcpy(h_tmp, eth->h_source, ETH_ALEN);
	__builtin_memcpy(eth->h_source, eth->h_dest, ETH_ALEN);
	__builtin_memcpy(eth->h_dest, h_tmp, ETH_ALEN);
}

/*
 * Swaps destination and source IPv4 addresses inside an IPv4 header
 */
static __always_inline void swap_src_dst_ipv4(struct iphdr *iphdr)
{
	__be32 tmp = iphdr->saddr;

	iphdr->saddr = iphdr->daddr;
	iphdr->daddr = tmp;
}

SEC("xdp_ack")
int xdp_ack_prog(struct xdp_md *ctx)
{
	/* Metadata will be in the perf event before the packet data. */
	struct S {
		__u16 cookie;
		__u16 pkt_len;
	} metadata; //__packed
	
	void *data_end = (void *)(long)ctx->data_end;
	void *data = (void *)(long)ctx->data;
	struct ethhdr *eth = (struct ethhdr *) data;
	if (eth + 1 > data_end)
		return XDP_PASS;
	
	struct iphdr *iph = (struct iphdr *)(eth + 1);
	if (iph + 1 > data_end)
		return XDP_PASS;
	if (iph->protocol != IPPROTO_ICMP)
		return XDP_PASS;
	
	struct icmphdr *icmph = (struct icmphdr *) (iph + 1);
	if (icmph + 1 > data_end)
		return XDP_PASS;
	
	/* The XDP perf_event_output handler will use the upper 32 bits
	* of the flags argument as a number of bytes to include of the
	* packet payload in the event data. If the size is too big, the
	* call to bpf_perf_event_output will fail and return -EFAULT.
	*
	* See bpf_xdp_event_output in net/core/filter.c.
	*
	* The BPF_F_CURRENT_CPU flag means that the event output fd
	* will be indexed by the CPU number in the event map.
	*/
	__u64 flags = BPF_F_CURRENT_CPU;
	__u16 sample_size;
	int ret;

	metadata.cookie = 0xdead;
	metadata.pkt_len = (__u16)(data_end - data);
	sample_size = min(metadata.pkt_len, SAMPLE_SIZE);
	//flags |= (__u64)sample_size << 32;
        flags |= (__u64)metadata.pkt_len << 32;
	
	/* Transmission des datas vers l'application */
	ret = bpf_perf_event_output(ctx, &my_map, flags,
					&metadata, sizeof(metadata));
	if (ret)
		bpf_printk("perf_event_output failed: %d\n", ret);
	
	/* Swapping */
	swap_src_dst_mac(eth);
	swap_src_dst_ipv4(iph);

	/* modify icmp header */
	icmph->type = ICMP_ECHOREPLY;

	/* Renvoyer le paquet */
	__u32 action = XDP_TX; // Redirection vers la même carte réseau

	/* Retirer le payload du paquet */
	//int hdr_size = sizeof(struct ethhdr) + sizeof(struct iphdr) + sizeof(struct icmphdr);
	//int data_size = metadata.pkt_len - hdr_size;
	int offset = (int) (icmph + 1);
	if (bpf_xdp_adjust_tail(ctx, 0 - offset))
		return action;	
	
	return action;
}

char _license[] SEC("license") = "GPL";
__u32 _version SEC("version") = LINUX_VERSION_CODE;