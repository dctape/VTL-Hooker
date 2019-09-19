
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <linux/ip.h>
#include <net/if.h>
#include <poll.h>
#include <linux/perf_event.h>

#include <linux/bpf.h>
#include <sys/mman.h>
#include <sys/ioctl.h>

#include "./bpf/bpf_load.h"
#include "./bpf/libbpf.h"
#include "./bpf/perf-sys.h"
#include "./bpf/trace_helpers.h"

#include "bpf-manager.h"

#define IPPROTO_VTL 200 
#define CAPTURE_BPF_FILE    "capture_kern.o"


static int perf_fd;
static char *xdp_ifname = "ens33";


int page_size;
int page_cnt = 8;
volatile struct perf_event_mmap_page *header;

typedef void (*print_fn)(void *data, int size);

static int perf_event_mmap(int fd)
{
	void *base;
	int mmap_size;

	page_size = getpagesize();
	mmap_size = page_size * (page_cnt + 1);

	base = mmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if (base == MAP_FAILED) {
		printf("mmap err\n");
		return -1;
	}

	header = base;
	return 0;
}

static int perf_event_poll(int fd)
{
	struct pollfd pfd = { .fd = fd, .events = POLLIN };

	return poll(&pfd, 1, 1000);
}

struct perf_event_sample {
	struct perf_event_header header;
	__u32 size;
	char data[];
};

static void perf_event_read(print_fn fn)
{
	__u64 data_tail = header->data_tail;
	__u64 data_head = header->data_head;
	__u64 buffer_size = page_cnt * page_size;
	void *base, *begin, *end;
	char buf[256];

	asm volatile("" ::: "memory"); /* in real code it should be smp_rmb() */
	if (data_head == data_tail)
		return;

	base = ((char *)header) + page_size;

	begin = base + data_tail % buffer_size;
	end = base + data_head % buffer_size;

	while (begin != end) {
		struct perf_event_sample *e;

		e = begin;
		if (begin + e->header.size > base + buffer_size) {
			long len = base + buffer_size - begin;

			assert(len < e->header.size);
			memcpy(buf, begin, len);
			memcpy(buf + len, base, e->header.size - len);
			e = (void *) buf;
			begin = base + e->header.size - len;
		} else if (begin + e->header.size == base + buffer_size) {
			begin = base;
		} else {
			begin += e->header.size;
		}

		if (e->header.type == PERF_RECORD_SAMPLE) {
			fn(e->data, e->size);
		} else if (e->header.type == PERF_RECORD_LOST) {
			struct {
				struct perf_event_header header;
				__u64 id;
				__u64 lost;
			} *lost = (void *) e;
			printf("lost %lld events\n", lost->lost);
		} else {
			printf("unknown event type=%d size=%d\n",
			       e->header.type, e->header.size);
		}
	}

	__sync_synchronize(); /* smp_mb() */
	header->data_tail = data_head;
}

static void hex_dump(unsigned char *buf, int len)
{
        while (len--)
                printf("%02x", *buf++);
	printf("\n");
}

//TODO : à modifier
#define MAX_CNT 100000ll
static void print_bpf_output(void *data, int size)
{
	static __u64 cnt;
	struct {
		__u64 pid;
		__u64 cookie;
	} *e = data;

	printf("enter %s\n", __func__);
	hex_dump(data, 16);
	
/*
	if (e->cookie != 0x12345678) {
		printf("BUG pid %llx cookie %llx sized %d\n",
		       e->pid, e->cookie, size);
		kill(0, SIGINT);
	}
*/
	cnt++;

	if (cnt == MAX_CNT) {
		printf("recv %lld events per sec\n",
		       MAX_CNT * 1000000000ll / (time_get_ns() - start_time));
		kill(0, SIGINT);
	}
}

static void test_bpf_perf_event(void)
{
	struct perf_event_attr attr = {
		.sample_type = PERF_SAMPLE_RAW,
		.type = PERF_TYPE_SOFTWARE,
		.config = PERF_COUNT_SW_BPF_OUTPUT,
	};
	int key = 0;

	//perf_fd = sys_perf_event_open(&attr, -1/*pid*/, 0/*cpu*/, -1/*group_fd*/, 0);
	perf_fd = perf_event_open(&attr, -1/*pid*/, 0/*cpu*/, -1/*group_fd*/, 0);

	assert(perf_fd >= 0);
    /* if(perf_fd <= 0){
        fprintf(stderr,"ERR: sys_perf_event_open() failed\n");
        return 1;
    } */
	assert(bpf_map_update_elem(map_fd[0], &key, &perf_fd, BPF_ANY) == 0);
	ioctl(perf_fd, PERF_EVENT_IOC_ENABLE, 0);
}



struct vtlhdr{

	int value;
	//TODO: add other members according use cases
};

struct vtl_data {
    __u16 eth_proto;

};

static int print_vtl_packet(void *data, int size)
{
	//struct vtlhdr *vtlh = (struct  vtlhdr *)data;
	//struct iphdr *iph = (struct iphdr *)data;
	
	struct vtl_data *data_s = data;
	printf("iph->protocol: %d", data_s->eth_proto);
	
	return LIBBPF_PERF_EVENT_CONT;
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