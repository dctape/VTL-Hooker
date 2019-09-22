/* 
 * Code pour la capture de données depuis XDP +
 * Transmission dans l'espace utilisateur  par
 * un socket AF_XDP 
 */

#include <assert.h>
#include <errno.h>
#include <poll.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/resource.h>

//TODO: remplacer par des chemins relatifs
//#include <bpf/bpf.h>
#include "../../libbpf/src/bpf.h"
//#include <bpf/xsk.h>
#include "../../libbpf/src/xsk.h"

#include <arpa/inet.h>
#include <net/if.h> //TODO: revoir l'utilité de ces include
//TODO : Fix it
//#include <linux/if_link.h>
#include "../../libbpf/include/uapi/linux/if_link.h"
#include <linux/if_ether.h>

//TODO : Considérer que ce qui est important
#include "../../common/common_params.h"
#include "../../common/common_user_bpf_xdp.h"
#include "../../common/common_libbpf.h"


#define XDP_FILENAME       "capture_kern.o"

//TODO : comprendre la signification de ces define
#define NUM_FRAMES         4096
#define FRAME_SIZE         XSK_UMEM__DEFAULT_FRAME_SIZE
#define RX_BATCH_SIZE      64
#define INVALID_UMEM_FRAME UINT64_MAX

struct xsk_umem_info {
	struct xsk_ring_prod fq;
	struct xsk_ring_cons cq;
	struct xsk_umem *umem;
	void *buffer;
};

//Pas trop nécessaire
struct stats_record {
	uint64_t timestamp;
	uint64_t rx_packets;
	uint64_t rx_bytes;
	uint64_t tx_packets;
	uint64_t tx_bytes;
};

struct xsk_socket_info {
	struct xsk_ring_cons rx;
	struct xsk_ring_prod tx;
	struct xsk_umem_info *umem;
	struct xsk_socket *xsk;

	uint64_t umem_frame_addr[NUM_FRAMES];
	uint32_t umem_frame_free;

	uint32_t outstanding_tx;

	struct stats_record stats; // TODO: Est-ce nécessaire ?
	struct stats_record prev_stats; // TODO: Est-ce nécessaire ?
};

/*
 * Allocation et "création" du umem (userspace memory)
 * 
 */
static struct xsk_umem_info *configure_xsk_umem(void *buffer, uint64_t size)
{
	struct xsk_umem_info *umem;
	int ret;

	umem = calloc(1, sizeof(*umem));
	if (!umem)
		return NULL;

	ret = xsk_umem__create(&umem->umem, buffer, size, &umem->fq, &umem->cq,
			       NULL);
	if (ret) {
		errno = -ret;
		return NULL;
	}

	umem->buffer = buffer;
	return umem;
}

static uint64_t xsk_alloc_umem_frame(struct xsk_socket_info *xsk)
{
	uint64_t frame;
	if (xsk->umem_frame_free == 0)
		return INVALID_UMEM_FRAME;

	frame = xsk->umem_frame_addr[--xsk->umem_frame_free];
	xsk->umem_frame_addr[xsk->umem_frame_free] = INVALID_UMEM_FRAME;
	return frame;
}

//TODO: à modifier...
static struct xsk_socket_info *xsk_configure_socket(struct config *cfg,
						    struct xsk_umem_info *umem)
{
	struct xsk_socket_config xsk_cfg;
	struct xsk_socket_info *xsk_info;
	uint32_t idx;
	uint32_t prog_id = 0;
	int i;
	int ret;

	xsk_info = calloc(1, sizeof(*xsk_info));
	if (!xsk_info)
		return NULL;

	xsk_info->umem = umem;
	xsk_cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
	xsk_cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
	xsk_cfg.libbpf_flags = 0;
	xsk_cfg.xdp_flags = cfg->xdp_flags;
	xsk_cfg.bind_flags = cfg->xsk_bind_flags;
	ret = xsk_socket__create(&xsk_info->xsk, cfg->ifname,
				 cfg->xsk_if_queue, umem->umem, &xsk_info->rx,
				 &xsk_info->tx, &xsk_cfg);

	if (ret)
		goto error_exit;

	//TODO: A revoir...
	ret = bpf_get_link_xdp_id(cfg->ifindex, &prog_id, cfg->xdp_flags);
	if (ret)
		goto error_exit;

	/* Initialize umem frame allocation */

	for (i = 0; i < NUM_FRAMES; i++)
		xsk_info->umem_frame_addr[i] = i * FRAME_SIZE;

	xsk_info->umem_frame_free = NUM_FRAMES;

	/* Stuff the receive path with buffers, we assume we have enough */
	ret = xsk_ring_prod__reserve(&xsk_info->umem->fq,
				     XSK_RING_PROD__DEFAULT_NUM_DESCS,
				     &idx);

	if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
		goto error_exit;

	for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i ++)
		*xsk_ring_prod__fill_addr(&xsk_info->umem->fq, idx++) =
			xsk_alloc_umem_frame(xsk_info);

	xsk_ring_prod__submit(&xsk_info->umem->fq,
			      XSK_RING_PROD__DEFAULT_NUM_DESCS);

	return xsk_info;

error_exit:
	errno = -ret;
	return NULL;
}

static void xsk_free_umem_frame(struct xsk_socket_info *xsk, uint64_t frame)
{
	assert(xsk->umem_frame_free < NUM_FRAMES);

	xsk->umem_frame_addr[xsk->umem_frame_free++] = frame;
}

static uint64_t xsk_umem_free_frames(struct xsk_socket_info *xsk)
{
	return xsk->umem_frame_free;
}

// Fonction principale de traitement de paquet dans
// l'espace utilisateur
// Véritable fonction pour le traitement de paquets reçus sur af_xdp socket
static bool process_packet(struct xsk_socket_info *xsk,
			   uint64_t addr, uint32_t len)
{	
	// récupération des paquets
	uint8_t *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);

     /* Récupération des paquets à partir de XDP
	  * Affichage des informations du paquets ou le process de libvnf
	  * 
	  * 
	  * 
	  */   
	
	struct ethhdr *eth = (struct ethhdr *) pkt;
	printf("Eth Hdr:\n");
	printf (
	   "   |-Destination Address : %.2X-%.2X-%.2X-%.2X-%.2X-%.2X \n",
	   eth->h_dest[0], eth->h_dest[1], eth->h_dest[2], eth->h_dest[3],
	   eth->h_dest[4], eth->h_dest[5]);

	return true;

	/*if (false) {
		int ret;
		uint32_t tx_idx = 0;
		uint8_t tmp_mac[ETH_ALEN];
		struct in6_addr tmp_ip;
		struct ethhdr *eth = (struct ethhdr *) pkt;
		struct ipv6hdr *ipv6 = (struct ipv6hdr *) (eth + 1);
		struct icmp6hdr *icmp = (struct icmp6hdr *) (ipv6 + 1);

		if (ntohs(eth->h_proto) != ETH_P_IPV6 ||
		    len < (sizeof(*eth) + sizeof(*ipv6) + sizeof(*icmp)) ||
		    ipv6->nexthdr != IPPROTO_ICMPV6 ||
		    icmp->icmp6_type != ICMPV6_ECHO_REQUEST)
			return false;

		memcpy(tmp_mac, eth->h_dest, ETH_ALEN);
		memcpy(eth->h_dest, eth->h_source, ETH_ALEN);
		memcpy(eth->h_source, tmp_mac, ETH_ALEN);

		memcpy(&tmp_ip, &ipv6->saddr, sizeof(tmp_ip));
		memcpy(&ipv6->saddr, &ipv6->daddr, sizeof(tmp_ip));
		memcpy(&ipv6->daddr, &tmp_ip, sizeof(tmp_ip));

		icmp->icmp6_type = ICMPV6_ECHO_REPLY;

		csum_replace2(&icmp->icmp6_cksum,
			      htons(ICMPV6_ECHO_REQUEST << 8),
			      htons(ICMPV6_ECHO_REPLY << 8));

		/* Here we sent the packet out of the receive port. Note that
		 * we allocate one entry and schedule it. Your design would be
		 * faster if you do batch processing/transmission */

		/*ret = xsk_ring_prod__reserve(&xsk->tx, 1, &tx_idx);
		if (ret != 1) {
			/* No more transmit slots, drop the packet */
		//	return false;
		//}

		/*xsk_ring_prod__tx_desc(&xsk->tx, tx_idx)->addr = addr;
		xsk_ring_prod__tx_desc(&xsk->tx, tx_idx)->len = len;
		xsk_ring_prod__submit(&xsk->tx, 1);
		xsk->outstanding_tx++;

		xsk->stats.tx_bytes += len;
		xsk->stats.tx_packets++;
		return true;
	}

	return false;*/

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

static void rx_and_process(struct config *cfg,
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
    char *ifname = "veth-adv03";
	void *packet_buffer;
	uint64_t packet_buffer_size;
	struct rlimit rlim = {RLIM_INFINITY, RLIM_INFINITY};
    struct config cfg = {
        .ifindex = if_nametoindex(ifname),
        .ifname = ifname,
        .do_unload = false,
		.filename = XDP_FILENAME,
		.progsec = "xdp_sock"
    };

    struct xsk_umem_info *umem;
	struct xsk_socket_info *xsk_socket;

    int xsks_map_fd;
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
