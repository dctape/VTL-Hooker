
#include <assert.h>
#include <errno.h>
#include <getopt.h>
#include <locale.h>
#include <poll.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>

#include <sys/resource.h>

#include <bpf/bpf.h>
#include <bpf/xsk.h>
#include <bpf/libbpf.h> /* bpf_get_link_xdp_id + bpf_set_link_xdp_id */

#include <arpa/inet.h>
#include <net/if.h>
#include <linux/if_link.h>
#include <linux/if_ether.h>
//#include <linux/ip.h>
#include <linux/ipv6.h>
#include <linux/icmpv6.h>

#include <linux/err.h>

// #include "../../include/vtl/vtl.h"

// TODO: réduire le contenu des fichiers à inclure
#include "../../src/adaptor/adaptor_receive.h"
#include "../../src/common/xsk_user_helpers.h"
#include "../../src/common/xdp_user_helpers.h"

#define DATASIZE              1024 // ideal size ? 1024 ? 16k ?

#define XDP_FILENAME       		"../../src/bpf/bpf_xdp.o"
#define NIC_NAME		   	"ens33"

#ifndef PATH_MAX
#define PATH_MAX	4096
#endif
//TODO : comprendre la signification de ces define
#define RX_BATCH_SIZE      		64
#define ERRBUF_SIZE     256

typedef struct vtl_header vtlhdr_t;
struct vtlhdr
{
        uint16_t checksum;
};

static bool global_exit;
static int cnt_pkt;
static int cnt_bytes;

static void recv_image_file(uint8_t *data, int size)
{

	static FILE *rx_file = NULL;
	
	rx_file = fopen("lion.jpg", "ab");
	if (rx_file == NULL) {
		fprintf(stderr, "ERR: failed to open test file\n");
                exit(EXIT_FAILURE);
	}

	fwrite(data, 1, size, rx_file);
	fflush(rx_file);

	fclose(rx_file);

}

static bool process_packet(struct xsk_socket_info *xsk,
			   uint64_t addr, uint32_t len,
                           FILE *rx_file)
{	
	uint32_t hdr_size;
	uint32_t data_size;

	uint8_t *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
	
	struct ethhdr *eth = (struct ethhdr *) pkt;
	struct iphdr *iph = (struct iphdr *)(eth + 1);
	struct vtlhdr *vtlh = (struct vtlhdr *)(iph + 1);
	uint8_t *data = (uint8_t*)(vtlh + 1); 

	hdr_size = sizeof(struct ethhdr) + sizeof(struct iphdr) + sizeof(struct vtlhdr);
	data_size = len - hdr_size;

        fwrite(data, 1, data_size, rx_file);
	fflush(rx_file);

	cnt_pkt++;
	cnt_bytes += data_size;	
	return true;
}

static void handle_receive_packets(struct xsk_socket_info *xsk, FILE *rx_file)
{
		
	unsigned int rcvd, stock_frames, i;
	uint32_t idx_rx = 0, idx_fq = 0;
	int ret;

	rcvd = xsk_ring_cons__peek(&xsk->rx, RX_BATCH_SIZE, &idx_rx);
	if (!rcvd)
		return;

	/* Stuff the ring with as much frames as possible */
	stock_frames = xsk_prod_nb_free(&xsk->umem->fq,
					xsk_umem_free_frames(xsk));

	if (stock_frames > 0) {

		ret = xsk_ring_prod__reserve(&xsk->umem->fq, stock_frames,
					     &idx_fq);

		/* This should not happen, but just in case */
		while (ret != stock_frames)
			ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,
						     &idx_fq);

		for (i = 0; i < stock_frames; i++)
			*xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) =
				xsk_alloc_umem_frame(xsk);

		xsk_ring_prod__submit(&xsk->umem->fq, stock_frames);
	}

	/* Process received packets */
	for (i = 0; i < rcvd; i++) {
		uint64_t addr = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx)->addr;
		uint32_t len = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++)->len;

		if (!process_packet(xsk, addr, len, rx_file))
			xsk_free_umem_frame(xsk, addr);

		xsk->stats.rx_bytes += len; //TODO : Est-ce nécessaire ??
	}

	xsk_ring_cons__release(&xsk->rx, rcvd);
	xsk->stats.rx_packets += rcvd; //TODO : Est-ce nécessaire ??

	/* Do we need to wake up the kernel for transmission */
	//complete_tx(xsk); //TODO: Est-ce nécessaire ?

	
	
}

static void rx_and_process(struct xsk_socket_info *xsk_socket, FILE *rx_file)
{	
	// Pas trop bien compris...
	struct pollfd fds[2];
	int ret, nfds = 1;

	memset(fds, 0, sizeof(fds));
	fds[0].fd = xsk_socket__fd(xsk_socket->xsk);
	fds[0].events = POLLIN;

	cnt_pkt = 0;
	cnt_bytes = 0;
	printf("Start capture\n");
	bool xsk_poll_mode = true;
	
	if (xsk_poll_mode){
	
		ret = poll(fds, nfds, -1);
		if (ret <= 0 || ret > 1)
			return; 
		}
		
	handle_receive_packets(xsk_socket, rx_file);
	printf("Recv pkt: %d   Recv bytes: %d\r" 
		,cnt_pkt, cnt_bytes);
	fflush(stdout);
	printf("End capture\n");
}

static void exit_application(int signal)
{
	signal = signal;
	global_exit = true;
}

int main(int argc, char **argv)
{
    	
	char err_buf[ERRBUF_SIZE];

    	struct xdp_config cfg = {
		.filename = XDP_FILENAME,
		.progsec = "xdp_sock",
		.do_unload = false,
		.ifindex = if_nametoindex(NIC_NAME),
		.ifname = NIC_NAME // sert pas à grande chose de le préciser !!	
    	};

	if (cfg.ifindex == -1) {
		fprintf(stderr, "ERROR: Required option --dev missing\n\n");
		return EXIT_FAIL_OPTION;
	}

        if (cfg.filename[0] == 0)
        	return EXIT_FAIL;
	

	cfg.xdp_flags &= ~XDP_FLAGS_MODES;    /* Clear flags */
	cfg.xdp_flags |= XDP_FLAGS_SKB_MODE;  /* Set   flag */

	int xsk_bind_flags = 0;
	xsk_bind_flags &= XDP_ZEROCOPY;
	xsk_bind_flags |= XDP_COPY;

	int xsk_if_queue = 0;

    	struct xsk_umem_info *umem = NULL;
	struct xsk_socket_info *xsk_socket;


	/* Global shutdown handler */
	signal(SIGINT, exit_application);

	xsk_socket = adaptor_create_xsk_sock(cfg.ifname, cfg.xdp_flags, xsk_bind_flags, xsk_if_queue,
						umem, err_buf);
	if (xsk_socket == NULL) {
		/* code */
	}
	

	// FILE *debug_file = NULL;
	// debug_file = fopen("debug.txt", "a");
	// if (debug_file == NULL) {
	// 	fprintf(stderr, "ERR: failed to open debug file\n");
        //         exit(EXIT_FAILURE);
	// }
	FILE *rx_file = NULL;
	rx_file = fopen("lion.jpg", "ab");
	if (rx_file == NULL) {
		fprintf(stderr, "ERR: failed to open test file\n");
                exit(EXIT_FAILURE);
	}

	// printf("Start capture\n");
	bool xsk_poll_mode = false;
	int cnt_pkts = 0;
	int cnt_bytes_2 = 0;
	printf("Start capture\n");
	while(!global_exit) {
		
		//rx_and_process(xsk_socket, rx_file);
		adaptor_rcv_data(xsk_socket, xsk_poll_mode, rx_file,
				&cnt_pkts, &cnt_bytes_2);
		printf("Recv pkt: %d   Recv bytes: %d\r" 
		,cnt_pkts, cnt_bytes_2);
		fflush(stdout);

	}
	fclose(rx_file);
	//fclose(debug_file);
	//printf("%ld\n", rcv_data_s);
	printf("End capture\n");
	
	/* Cleanup */
	xsk_socket__delete(xsk_socket->xsk);
	//xsk_umem__delete(umem->umem);
	
	//xdp_link_detach(cfg.ifindex, cfg.xdp_flags, 0);

	return EXIT_OK;

}