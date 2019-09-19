
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <linux/ip.h>
#include <net/if.h>
#include <sys/sysinfo.h>
#include <poll.h>
#include <linux/perf_event.h>

#include <linux/bpf.h>
#include <sys/mman.h>
#include <sys/ioctl.h>

#include "../bpf/bpf-manager.h"
#include "../bpf/perf-sys.h"
#include "../bpf/trace_helpers.h"



#define IPPROTO_VTL 200 
#define CAPTURE_BPF_FILE    "capture_kern.o"
#define MAX_CPUS 128
#define SAMPLE_SIZE 64

static int pmu_fds[MAX_CPUS], if_idx;
static struct perf_event_mmap_page *headers[MAX_CPUS];
static char *if_name;
static char *xdp_ifname = "ens33";

static int print_bpf_output(void *data, int size)
{
	struct {
		__u16 cookie;
		__u16 eth_proto;
		__u8  pkt_data[SAMPLE_SIZE];
	} __packed *e = data;
	int i;

	if (e->cookie != 0xdead) {
		printf("BUG cookie %x sized %d\n",
		       e->cookie, size);
		return LIBBPF_PERF_EVENT_ERROR;
	}

	printf("Pkt len: %-5d bytes. Ethernet hdr: ", e->eth_proto);
	/*for (i = 0; i < 14 && i < e->pkt_len; i++)
		printf("%02x ", e->pkt_data[i]); */
	printf("\n");

	return LIBBPF_PERF_EVENT_CONT;
}

static void test_bpf_perf_event(int map_fd, int num)
{
	struct perf_event_attr attr = {
		.sample_type = PERF_SAMPLE_RAW,
		.type = PERF_TYPE_SOFTWARE,
		.config = PERF_COUNT_SW_BPF_OUTPUT,
		.wakeup_events = 1, /* get an fd notification for every event */
	};
	int i;

	for (i = 0; i < num; i++) {
		int key = i;

		pmu_fds[i] = sys_perf_event_open(&attr, -1/*pid*/, i/*cpu*/,
						 -1/*group_fd*/, 0);

		assert(pmu_fds[i] >= 0);
		assert(bpf_map_update_elem(map_fd, &key,
					   &pmu_fds[i], BPF_ANY) == 0);
		ioctl(pmu_fds[i], PERF_EVENT_IOC_ENABLE, 0);
	}
}

/*static int print_vtl_packet(void *data, int size)
{
	//struct vtlhdr *vtlh = (struct  vtlhdr *)data;
	struct iphdr *iph = (struct iphdr *)data;
	
	struct vtl_data *data_s = data;
	printf("iph->protocol: %d", data_s->eth_proto);
	
	return LIBBPF_PERF_EVENT_CONT;
} */




int main(int argc, char **argv)
{   
    int ifindex_xdp = if_nametoindex(xdp_ifname);
	int ret;
	int numcpus;

	numcpus = get_nprocs();
	if (numcpus > MAX_CPUS)
		numcpus = MAX_CPUS;

    /* Injection du programme XDP */
    printf("XDP load BPF file in kernel\n");
	if(bpf_inject(CAPTURE_BPF_FILE)){
		printf("ERROR - Loading xdp file");
		return 1;
	}

	/* Attachage du programme BPF */
    printf("XDP attach BPF object to device %s\n",
			xdp_ifname);
    if (set_link_xdp_fd(ifindex_xdp, prog_fd[0], 0) < 0) {
		printf("link set xdp fd failed\n");
		return 1;
	}

    /* Configuration perf_event */
    test_bpf_perf_event(map_fd[0], numcpus);
    
    
    /* Lecture du perf event output */
	if (perf_event_mmap(perf_fd) < 0)
		return 1;

	for (i = 0; i < numcpus; i++)
		if (perf_event_mmap_header(pmu_fds[i], &headers[i]) < 0)
			return 1;
	
	ret = perf_event_poller_multi(pmu_fds, headers, numcpus,
				      print_bpf_output);

	/* Detacher programme xdp */
	printf("XDP remove xdp-bpf program on device %s\n", xdp_ifname);
	set_link_xdp_fd(ifindex_xdp, -1, 0);
    
    return 0;

}