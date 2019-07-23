
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <linux/ip.h>
#include <linux/perf_event.h>

#include <linux/bpf.h>
#include <sys/ioctl.h>

#include "./bpf/bpf_load.h"
#include "./bpf/libbpf.h"
#include "./bpf/perf-sys.h"
#include "./bpf/trace_helpers.h"


#define CAPTURE_BPF_FILE    "capture_kern.o"

#define IPPROTO_VTL 200 
static int perf_fd;

static char *xdp_ifname = "ens33";

struct vtlhdr{

	int value;
	//TODO: add other members according use cases
};

static int print_vtl_packet(void *data, int size)
{
	//struct vtlhdr *vtlh = (struct  vtlhdr *)data;
	struct iphdr *iph = (struct iphdr *)data;
	printf("iph->protocol: %d", iph->protocol);
	
	return LIBBPF_PERF_EVENT_CONT;
}

static void test_bpf_perf_event(void)
{
	struct perf_event_attr attr = {
		.sample_type = PERF_SAMPLE_RAW,
		.type = PERF_TYPE_SOFTWARE,
		.config = PERF_COUNT_SW_BPF_OUTPUT,
	};
	int key = 0;

	perf_fd = sys_perf_event_open(&attr, -1/*pid*/, 0/*cpu*/, -1/*group_fd*/, 0);

	assert(perf_fd >= 0);
    /* if(perf_fd <= 0){
        fprintf(stderr,"ERR: sys_perf_event_open() failed\n");
        return 1;
    } */
	assert(bpf_map_update_elem(map_fd[0], &key, &perf_fd, BPF_ANY) == 0);
	ioctl(perf_fd, PERF_EVENT_IOC_ENABLE, 0);
}


int main(int argc, char **argv)
{   
    int ifindex_xdp = if_nametoindex(xdp_ifname);
	int ret;

    /* Injection du programme XDP */
    printf("XDP load BPF file in kernel\n");
	if(bpf_inject(CAPTURE_BPF_FILE)){
		printf("ERROR - Loading xdp file");
		return 1;
	}

    /* Configuration perf_event */
    test_bpf_perf_event();
    
    /* Attachage du programme BPF */
    printf("XDP attach BPF object to device %s\n",
			xdp_ifname);
    if (set_link_xdp_fd(ifindex_xdp, prog_fd[0], 0) < 0) {
		printf("link set xdp fd failed\n");
		return 1;
	}

    /* Lecture du perf event output */
	if (perf_event_mmap(perf_fd) < 0)
		return 1;

	ret = perf_event_poller(perf_fd, print_vtl_packet);

	/* Detacher programme xdp */
	printf("XDP remove xdp-bpf program on device %s\n", xdp_ifname);
	set_link_xdp_fd(ifindex_xdp, -1, 0);
    
    return 0;

}