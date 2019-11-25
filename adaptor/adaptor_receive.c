
#include <errno.h>
#include <poll.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

#include <sys/resource.h>

#include <net/if.h>
#include <linux/if_ether.h>
#include <linux/if_link.h>

//WARN: Rentre en conflit avec netinet/ip.h
//#include <linux/ip.h>

#include "../include/vtl/vtl_macros.h"
#include "../include/vtl/vtl_structures.h"

#include "../common/xsk_user_helpers.h"

#include "adaptor_receive.h"

#define RX_BATCH_SIZE      		64

int
adaptor_config_and_open_xsk_sock(vtl_md_t *vtl_md)
{
      void *packet_buffer;
      uint64_t packet_buffer_size;
      struct xsk_umem_info *umem;

      struct rlimit rlim = {RLIM_INFINITY, RLIM_INFINITY};

      /* Allow unlimited locking of memory, so all memory needed for packet
	 * buffers can be locked.
	 */
	if (setrlimit(RLIMIT_MEMLOCK, &rlim)) {
		fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}

        /* Allocate memory for NUM_FRAMES of the default XDP frame size */
	// getpagesize: obtenir des pages mémoires du système
	packet_buffer_size = NUM_FRAMES * FRAME_SIZE;

        if (posix_memalign(&packet_buffer,
			   getpagesize(), /* PAGE_SIZE aligned */
			   packet_buffer_size)) {
		fprintf(stderr, "ERROR: Can't allocate buffer memory \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}

        /* Initialize shared packet_buffer for umem usage */
	umem = configure_xsk_umem(packet_buffer, packet_buffer_size);
	if (umem == NULL) {

		fprintf(stderr, "ERROR: Can't create umem \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}

        /* Open and configure the AF_XDP (xsk) socket */
	vtl_md->xsk_socket = xsk_configure_socket(vtl_md->xdp_cfg, umem);
	if (vtl_md->xsk_socket == NULL) {

		fprintf(stderr, "ERROR: Can't setup AF_XDP socket \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}

        return 0;
}

static bool 
process_packet(struct xsk_socket_info *xsk, uint64_t addr, 
                uint32_t len, uint8_t *rcv_data, size_t *rcv_datalen)
{	
	int hdr_size;
	int data_size;

	uint8_t *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
	
	struct ethhdr *eth = (struct ethhdr *) pkt;
	struct iphdr *iph = (struct iphdr *)(eth + 1);
	vtlhdr_t *vtlh = (vtlhdr_t *)(iph + 1);
	uint8_t *data = (uint8_t*)(vtlh + 1); 

	hdr_size = sizeof(struct ethhdr) + sizeof(struct iphdr) + sizeof(vtlhdr_t);
	data_size = len - hdr_size;	
	
        //TODO: Make a linked list or a ring buffer ???
	//rcv_data = data;
	//WARN: strcpy...
	//strcpy(rcv_data, data);
	memcpy(rcv_data, data, data_size);
        *rcv_datalen = data_size;
	
	return true;
}

//TODO: Improve this
static void 
handle_receive_packets(struct xsk_socket_info *xsk, uint8_t *rcv_data, size_t *rcv_datalen)
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
		//warning: comparison between signed and unsigned integer expressions
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

		if (!process_packet(xsk, addr, len, rcv_data, rcv_datalen))
			xsk_free_umem_frame(xsk, addr);

		//xsk->stats.rx_bytes += len; //TODO : Est-ce nécessaire ??
	}

	xsk_ring_cons__release(&xsk->rx, rcvd);
	//xsk->stats.rx_packets += rcvd; //TODO : Est-ce nécessaire ??

	/* Do we need to wake up the kernel for transmission */
	//complete_tx(xsk); //TODO: Est-ce nécessaire ?
}

//TODO: Revoir le code de retour
void 
adaptor_rcv_data(vtl_md_t *vtl_md)
{	
	// Pas trop bien compris...
	struct pollfd fds[2];
	int ret, nfds = 1;

	memset(fds, 0, sizeof(fds));
	fds[0].fd = xsk_socket__fd(vtl_md->xsk_socket->xsk);
	fds[0].events = POLLIN;

	//TODO: revenir sur le xsk_poll_mode
	if (vtl_md->xsk_poll_mode){
	
		ret = poll(fds, nfds, -1);
		if (ret <= 0 || ret > 1)
			return; 
	}
		
	handle_receive_packets(vtl_md->xsk_socket, vtl_md->rcv_data, &vtl_md->rcv_datalen);
	
}

