
#include <errno.h>
#include <poll.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <unistd.h>

#include <bpf/xsk.h> // ajouter libbpf lors de la compilation
#include <bpf/libbpf.h> // perf_event functions

#include <sys/resource.h>

#include <net/if.h>
#include <linux/if_ether.h>
#include <linux/if_link.h>

//WARN: Rentre en conflit avec netinet/ip.h
//#include <linux/ip.h>

#include "../../include/vtl.h"
#include "../../src/common/xsk_user_helpers.h"
#include "adaptor.h"

#define RX_BATCH_SIZE      		64

void *alloc(size_t size)  /* extern ??*/
{
  void *new_mem;
  if((new_mem = malloc(size)) == NULL)
  {
    printf("Out of memory!\n");
    //exit(1);
     return NULL;
  }
  return new_mem;
}

#define MALLOC(type,num) (type *)alloc((num) * sizeof(type))

struct xsk_socket_info *
adaptor__create_xsk_sock(char *ifname, __u32 xdp_flags, __u16 xsk_bind_flags,
			int xsk_if_queue, struct xsk_umem_info *umem, char *err_buf)
{
      void *packet_buffer;
      uint64_t packet_buffer_size;
      //struct xsk_umem_info *umem;

      struct xsk_socket_info *xsk_socket = NULL;

      struct rlimit rlim = {RLIM_INFINITY, RLIM_INFINITY};

      /* Allow unlimited locking of memory, so all memory needed for packet
	 * buffers can be locked.
	 */
	if (setrlimit(RLIMIT_MEMLOCK, &rlim)) {
		snprintf(err_buf, VTL_ERRBUF_SIZE, "ERROR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
				strerror(errno));
		goto bad;
	}

        /* Allocate memory for NUM_FRAMES of the default XDP frame size */
	// getpagesize: obtenir des pages mémoires du système
	packet_buffer_size = NUM_FRAMES * FRAME_SIZE;

        if (posix_memalign(&packet_buffer,
			   getpagesize(), /* PAGE_SIZE aligned */
			   packet_buffer_size)) {
		snprintf(err_buf, VTL_ERRBUF_SIZE, "ERROR: Can't allocate buffer memory \"%s\"\n",
				strerror(errno));
		goto bad;
	}

        /* Initialize shared packet_buffer for umem usage */
	umem = configure_xsk_umem(packet_buffer, packet_buffer_size);
	if (umem == NULL) {

		snprintf(err_buf, VTL_ERRBUF_SIZE, "ERROR: Can't create umem \"%s\"\n",
				strerror(errno));
		goto bad;
	}

        /* Open and configure the AF_XDP (xsk) socket */
	xsk_socket = xsk_configure_socket(ifname, xdp_flags, xsk_bind_flags, xsk_if_queue, umem);
	if (xsk_socket == NULL) {

		snprintf(err_buf, VTL_ERRBUF_SIZE, "ERROR: Can't setup AF_XDP socket \"%s\"\n",
				strerror(errno));
		goto bad;
	}

        return xsk_socket;

	/* Cleanup */
bad:
	//TODO:
	// xsk_socket__delete(xsk_socket->xsk); // xsk_socket__delete => bpf/xsk
	// xsk_umem__delete(umem->umem); // xsk_umem__delete => bpf/xsk
	return NULL;
}

static bool 
process_packet(struct xsk_socket_info *xsk, 
		uint64_t addr, uint32_t len, 
		struct vtl_recv_params *rp)
{	
	uint32_t hdr_size;
	uint32_t data_size;

	/* Parsing */
	uint8_t *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);	
	struct ethhdr *eth = (struct ethhdr *) pkt;
	struct iphdr *iph = (struct iphdr *)(eth + 1);
	vtlhdr_t *vtlh = (vtlhdr_t *)(iph + 1);
	uint8_t *data = (uint8_t*)(vtlh + 1); 

	hdr_size = sizeof(struct ethhdr) + sizeof(struct iphdr) + sizeof(vtlhdr_t);
	data_size = len - hdr_size;

	/* Call callback function */	
	if (rp->recv_cb)
		rp->recv_cb(rp->ctx, data, data_size);

	return true;
}

//TODO: Improve this
static void 
handle_receive_packets(struct xsk_socket_info *xsk, 
			struct vtl_recv_params *rp)
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

		if (!process_packet(xsk, addr, len, rp))
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
adaptor__rcv_data(struct xsk_socket_info *xsk_socket, bool xsk_poll_mode,
		struct vtl_recv_params *rp)
{	
	// Pas trop bien compris...
	struct pollfd fds[2];
	int ret, nfds = 1;

	memset(fds, 0, sizeof(fds));
	fds[0].fd = xsk_socket__fd(xsk_socket->xsk);
	fds[0].events = POLLIN;

	//TODO: revenir sur le xsk_poll_mode
	if (xsk_poll_mode){
	
		ret = poll(fds, nfds, -1);
		if (ret <= 0 || ret > 1)
			return; 
	}
		
	handle_receive_packets(xsk_socket, rp);
	
}

/****** reception through perf_event buffer *******/

// #define SAMPLE_SIZE	1530

// // Enfiler
// static void 
// enqueue(struct perf_rcv_data_list *list, struct perf_rcv_data *frag)
// {
// 	if( list->first == NULL &&  list->last == NULL) {
// 		list->first = frag;
// 		list->last = frag;
// 	}
// 	else {
// 		list->last->next = frag;
// 		list->last = frag;
// 	}
// 	list->len = list->len + 1;

// }

// // défiler
// static struct perf_rcv_data *
// dequeue(struct perf_rcv_data_list *list) 
// {
// 	struct perf_rcv_data *frag;
// 	frag = list->first;
// 	list->first = list->first->next;
// 	list->len = list->len - 1;

// 	if (list->len == 0)
// 	list->last = NULL;
// 	return frag;
// }

// // perf_event callback function
// static void 
// handle_perf_recv_pkts(void *ctx, int cpu, void *data, __u32 size)
// {
// 	vtl_md_t *vtl_md = (vtl_md_t *)ctx;
// 	struct perf_rcv_data *rcv_data; 
// 	struct {
// 		__u16 cookie;
// 		__u16 pkt_len;
// 		__u8  pkt_data[SAMPLE_SIZE];
// 	} *e = data; // __packed

// 	uint16_t hdr_size;
// 	uint16_t data_size;

// 	if (e->cookie != 0xdead) {
// 		printf("BUG cookie %x sized %d\n", e->cookie, size);
// 		return;
// 	}

// 	struct ethhdr *eth = (struct ethhdr *)e->pkt_data;
//         struct iphdr *iph = (struct iphdr *)(eth + 1);
// 	vtlhdr_t *vtlh = (vtlhdr_t *)(iph + 1);
// 	hdr_size = sizeof(struct ethhdr) + sizeof(struct iphdr) 
// 			+ sizeof(vtlhdr_t);
// 	data_size = e->pkt_len - hdr_size;

// 	rcv_data->data = (uint8_t*)(vtlh + 1);
// 	rcv_data->data_len = data_size;

// 	enqueue(vtl_md->rcv_data_list, rcv_data);
// 	sem_post(&vtl_md->rcv_sem);

// 	/** stats **/
// 	vtl_md->cnt_pkts = vtl_md->cnt_pkts + 1;
// 	vtl_md->cnt_bytes += data_size;

// }

// // thread function
// // TODO: Est-ce possible d'avoir de meilleurs codes d'erreur
// static void * 
// thread_function (void *args)
// {
// 	int err, ret;
// 	struct perf_buffer_opts pb_opts = {0};
// 	vtl_md_t *vtl_md = (vtl_md_t *)args; 

// 	pb_opts.sample_cb = handle_perf_recv_pkts;
// 	pb_opts.ctx = vtl_md;

// 	vtl_md->pb = perf_buffer__new(vtl_md->perf_map_fd, 8, &pb_opts); // Pourquoi 8 ?	
// 	err = libbpf_get_error(vtl_md->pb);
// 	if (err) {
// 		perror("perf_buffer setup failed");
// 		return NULL;
// 	}

// 	while ((ret = perf_buffer__poll(vtl_md->pb, 1000)) >= 0) {
// 	}

// 	return NULL;

// }

// int 
// adaptor__listen_thread(vtl_md_t *vtl_md)
// {
// 	int ret;
// 	ret = pthread_create(&vtl_md->rcv_thread, NULL, thread_function, 
// 			(void *)vtl_md);
// 	if (ret != 0) {
// 		perror("ERR: thread creation failed");
// 		return -1;
// 	}

// 	return 0;
// }

// int
// adaptor__stop_listen_thread(vtl_md_t *vtl_md)
// {
// 	int ret;
// 	ret = pthread_cancel(vtl_md->rcv_thread);
// 	if (ret != 0) {
// 		perror("ERR: thread cancel failed");
// 		return -1;
// 	}

// 	return 0;
// }

// ssize_t
// adaptor__rcv_perf_data(sem_t *sem, struct perf_rcv_data_list *rcv_list,
// 			uint8_t *data)
// {
// 	struct perf_rcv_data *rcv_data;
// 	sem_wait(sem);
// 	rcv_data = dequeue(rcv_list);

// 	data = rcv_data->data;
// 	return rcv_data->data_len;
// }

// struct perf_rcv_data_list *
// adaptor__init_rlist(void)
// {
// 	struct perf_rcv_data_list *list = NULL;
// 	list = MALLOC(struct perf_rcv_data_list, 1);
// 	memset(list, 0, sizeof(struct perf_rcv_data_list));
// 	return list;

// }