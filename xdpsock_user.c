
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <errno.h>
#include <linux/bpf.h>
#include <linux/if_link.h>

#include <sys/socket.h>
#include <sys/resource.h>
#include <sys/mman.h>

#include "./bpf/bpf_load.h"
#include "./bpf/libbpf.h"
#include "./bpf/if_xdp.h" //TODO : ajouter au Makefile

#ifndef SOL_XDP
#define SOL_XDP 283
#endif

#ifndef AF_XDP
#define AF_XDP 44
#endif

#ifndef PF_XDP
#define PF_XDP AF_XDP
#endif

#define NUM_FRAMES 131072
#define FRAME_HEADROOM 0
#define FRAME_SHIFT 11
#define FRAME_SIZE 2048
#define NUM_DESCS 1024
#define BATCH_SIZE 16

#define FQ_NUM_DESCS 1024
#define CQ_NUM_DESCS 1024

#define DEBUG_HEXDUMP 0

#define XDP_BPF_FILE    "xdpsock_kern.o"

#define lassert(expr)							\
	do {								\
		if (!(expr)) {						\
			fprintf(stderr, "%s:%s:%i: Assertion failed: "	\
				#expr ": errno: %d/\"%s\"\n",		\
				__FILE__, __func__, __LINE__,		\
				errno, strerror(errno));		\
			dump_stats();					\
			exit(EXIT_FAILURE);				\
		}							\
	} while (0)

typedef __u64 u64;
typedef __u32 u32;

//Pas trop pertinent
enum benchmark_type {
	BENCH_RXDROP = 0,
	BENCH_TXONLY = 1,
	BENCH_L2FWD = 2,
};

static enum benchmark_type opt_bench = BENCH_RXDROP;
static u32 opt_xdp_flags;
static const char *opt_if = "";
static int opt_ifindex;
static int opt_queue;
static int opt_poll;
static int opt_shared_packet_buffer;
static int opt_interval = 1;
static u32 opt_xdp_bind_flags;



/* déclaration de structures */

struct xdp_umem_uqueue {
	u32 cached_prod;
	u32 cached_cons;
	u32 mask;
	u32 size;
	u32 *producer;
	u32 *consumer;
	u64 *ring;
	void *map;
};

struct xdp_umem {
	char *frames;
	struct xdp_umem_uqueue fq;
	struct xdp_umem_uqueue cq;
	int fd;
};

struct xdp_uqueue {
	u32 cached_prod;
	u32 cached_cons;
	u32 mask;
	u32 size;
	u32 *producer;
	u32 *consumer;
	struct xdp_desc *ring;
	void *map;
};

struct xdpsock {
	struct xdp_uqueue rx;
	struct xdp_uqueue tx;
	int sfd;
	struct xdp_umem *umem;
	u32 outstanding_tx;
	unsigned long rx_npkts;
	unsigned long tx_npkts;
	unsigned long prev_rx_npkts;
	unsigned long prev_tx_npkts;
};

/* Fonctions pour la configuration unem ?? */
static inline u32 umem_nb_free(struct xdp_umem_uqueue *q, u32 nb)
{
	u32 free_entries = q->cached_cons - q->cached_prod;

	if (free_entries >= nb)
		return free_entries;

	/* Refresh the local tail pointer */
	q->cached_cons = *q->consumer + q->size;

	return q->cached_cons - q->cached_prod;
}

static inline u32 xq_nb_free(struct xdp_uqueue *q, u32 ndescs)
{
	u32 free_entries = q->cached_cons - q->cached_prod;

	if (free_entries >= ndescs)
		return free_entries;

	/* Refresh the local tail pointer */
	q->cached_cons = *q->consumer + q->size;
	return q->cached_cons - q->cached_prod;
}

static inline u32 umem_nb_avail(struct xdp_umem_uqueue *q, u32 nb)
{
	u32 entries = q->cached_prod - q->cached_cons;

	if (entries == 0) {
		q->cached_prod = *q->producer;
		entries = q->cached_prod - q->cached_cons;
	}

	return (entries > nb) ? nb : entries;
}

static inline u32 xq_nb_avail(struct xdp_uqueue *q, u32 ndescs)
{
	u32 entries = q->cached_prod - q->cached_cons;

	if (entries == 0) {
		q->cached_prod = *q->producer;
		entries = q->cached_prod - q->cached_cons;
	}

	return (entries > ndescs) ? ndescs : entries;
}

static inline int umem_fill_to_kernel_ex(struct xdp_umem_uqueue *fq,
					 struct xdp_desc *d,
					 size_t nb)
{
	u32 i;

	if (umem_nb_free(fq, nb) < nb)
		return -ENOSPC;

	for (i = 0; i < nb; i++) {
		u32 idx = fq->cached_prod++ & fq->mask;

		fq->ring[idx] = d[i].addr;
	}

	u_smp_wmb();

	*fq->producer = fq->cached_prod;

	return 0;
}

static inline int umem_fill_to_kernel(struct xdp_umem_uqueue *fq, u64 *d,
				      size_t nb)
{
	u32 i;

	if (umem_nb_free(fq, nb) < nb)
		return -ENOSPC;

	for (i = 0; i < nb; i++) {
		u32 idx = fq->cached_prod++ & fq->mask;

		fq->ring[idx] = d[i];
	}

	u_smp_wmb();

	*fq->producer = fq->cached_prod;

	return 0;
}

static inline size_t umem_complete_from_kernel(struct xdp_umem_uqueue *cq,
					       u64 *d, size_t nb)
{
	u32 idx, i, entries = umem_nb_avail(cq, nb);

	u_smp_rmb();

	for (i = 0; i < entries; i++) {
		idx = cq->cached_cons++ & cq->mask;
		d[i] = cq->ring[idx];
	}

	if (entries > 0) {
		u_smp_wmb();

		*cq->consumer = cq->cached_cons;
	}

	return entries;
}

/* Fonctions récupération et émission de données */

static inline void *xq_get_data(struct xdpsock *xsk, u64 addr)
{
	return &xsk->umem->frames[addr];
}

static inline int xq_enq(struct xdp_uqueue *uq,
			 const struct xdp_desc *descs,
			 unsigned int ndescs)
{
	struct xdp_desc *r = uq->ring;
	unsigned int i;

	if (xq_nb_free(uq, ndescs) < ndescs)
		return -ENOSPC;

	for (i = 0; i < ndescs; i++) {
		u32 idx = uq->cached_prod++ & uq->mask;

		r[idx].addr = descs[i].addr;
		r[idx].len = descs[i].len;
	}

	u_smp_wmb();

	*uq->producer = uq->cached_prod;
	return 0;
}

/* static inline int xq_enq_tx_only(struct xdp_uqueue *uq,
				 unsigned int id, unsigned int ndescs)
{
	struct xdp_desc *r = uq->ring;
	unsigned int i;

	if (xq_nb_free(uq, ndescs) < ndescs)
		return -ENOSPC;

	for (i = 0; i < ndescs; i++) {
		u32 idx = uq->cached_prod++ & uq->mask;

		r[idx].addr	= (id + i) << FRAME_SHIFT;
		r[idx].len	= sizeof(pkt_data) - 1;
	}

	u_smp_wmb();

	*uq->producer = uq->cached_prod;
	return 0;
}
*/

static inline int xq_deq(struct xdp_uqueue *uq,
			 struct xdp_desc *descs,
			 int ndescs)
{
	struct xdp_desc *r = uq->ring;
	unsigned int idx;
	int i, entries;

	entries = xq_nb_avail(uq, ndescs);

	u_smp_rmb();

	for (i = 0; i < entries; i++) {
		idx = uq->cached_cons++ & uq->mask;
		descs[i] = r[idx];
	}

	if (entries > 0) {
		u_smp_wmb();

		*uq->consumer = uq->cached_cons;
	}

	return entries;
}

/* génère la trame ethernet, pas trop utile dans mon cas */
/* static size_t gen_eth_frame(char *frame)
{
	memcpy(frame, pkt_data, sizeof(pkt_data) - 1);
	return sizeof(pkt_data) - 1;
}
*/

/* pour l'affichage des paquets */
static void hex_dump(void *pkt, size_t length, u64 addr)
{
	const unsigned char *address = (unsigned char *)pkt;
	const unsigned char *line = address;
	size_t line_size = 32;
	unsigned char c;
	char buf[32];
	int i = 0;

	if (!DEBUG_HEXDUMP)
		return;

	sprintf(buf, "addr=%llu", addr);
	printf("length = %zu\n", length);
	printf("%s | ", buf);
	while (length-- > 0) {
		printf("%02X ", *address++);
		if (!(++i % line_size) || (length == 0 && i % line_size)) {
			if (length == 0) {
				while (i++ % line_size)
					printf("__ ");
			}
			printf(" | ");	/* right close */
			while (line < address) {
				c = *line++;
				printf("%c", (c < 33 || c == 255) ? 0x2E : c);
			}
			printf("\n");
			if (length > 0)
				printf("%s | ", buf);
		}
	}
	printf("\n");
}

/* configuration de unem ?? : à revoir! */
static struct xdp_umem *xdp_umem_configure(int sfd)
{
	int fq_size = FQ_NUM_DESCS, cq_size = CQ_NUM_DESCS;
	struct xdp_mmap_offsets off;
	struct xdp_umem_reg mr;
	struct xdp_umem *umem;
	socklen_t optlen;
	void *bufs;

	umem = calloc(1, sizeof(*umem));
	lassert(umem);

	lassert(posix_memalign(&bufs, getpagesize(), /* PAGE_SIZE aligned */
			       NUM_FRAMES * FRAME_SIZE) == 0);

	mr.addr = (__u64)bufs;
	mr.len = NUM_FRAMES * FRAME_SIZE;
	mr.chunk_size = FRAME_SIZE;
	mr.headroom = FRAME_HEADROOM;

	lassert(setsockopt(sfd, SOL_XDP, XDP_UMEM_REG, &mr, sizeof(mr)) == 0);
	lassert(setsockopt(sfd, SOL_XDP, XDP_UMEM_FILL_RING, &fq_size,
			   sizeof(int)) == 0);
	lassert(setsockopt(sfd, SOL_XDP, XDP_UMEM_COMPLETION_RING, &cq_size,
			   sizeof(int)) == 0);

	optlen = sizeof(off);
	lassert(getsockopt(sfd, SOL_XDP, XDP_MMAP_OFFSETS, &off,
			   &optlen) == 0);

	umem->fq.map = mmap(0, off.fr.desc +
			    FQ_NUM_DESCS * sizeof(u64),
			    PROT_READ | PROT_WRITE,
			    MAP_SHARED | MAP_POPULATE, sfd,
			    XDP_UMEM_PGOFF_FILL_RING);
	lassert(umem->fq.map != MAP_FAILED);

	umem->fq.mask = FQ_NUM_DESCS - 1;
	umem->fq.size = FQ_NUM_DESCS;
	umem->fq.producer = umem->fq.map + off.fr.producer;
	umem->fq.consumer = umem->fq.map + off.fr.consumer;
	umem->fq.ring = umem->fq.map + off.fr.desc;
	umem->fq.cached_cons = FQ_NUM_DESCS;

	umem->cq.map = mmap(0, off.cr.desc +
			     CQ_NUM_DESCS * sizeof(u64),
			     PROT_READ | PROT_WRITE,
			     MAP_SHARED | MAP_POPULATE, sfd,
			     XDP_UMEM_PGOFF_COMPLETION_RING);
	lassert(umem->cq.map != MAP_FAILED);

	umem->cq.mask = CQ_NUM_DESCS - 1;
	umem->cq.size = CQ_NUM_DESCS;
	umem->cq.producer = umem->cq.map + off.cr.producer;
	umem->cq.consumer = umem->cq.map + off.cr.consumer;
	umem->cq.ring = umem->cq.map + off.cr.desc;

	umem->frames = bufs;
	umem->fd = sfd;

	if (opt_bench == BENCH_TXONLY) {
		int i;

		for (i = 0; i < NUM_FRAMES * FRAME_SIZE; i += FRAME_SIZE)
			(void)gen_eth_frame(&umem->frames[i]);
	}

	return umem;
}

/* création et configuration de xsk */
static struct xdpsock *xsk_configure(struct xdp_unem *umem)
{
    struct sockaddr_xdp sxdp = {};
	struct xdp_mmap_offsets off;
	int sfd, ndescs = NUM_DESCS;
	struct xdpsock *xsk;
	bool shared = true;
	socklen_t optlen;
	u64 i;

    sfd = socket(PF_XDP, SOCK_RAW, 0); // création la socket xsk

    xsk = calloc(1, sizeof(*xsk));
	lassert(xsk);

    xsk->sfd = sfd;
	xsk->outstanding_tx = 0;

    if (!umem) {
		shared = false;
		xsk->umem = xdp_umem_configure(sfd);
	} else {
		xsk->umem = umem;
	}

    lassert(setsockopt(sfd, SOL_XDP, XDP_RX_RING,
			   &ndescs, sizeof(int)) == 0);
	lassert(setsockopt(sfd, SOL_XDP, XDP_TX_RING,
			   &ndescs, sizeof(int)) == 0);
	optlen = sizeof(off);
	lassert(getsockopt(sfd, SOL_XDP, XDP_MMAP_OFFSETS, &off,
			   &optlen) == 0);

    /* Rx */
	xsk->rx.map = mmap(NULL,
			   off.rx.desc +
			   NUM_DESCS * sizeof(struct xdp_desc),
			   PROT_READ | PROT_WRITE,
			   MAP_SHARED | MAP_POPULATE, sfd,
			   XDP_PGOFF_RX_RING);
	lassert(xsk->rx.map != MAP_FAILED);

	if (!shared) {
		for (i = 0; i < NUM_DESCS * FRAME_SIZE; i += FRAME_SIZE)
			lassert(umem_fill_to_kernel(&xsk->umem->fq, &i, 1)
				== 0);
	}

	/* Tx */
	xsk->tx.map = mmap(NULL,
			   off.tx.desc +
			   NUM_DESCS * sizeof(struct xdp_desc),
			   PROT_READ | PROT_WRITE,
			   MAP_SHARED | MAP_POPULATE, sfd,
			   XDP_PGOFF_TX_RING);
	lassert(xsk->tx.map != MAP_FAILED);

	xsk->rx.mask = NUM_DESCS - 1;
	xsk->rx.size = NUM_DESCS;
	xsk->rx.producer = xsk->rx.map + off.rx.producer;
	xsk->rx.consumer = xsk->rx.map + off.rx.consumer;
	xsk->rx.ring = xsk->rx.map + off.rx.desc;

	xsk->tx.mask = NUM_DESCS - 1;
	xsk->tx.size = NUM_DESCS;
	xsk->tx.producer = xsk->tx.map + off.tx.producer;
	xsk->tx.consumer = xsk->tx.map + off.tx.consumer;
	xsk->tx.ring = xsk->tx.map + off.tx.desc;
	xsk->tx.cached_cons = NUM_DESCS;

	sxdp.sxdp_family = PF_XDP;
	sxdp.sxdp_ifindex = opt_ifindex;
	sxdp.sxdp_queue_id = opt_queue;

	if (shared) {
		sxdp.sxdp_flags = XDP_SHARED_UMEM;
		sxdp.sxdp_shared_umem_fd = umem->fd;
	} else {
		sxdp.sxdp_flags = opt_xdp_bind_flags;
	}

	lassert(bind(sfd, (struct sockaddr *)&sxdp, sizeof(sxdp)) == 0);

	return xsk;
        


}

/* Bizarre, ce n'est pas une fonction d'envoi, de réveil ?? */
static void kick_tx(int fd)
{
	int ret;

	ret = sendto(fd, NULL, 0, MSG_DONTWAIT, NULL, 0);
	if (ret >= 0 || errno == ENOBUFS || errno == EAGAIN || errno == EBUSY)
		return;
	lassert(0);
}

/* je ne vois pas trop ce que c'est ? */
// compléter la buffer tx  + L2 forwarding
static inline void complete_tx_l2fwd(struct xdpsock *xsk)
{
	u64 descs[BATCH_SIZE];
	unsigned int rcvd;
	size_t ndescs;

	if (!xsk->outstanding_tx)
		return;

	kick_tx(xsk->sfd);
	ndescs = (xsk->outstanding_tx > BATCH_SIZE) ? BATCH_SIZE :
		 xsk->outstanding_tx;

	/* re-add completed Tx buffers */
	rcvd = umem_complete_from_kernel(&xsk->umem->cq, descs, ndescs);
	if (rcvd > 0) {
		umem_fill_to_kernel(&xsk->umem->fq, descs, rcvd);
		xsk->outstanding_tx -= rcvd;
		xsk->tx_npkts += rcvd;
	}
}

/* compléter uniquement le buffer tx */
static inline void complete_tx_only(struct xdpsock *xsk)
{
	u64 descs[BATCH_SIZE];
	unsigned int rcvd;

	if (!xsk->outstanding_tx)
		return;

	kick_tx(xsk->sfd);

	rcvd = umem_complete_from_kernel(&xsk->umem->cq, descs, BATCH_SIZE);
	if (rcvd > 0) {
		xsk->outstanding_tx -= rcvd;
		xsk->tx_npkts += rcvd;
	}
}

/* drop en réception: peut être la fonction qui m'intéresse */
static void rx_drop(struct xdpsock *xsk)
{
	struct xdp_desc descs[BATCH_SIZE];
	unsigned int rcvd, i;

    // défiler
	rcvd = xq_deq(&xsk->rx, descs, BATCH_SIZE);
	if (!rcvd)
		return;

	for (i = 0; i < rcvd; i++) {
        // récupération des datas
		char *pkt = xq_get_data(xsk, descs[i].addr);

        /* dump : affichage */
		hex_dump(pkt, descs[i].len, descs[i].addr);
	}

    /* drop ??? */
	xsk->rx_npkts += rcvd;

	umem_fill_to_kernel_ex(&xsk->umem->fq, descs, rcvd);
}

/* Drop sur tous les buffers RX des xsks */
static void rx_drop_all(void)
{
	struct pollfd fds[MAX_SOCKS + 1];
	int i, ret, timeout, nfds = 1;

	memset(fds, 0, sizeof(fds));

	for (i = 0; i < num_socks; i++) {
		fds[i].fd = xsks[i]->sfd;
		fds[i].events = POLLIN;
		timeout = 1000; /* 1sn */
	}

	for (;;) {
		if (opt_poll) {
			ret = poll(fds, nfds, timeout);
			if (ret <= 0)
				continue;
		}

		for (i = 0; i < num_socks; i++)
			rx_drop(xsks[i]);
	}
}

/* buffer tx only ??? */
static void tx_only(struct xdpsock *xsk)
{
	int timeout, ret, nfds = 1;
	struct pollfd fds[nfds + 1];
	unsigned int idx = 0;

	memset(fds, 0, sizeof(fds));
	fds[0].fd = xsk->sfd;
	fds[0].events = POLLOUT;
	timeout = 1000; /* 1sn */

	for (;;) {
		if (opt_poll) {
			ret = poll(fds, nfds, timeout);
			if (ret <= 0)
				continue;

			if (fds[0].fd != xsk->sfd ||
			    !(fds[0].revents & POLLOUT))
				continue;
		}

		if (xq_nb_free(&xsk->tx, BATCH_SIZE) >= BATCH_SIZE) {
			lassert(xq_enq_tx_only(&xsk->tx, idx, BATCH_SIZE) == 0);

			xsk->outstanding_tx += BATCH_SIZE;
			idx += BATCH_SIZE;
			idx %= NUM_FRAMES;
		}

		complete_tx_only(xsk);
	}
}

/*  */
static void l2fwd(struct xdpsock *xsk)
{
	for (;;) {
		struct xdp_desc descs[BATCH_SIZE];
		unsigned int rcvd, i;
		int ret;

		for (;;) {
            /* une sorte de transmission de paquet */
			complete_tx_l2fwd(xsk);

            /* reception du descripteur sur le buffer rx */
            // défiler...
			rcvd = xq_deq(&xsk->rx, descs, BATCH_SIZE);
			if (rcvd > 0)
				break;
		}

		for (i = 0; i < rcvd; i++) {
            // récupération des datas
			char *pkt = xq_get_data(xsk, descs[i].addr);

            // echanger les adresses niveau L2
			swap_mac_addresses(pkt);

            // dump hexadécimal
			hex_dump(pkt, descs[i].len, descs[i].addr);
		}

		xsk->rx_npkts += rcvd;

        // enfiler sur le buffer tx les trames
		ret = xq_enq(&xsk->tx, descs, rcvd);
		lassert(ret == 0);
		xsk->outstanding_tx += rcvd;
	}
}

int main(int argc, char **argv)
{
	int ret;

    /* Augmenter les limites de la mémoire */
    struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};

    if (setrlimit(RLIMIT_MEMLOCK, &r)) {
		fprintf(stderr, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
			strerror(errno));
		exit(EXIT_FAILURE);
	}

    /* Injection du programme XDP */
    printf("XDP load BPF file in kernel\n");
	if(bpf_inject(XDP_BPF_FILE)){
		printf("ERROR - Loading xdp file");
		return 1;
	}

    /* création de la socket af_xdp */
    struct xdpsock *xsk;
    xsk = xsk_configure(NULL);

	/* ...l'insérer dans la xks map */
	int xsk_map = map_fd[0];
	int key = 0;
	ret = bpf_map_update_elem(xsk_map, &key, &xsk->sfd, 0); // pourquoi &xsks->sfd ?
	if (ret) {
			fprintf(stderr, "ERROR: bpf_map_update_elem \n");
			exit(EXIT_FAILURE);
	}

	/* attacher le programme XDP sur ens33 */
	static char *xdp_ifname = "ens33";
	int ifindex_xdp = if_nametoindex(xdp_ifname);

	printf("XDP attach BPF object to device %s\n",
			xdp_ifname);
    if (set_link_xdp_fd(ifindex_xdp, prog_fd[0], 0) < 0) {
		printf("link set xdp fd failed\n");
		return 1;
	}

	/* hex dump les différents paquets reçus sur la NIC */

	struct xdp_desc descs[BATCH_SIZE];
	unsigned int rcvd, i;

	for(;;) {

		rcvd = xq_deq(&xsk->rx, descs, BATCH_SIZE);
		if (!rcvd)
			return;
		
		for (i = 0; i < rcvd; i++) {
			char *pkt = xq_get_data(xsk, descs[i].addr);

			hex_dump(pkt, descs[i].len, descs[i].addr);
		}

		xsk->rx_npkts += rcvd; // pas trop sûr de cette ligne
		umem_fill_to_kernel_ex(&xsk->umem->fq, descs, rcvd);

	}

	/* détacher le programme XDP */
	//TODO: remplacer avec sigkill
	printf("XDP remove xdp-bpf program on device %s\n", xdp_ifname);
	set_link_xdp_fd(ifindex_xdp, -1, 0);
	



    return 0;
}
