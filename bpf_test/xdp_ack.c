#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <linux/perf_event.h> // location : usr
#include <linux/bpf.h>

#include <assert.h> // pas vraiment besoin
#include <signal.h>
#include <sys/ioctl.h>
#include <sys/resource.h> // rlimit
#include <unistd.h>

#include <bpf/libbpf.h> // bpf_set_link_xdp_fd
#include <bpf/bpf.h>  // bpf_obj_get_info_by_fd

#include <net/if.h>
#include <linux/if_ether.h> // struct ethhdr
#include <linux/if_link.h> // stuct iphdr
#include <linux/ip.h>
#include <libgen.h> // basename

#include "perf-sys.h"

#define BPF_XDP_FILENAME        "./bpf/xdp_ack_kern.o"

#define MAX_CPUS 128
static int if_idx;
static char *if_name;
static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
static __u32 prog_id;
static struct perf_buffer *pb = NULL; // location : libbpf.c

static int do_attach(int idx, int fd, const char *name)
{
	struct bpf_prog_info info = {0}; // location linux/bpf.h
	__u32 info_len = sizeof(info);
	int err;

	err = bpf_set_link_xdp_fd(idx, fd, xdp_flags);
	if (err < 0) {
		printf("ERROR: failed to attach program to %s\n", name);
		return err;
	}

	err = bpf_obj_get_info_by_fd(fd, &info, &info_len);
	if (err) {
		printf("can't get prog info - %s\n", strerror(errno));
		return err;
	}
	prog_id = info.id;

	return err;
}

static int do_detach(int idx, const char *name)
{
	__u32 curr_prog_id = 0;
	int err = 0;

	err = bpf_get_link_xdp_id(idx, &curr_prog_id, 0);
	if (err) {
		printf("bpf_get_link_xdp_id failed\n");
		return err;
	}
	if (prog_id == curr_prog_id) {
		err = bpf_set_link_xdp_fd(idx, -1, 0);
		if (err < 0)
			printf("ERROR: failed to detach prog from %s\n", name);
	} else if (!curr_prog_id) {
		printf("couldn't find a prog id on a %s\n", name);
	} else {
		printf("program on interface changed, not removing\n");
	}

	return err;
}

#define SAMPLE_SIZE 1530



static void print_bpf_output(void *ctx, int cpu, void *data, __u32 size, 
                                int try)
{
	struct {
		__u16 cookie;
		__u16 pkt_len;
		__u8  pkt_data[SAMPLE_SIZE];
                //__u8  *pkt_data;
	} *e = data; // __packed
	int i;

	if (e->cookie != 0xdead) {
		printf("BUG cookie %x sized %d\n", e->cookie, size);
		return;
	}
        /* parsing */

        struct ethhdr *eth = (struct ethhdr *)e->pkt_data;
        struct iphdr *iph = (struct iphdr *)(eth + 1);

        printf ("Pkt len: %-5d bytes - IP protocol : %d", e->pkt_len, 
                iph->protocol);
        

	// printf("Pkt len: %-5d bytes. Ethernet hdr: ", e->pkt_len);
	// for (i = 0; i < 14 && i < e->pkt_len; i++)
	// 	printf("%02x ", e->pkt_data[i]);
        //hex_dump(e->pkt_data, 16);
	printf("\n");
}

static void sig_handler(int signo)
{
	do_detach(if_idx, if_name);
	perf_buffer__free(pb);
	exit(0);
}


int main(int argc, char **argv)
{
        struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
	struct bpf_prog_load_attr prog_load_attr = {
		.prog_type	= BPF_PROG_TYPE_XDP,
	};
	struct perf_buffer_opts pb_opts = {0};
	int prog_fd, map_fd;
	struct bpf_object *obj;
	struct bpf_map *map;
	int ret, err;

        char *ifname = "ens33";
        xdp_flags &= ~XDP_FLAGS_UPDATE_IF_NOEXIST;

	if (setrlimit(RLIMIT_MEMLOCK, &r)) {
		perror("setrlimit(RLIMIT_MEMLOCK)");
		return 1;
	}

        prog_load_attr.file = BPF_XDP_FILENAME;

        if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
		return 1;

	if (!prog_fd) {
		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
		return 1;
	}

	map = bpf_map__next(NULL, obj);
	if (!map) {
		printf("finding a map in obj file failed\n");
		return 1;
	}
	map_fd = bpf_map__fd(map);

        if_idx = if_nametoindex(ifname);
	if (!if_idx)
		if_idx = strtoul(ifname, NULL, 0);

	if (!if_idx) {
		fprintf(stderr, "Invalid ifname\n");
		return 1;
	}
	err = do_attach(if_idx, prog_fd, if_name);
	if (err)
		return err;

	if (signal(SIGINT, sig_handler) ||
	    signal(SIGHUP, sig_handler) ||
	    signal(SIGTERM, sig_handler)) {
		perror("signal");
		return 1;
	}

        pb_opts.sample_cb = print_bpf_output;
	pb = perf_buffer__new(map_fd, 8, &pb_opts);
	err = libbpf_get_error(pb);
	if (err) {
		perror("perf_buffer setup failed");
		return 1;
	}

        while ((ret = perf_buffer__poll(pb, 1000)) >= 0) {
	}

	kill(0, SIGINT);
	return ret;
}


// static void hex_dump(unsigned char *buf, int len)
// {
//         while (len--)
//                 printf("%02x", *buf++);
// 	printf("\n");
// }

// static void usage(const char *prog)
// {
// 	fprintf(stderr,
// 		"%s: %s [OPTS] <ifname|ifindex>\n\n"
// 		"OPTS:\n"
// 		"    -F    force loading prog\n",
// 		__func__, prog);
// }