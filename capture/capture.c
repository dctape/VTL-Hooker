
/* 
 * Code pour la capture de données depuis XDP +
 * Transmission dans l'espace utilisateur  par
 * un socket AF_XDP 
 */

/* SPDX-License-Identifier: GPL-2.0 */

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

#include <arpa/inet.h>
#include <net/if.h>
#include <linux/if_link.h>
#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/ipv6.h>
#include <linux/icmpv6.h>


#include "../lib/vtl_util.h"

// TODO: réduire le contenu des fichiers à inclure
#include "../common/params.h"
#include "../common/util_libbpf.h"
#include "../common/tc_user_helpers.h"
#include "../common/xsk_user_helpers.h"



#define XDP_FILENAME       		"capture_kern.o"
#define NIC_NAME		   	"ens33"


//TODO : comprendre la signification de ces define
#define RX_BATCH_SIZE      		64


void DumpHex(const void* data, size_t size) {
	char ascii[17];
	size_t i, j;
	ascii[16] = '\0';
	for (i = 0; i < size; ++i) {
		printf("%02X ", ((unsigned char*)data)[i]);
		if (((unsigned char*)data)[i] >= ' ' && ((unsigned char*)data)[i] <= '~') {
			ascii[i % 16] = ((unsigned char*)data)[i];
		} else {
			ascii[i % 16] = '.';
		}
		if ((i+1) % 8 == 0 || i+1 == size) {
			printf(" ");
			if ((i+1) % 16 == 0) {
				printf("|  %s \n", ascii);
			} else if (i+1 == size) {
				ascii[(i+1) % 16] = '\0';
				if ((i+1) % 16 <= 8) {
					printf(" ");
				}
				for (j = (i+1) % 16; j < 16; ++j) {
					printf("   ");
				}
				printf("|  %s \n", ascii);
			}
		}
	}
}

/*
 * configure_xsk_umem() : Allocation et "création" du umem (userspace memory)
 * 
 */
// Fonction principale de traitement de paquet dans
// l'espace utilisateur
// Véritable fonction pour le traitement de paquets reçus sur af_xdp socket
static bool process_packet(struct xsk_socket_info *xsk,
			   uint64_t addr, uint32_t len)
{	
	/* Récupération des paquets "brut" */
	uint8_t *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
	
	/* Extraction paquet ipv4 */
	struct ethhdr *eth = (struct ethhdr *) pkt;
	struct iphdr *iph = (struct iphdr *)(eth + ETH_HLEN);

	//printf("iph->protocol : %d\n", iph->protocol);
	if(iph->protocol != IPPROTO_VTL){
		printf("ip_proto does not correspond...waiting next packet\n");
		return false;
	}
	printf("iph->protocol : %d\n", iph->protocol);

	__u8  iph_len = iph->ihl << 2;
	struct vtlhdr *vtlh = (struct vtlhdr *)(eth + ETH_HLEN + iph_len);
	char *data = (char *)(vtlh + 1); // Est-ce la bonne manière de procéder ?

	printf("vtl hdr -> checksum : %d\n", vtlh->checksum);
	DumpHex(data, sizeof(data));


	return true;

}

static void handle_receive_packets(struct xsk_socket_info *xsk)
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

		if (!process_packet(xsk, addr, len))
			xsk_free_umem_frame(xsk, addr);

		xsk->stats.rx_bytes += len; //TODO : Est-ce nécessaire ??
	}

	xsk_ring_cons__release(&xsk->rx, rcvd);
	xsk->stats.rx_packets += rcvd; //TODO : Est-ce nécessaire ??

	/* Do we need to wake up the kernel for transmission */
	//complete_tx(xsk); //TODO: Est-ce nécessaire ?
}

static void rx_and_process(struct xdp_config *cfg,
			   struct xsk_socket_info *xsk_socket)
{	
	// Pas trop bien compris...
	struct pollfd fds[2];
	int ret, nfds = 1;

	memset(fds, 0, sizeof(fds));
	fds[0].fd = xsk_socket__fd(xsk_socket->xsk);
	fds[0].events = POLLIN;

	while(1){
		if (cfg->xsk_poll_mode){
	
			ret = poll(fds, nfds, -1);
			if (ret <= 0 || ret > 1)
				continue; // return ???
		}
		
		handle_receive_packets(xsk_socket);
	}
	

}

int main(int argc, char **argv)
{
    	int ret;
    	//char *ifname = "veth-adv03";
	int xsks_map_fd;
	void *packet_buffer;
	uint64_t packet_buffer_size;

	struct rlimit rlim = {RLIM_INFINITY, RLIM_INFINITY};
    	struct xdp_config cfg = {
		.filename = XDP_FILENAME,
		.progsec = "xdp_sock",
		.do_unload = false,
		.ifindex = if_nametoindex(NIC_NAME),
		.ifname = NIC_NAME // sert pas à grande chose de le préciser !!	
    	};
	
	// Pour activer le mode skb...ens33 ne supporte pas le mode driver
	// TODO: adapter l'injection en fonction du mode
	cfg.xdp_flags &= ~XDP_FLAGS_MODES;    /* Clear flags */
	cfg.xdp_flags |= XDP_FLAGS_SKB_MODE;  /* Set   flag */
	cfg.xsk_bind_flags &= XDP_ZEROCOPY;
	cfg.xsk_bind_flags |= XDP_COPY;

    	struct xsk_umem_info *umem;
	struct xsk_socket_info *xsk_socket;
	struct bpf_object *bpf_obj = NULL;

        if (cfg.ifindex == -1) {
		fprintf(stderr, "ERROR: Required option --dev missing\n\n");
		return EXIT_FAIL_OPTION;
	}

        if (cfg.filename[0] == 0)
        	return EXIT_FAIL;
    
    	/* Chargement de programme XDP... */
    	struct bpf_map *map;

    	bpf_obj = load_bpf_and_xdp_attach(&cfg);
	if (!bpf_obj) {
		/* Error handling done in load_bpf_and_xdp_attach() */
		exit(EXIT_FAILURE);
	}

	/* We also need to load the xsks_map */
	map = bpf_object__find_map_by_name(bpf_obj, "xsks_map");
	xsks_map_fd = bpf_map__fd(map);
	if (xsks_map_fd < 0) {
		fprintf(stderr, "ERROR: no xsks map found: %s\n",
			strerror(xsks_map_fd));
		exit(EXIT_FAILURE);
	}

    	/* Code pour l'utilisation des af_xdp sockets */

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
	xsk_socket = xsk_configure_socket(&cfg, umem);
	if (xsk_socket == NULL) {

		fprintf(stderr, "ERROR: Can't setup AF_XDP socket \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}
    
	// Ai-je besoin d'un thread pour afficher les statistiques
	//Et quelle statistique ?
    	//Pas trop besoin pour le moment...

	/* Receive and count packets than drop them */
	rx_and_process(&cfg, xsk_socket);

	return 0;

}
