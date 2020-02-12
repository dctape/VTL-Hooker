#include <linux/ptrace.h>
#include <linux/version.h>
#include <linux/bpf.h>
#include <linux/if_ether.h>
#include <netinet/in.h> // IPPROTO_ICMP
#include <linux/ip.h>
#include "bpf/bpf_helpers.h" 

#include "../../include/vtl_kern.h"

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


SEC("xdp_arqin")
int xdp_arqin_prog(struct xdp_md *ctx)
{
	// Attention !!
	// On user space, a program willing to read the values
        // needs to call perf_event_open() on the perf event
        // (either for one or for all CPUs) and to store the file
        // descriptor into the map. This must be done before the
        // eBPF program can send data into it.	
	
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
	
	if (iph->protocol != IPPROTO_VTL)
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
	
	return XDP_DROP;
}

char _license[] SEC("license") = "GPL";
__u32 _version SEC("version") = LINUX_VERSION_CODE;