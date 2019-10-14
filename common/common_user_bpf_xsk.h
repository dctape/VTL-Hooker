#ifndef __COMMON_USER_BPF_XSK_H
#define __COMMON_USER_BPF_XSK_H

#include <bpf/xsk.h>
// Faire attention
#include "common_defines.h"
#include "common_user_bpf_xdp.h" //TODO: change later

#define NUM_FRAMES         4096
#define FRAME_SIZE         XSK_UMEM__DEFAULT_FRAME_SIZE
#define INVALID_UMEM_FRAME UINT64_MAX

struct xsk_umem_info {
	struct xsk_ring_prod fq;
	struct xsk_ring_cons cq;
	struct xsk_umem *umem;
	void *buffer;
};


// Pas trop nécessaire ici
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

	struct stats_record stats;
	struct stats_record prev_stats;
};

struct xsk_umem_info *configure_xsk_umem(void *buffer, uint64_t size);
uint64_t xsk_alloc_umem_frame(struct xsk_socket_info *xsk);
void xsk_free_umem_frame(struct xsk_socket_info *xsk, uint64_t frame);
uint64_t xsk_umem_free_frames(struct xsk_socket_info *xsk);
struct xsk_socket_info *xsk_configure_socket(struct xdp_config *xdp_cfg,
						    struct xsk_umem_info *umem);


#endif  /*__COMMON_USER_BPF_XSK_H */