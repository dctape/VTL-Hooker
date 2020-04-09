#include <errno.h>
#include <getopt.h>
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h> // strcpy
#include <signal.h>
#include <unistd.h>

#include <bpf/xsk.h> // For xsk_bind_flags
//TODO: use vtl/if_link.h ??
#include <linux/if_link.h> // For XDP_FLAGS_MODES
#include <netinet/ip.h>    // struct ip and IP_MAXPACKET (which is 65535)
#include <linux/if_ether.h>
#include <vtl.h>

#include <sys/resource.h>

#include "../../src/adaptor/adaptor.h"

#define BPF_XDP_FILENAME "../../src/bpf/bpf_xdp.o"

#define SRC_IP "192.168.130.157"
#define DST_IP "192.168.130.159"

void test_open_xsk_sock(char *filename, char *ifname, __u32 xdp_flags)
{

        // Attach xdp program
        struct bpf_object *bpf_obj;
        struct xdp_config cfg = {0};
        bool reuse_maps = false;
        bpf_obj = load_bpf_and_xdp_attach(&cfg, filename, ifname, xdp_flags, reuse_maps);
        if (bpf_obj == NULL)
        {
                printf("Test load_and_xdp_attach failed \n");
                printf("%s", cfg.err_buf);
                return;
        }
        printf("load_and_xdp_attach() succeed\n");

        // Open af_xdp socket
        // __u32 xdp_flags;
        // xdp_flags &= ~XDP_FLAGS_MODES;  /* Clear flags */
        // xdp_flags |= XDP_FLAGS_SKB_MODE; /* Set   flag */

        __u16 xsk_bind_flags = 0;
        xsk_bind_flags &= XDP_ZEROCOPY;
        xsk_bind_flags |= XDP_COPY;
        int xsk_if_queue = 0;

        struct xsk_umem_info umem = {0}; // always initialize!!!

        char err_buf[VTL_ERRBUF_SIZE];

        struct xsk_socket_info *xsk_socket;
        xsk_socket = adaptor__create_xsk_sock(ifname, xdp_flags, xsk_bind_flags,
                                              xsk_if_queue, &umem, err_buf);
        if (xsk_socket == NULL)
        {
                printf("test_open_xsk_sock failed :\n%s \n", err_buf);
                return;
        }
        printf("open_xsk_sock succeed\n");

        // Close af_xdp socket
        xsk_socket__delete(xsk_socket->xsk);
        xsk_umem__delete(umem.umem);
        printf("close af_xdp sock and clean up succeed\n");

        // Detach xdp program
        int ret;
        ret = xdp_link_detach(cfg.ifindex, cfg.xdp_flags, 0);
        if (ret != 0)
        {
                printf("Test xdp_link_detach failed\n");
                return;
        }
        printf("xdp_link_detach succeed\n\n");

        printf("Test open_xsk_sock succeed!\n\n");
}

void test_adaptor_send(char *interface, char *target, char *dst_ip, char *src_ip)
{
        int ret;
        int sock_fd;
        char err_buf[VTL_ERRBUF_SIZE];
        sock_fd = adaptor__create_raw_sock(AF_INET, IPPROTO_RAW, err_buf);
        if (sock_fd < 0)
        {
                printf("%s", err_buf);
                printf("adaptor_create_raw_sock() failed\n");
                return;
        }

        ret = adaptor__config_raw_sock(sock_fd, interface, err_buf);
        if (ret < 0)
        {
                printf("%s", err_buf);
                printf("adaptor_config_raw_sock() failed\n");
                return;
        }
        // Allocation
        uint8_t *snd_data = allocate_ustrmem(VTL_DATA_SIZE);
        uint8_t *snd_packet = allocate_ustrmem(IP_MAXPACKET);
        int *ip_flags = allocate_intmem(4);

        vtlhdr_t vtlh = {0};
        struct ip iphdr = {0};

        char str[] = "TEST";
        strcpy(snd_data, str);
        ret = adaptor__send_packet(sock_fd, snd_packet, &vtlh, &iphdr, target, dst_ip,
                                   src_ip, ip_flags, snd_data, VTL_DATA_SIZE, err_buf);

        if (ret != 0)
        {
                printf("%s", err_buf);
                printf("adaptor_send_packet() failed\n");
                return;
        }

        printf("Test adaptor_send succeed!\n");
}

static bool global_exit;
void test_adaptor_rcv(char *filename, char *ifname, __u32 xdp_flags,
                      struct vtl_recv_params *rp)
{
        //1. Charger programme eBPF
        struct bpf_object *bpf_obj;
        struct xdp_config cfg = {0};
        bool reuse_maps = false;
        bpf_obj = load_bpf_and_xdp_attach(&cfg, filename, ifname, xdp_flags, reuse_maps);
        if (bpf_obj == NULL)
        {
                printf("Test load_and_xdp_attach failed \n");
                printf("%s", cfg.err_buf);
                return;
        }
        printf("load_and_xdp_attach() succeed\n");

        //2. Ouvrir socket af_xdp
        __u16 xsk_bind_flags = 0;
        xsk_bind_flags &= XDP_ZEROCOPY;
        xsk_bind_flags |= XDP_COPY;
        int xsk_if_queue = 0;
        struct xsk_umem_info umem = {0};
        char err_buf[VTL_ERRBUF_SIZE];

        struct xsk_socket_info *xsk_socket;
        xsk_socket = adaptor__create_xsk_sock(ifname, xdp_flags, xsk_bind_flags,
                                              xsk_if_queue, &umem, err_buf);
        if (xsk_socket == NULL)
        {
                printf("test_open_xsk_sock failed :\n%s \n", err_buf);
                return;
        }
        printf("open_xsk_sock succeed\n");

        //3. En attente de réception de data
        bool xsk_poll_mode = false;
        while (!global_exit)
        {
                adaptor__rcv_data(xsk_socket, xsk_poll_mode, rp);
        }

        printf("adaptor_rcv data succeed\n");

        //4. Fermer socket af_xdp
        xsk_socket__delete(xsk_socket->xsk);
        xsk_umem__delete(umem.umem);
        printf("close af_xdp sock and clean up succeed\n");

        //5. Détacher programme XDP
        int ret;
        ret = xdp_link_detach(cfg.ifindex, cfg.xdp_flags, 0);
        if (ret != 0)
        {
                printf("Test xdp_link_detach failed\n");
                return;
        }
        printf("xdp_link_detach succeed\n\n");

        printf("Test adaptor_rcv succeed!\n\n");
}
static void exit_application(int signal)
{
        signal = signal;
        global_exit = true;
}

void fn_cb(void *ctx, uint8_t *data, uint32_t data_size)
{
        fprintf(stdout, "Data: %s\n", data);
}

/** Old adaptor **/
#define RX_BATCH_SIZE 64

struct xsk_socket_info *_adaptor_create_xsk_sock(char *ifname, __u32 xdp_flags,
                                                 __u16 xsk_bind_flags, int xsk_if_queue,
                                                 struct xsk_umem_info *umem, char *err_buf)
{

        void *packet_buffer;
        uint64_t packet_buffer_size;
        //struct xsk_umem_info *umem;
        struct xsk_socket_info *xsk_socket = NULL;
        struct rlimit rlim = {RLIM_INFINITY, RLIM_INFINITY};

        /*
	* Allow unlimited locking of memory, so all memory needed for packet
	* buffers can be locked.
	*/
        if (setrlimit(RLIMIT_MEMLOCK, &rlim))
        {
                snprintf(err_buf, VTL_ERRBUF_SIZE, "ERR: setrlimit(RLIMIT_MEMLOCK) \"%s\"\n",
                         strerror(errno));
                goto bad; // TODO: replace by return instruct
        }

        // Allocate memory for NUM_FRAMES of the default XDP frame size
        packet_buffer_size = NUM_FRAMES * FRAME_SIZE;

        if (posix_memalign(&packet_buffer, getpagesize(), packet_buffer_size))
        {
                snprintf(err_buf, VTL_ERRBUF_SIZE, "ERR: Can't allocate buffer memory \"%s\"\n",
                         strerror(errno));
                goto bad;
        }

        // Initialize shared packet_buffer for umem usage
        umem = configure_xsk_umem(packet_buffer, packet_buffer_size);
        if (umem == NULL)
        {
                snprintf(err_buf, VTL_ERRBUF_SIZE, "ERR: Can't create umem \"%s\"\n",
                         strerror(errno));
                goto bad;
        }

        // Open and configure the AF_XDP(xsk) socket
        xsk_socket = xsk_configure_socket(ifname, xdp_flags, xsk_bind_flags, xsk_if_queue, umem);
        if (xsk_socket == NULL)
        {
                snprintf(err_buf, VTL_ERRBUF_SIZE, "ERR: Can't setup AF_XDP socket \"%s\"\n",
                         strerror(errno));
                goto bad;
        }

        return xsk_socket;

        // Cleanup
bad:
        return NULL;
}

static bool _process_packet(struct xsk_socket_info *xsk,
                            uint64_t addr, uint32_t len, int *cnt)
{
        uint32_t hdr_size;
        uint32_t data_size;

        /* Parsing */
        uint8_t *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
        *cnt = *cnt + 1;
        // struct ethhdr *eth = (struct ethhdr *)pkt;
        // struct iphdr *iph = (struct iphdr *)(eth + 1);
        // vtlhdr_t *vtlh = (vtlhdr_t *)(iph + 1);
        // uint8_t *data = (uint8_t *)(vtlh + 1);

        // hdr_size = sizeof(struct ethhdr) + sizeof(struct iphdr) + sizeof(vtlhdr_t);
        // data_size = len - hdr_size;

        // printf("Cnt : %d Data in process_packet: %s\n",*cnt, data);
        printf("Cnt : %d\n", *cnt);
        fflush(stdout);
        return true;
}

static void _handle_receive_packets(struct xsk_socket_info *xsk, int *cnt)
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

        if (stock_frames > 0)
        {

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
        for (i = 0; i < rcvd; i++)
        {
                uint64_t addr = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx)->addr;
                uint32_t len = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++)->len;

                if (!_process_packet(xsk, addr, len, cnt))
                        xsk_free_umem_frame(xsk, addr);

                xsk->stats.rx_bytes += len;
        }

        xsk_ring_cons__release(&xsk->rx, rcvd);
        //xsk->stats.rx_packets += rcvd;

        /* Do we need to wake up the kernel for transmission */
        //complete_tx(xsk);
}

static void _adaptor__rcv_data(struct xsk_socket_info *xsk_socket,
                               bool xsk_poll_mode)
{
        struct pollfd fds[2];
        int ret, nfds = 1;
        int cnt = 0;

        memset(fds, 0, sizeof(fds));
        fds[0].fd = xsk_socket__fd(xsk_socket->xsk);
        fds[0].events = POLLIN;

        //while (!global_exit)

        if (xsk_poll_mode)
        {
                ret = poll(fds, nfds, -1);
                if (ret <= 0 || ret > 1)
                        return;
        }
        _handle_receive_packets(xsk_socket, &cnt);
}

void _test_adaptor_rcv(char *filename, char *ifname, __u32 xdp_flags,
                       FILE *rx_file, uint32_t *cnt_pkts, uint32_t *cnt_bytes)
{
        //1. Charger programme eBPF
        struct bpf_object *bpf_obj;
        struct xdp_config cfg = {0};
        bool reuse_maps = false;
        bpf_obj = load_bpf_and_xdp_attach(&cfg, filename, ifname, xdp_flags, reuse_maps);
        if (bpf_obj == NULL)
        {
                printf("Test load_and_xdp_attach failed \n");
                printf("%s", cfg.err_buf);
                return;
        }
        printf("load_and_xdp_attach() succeed\n");

        //2. Ouvrir socket af_xdp
        __u16 xsk_bind_flags = 0;
        xsk_bind_flags &= XDP_ZEROCOPY;
        xsk_bind_flags |= XDP_COPY;
        int xsk_if_queue = 0;
        struct xsk_umem_info umem = {0};
        char err_buf[VTL_ERRBUF_SIZE];

        struct xsk_socket_info *xsk_socket;
        xsk_socket = _adaptor_create_xsk_sock(ifname, xdp_flags, xsk_bind_flags,
                                              xsk_if_queue, &umem, err_buf);
        if (xsk_socket == NULL)
        {
                printf("test_open_xsk_sock failed :\n%s \n", err_buf);
                return;
        }
        printf("open_xsk_sock succeed\n");

        //3. En attente de réception de data
        bool xsk_poll_mode = false;
        while (!global_exit)
        {
                _adaptor__rcv_data(xsk_socket, xsk_poll_mode);
        }

        printf("adaptor_rcv data succeed\n");

        //4. Fermer socket af_xdp
        xsk_socket__delete(xsk_socket->xsk);
        xsk_umem__delete(umem.umem);
        printf("close af_xdp sock and clean up succeed\n");

        //5. Détacher programme XDP
        int ret;
        ret = xdp_link_detach(cfg.ifindex, cfg.xdp_flags, 0);
        if (ret != 0)
        {
                printf("Test xdp_link_detach failed\n");
                return;
        }
        printf("xdp_link_detach succeed\n\n");

        printf("Test adaptor_rcv succeed!\n\n");
}

int main(int argc, char const *argv[])
{
        char bpf_file[] = BPF_XDP_FILENAME;
        char ifname_1[] = "ens33";

        __u32 xdp_flags = 0;
        xdp_flags &= ~XDP_FLAGS_MODES;   /* Clear flags */
        xdp_flags |= XDP_FLAGS_SKB_MODE; /* Set   flag */
        //char *ifname_2 = "unknown";

        //test_open_xsk_sock(bpf_file, ifname_1, xdp_flags);
        //test_open_xsk_sock(ifname_2);

        // char target[] = DST_IP;
        // char dst_ip[] = DST_IP;
        // char src_ip[] = SRC_IP;

        // test_adaptor_send(ifname_1, target, dst_ip, src_ip);

        /* Global shutdown handler */
        // New API
        // signal(SIGINT, exit_application);
        // struct vtl_recv_params rp = {
        //     .recv_cb = fn_cb,
        // };
        // test_adaptor_rcv(bpf_file, ifname_1, xdp_flags, &rp);

        // Old API
        signal(SIGINT, exit_application);
        uint32_t cnt_pkts = 0;
        uint32_t cnt_bytes = 0;
        _test_adaptor_rcv(bpf_file, ifname_1, xdp_flags, stdout, &cnt_pkts, &cnt_bytes);

        return 0;
}
