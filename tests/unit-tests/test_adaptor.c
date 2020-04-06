#include <stdio.h>
#include <stdlib.h>
#include <string.h> // strcpy

#include <bpf/xsk.h> // For xsk_bind_flags
//TODO: use vtl/if_link.h ??
#include <linux/if_link.h> // For XDP_FLAGS_MODES
#include <netinet/ip.h>       // struct ip and IP_MAXPACKET (which is 65535)
#include <vtl.h>

#include "../../src/adaptor/adaptor.h"


#define BPF_XDP_FILENAME        "../../src/bpf/bpf_xdp.o"

#define SRC_IP                    "192.168.130.157"
#define DST_IP                    "192.168.130.159"


void test_open_xsk_sock(char *filename, char *ifname, __u32 xdp_flags)
{

        // Attach xdp program
        struct bpf_object *bpf_obj;
        struct xdp_config cfg = {0};
        bool reuse_maps = false;
        bpf_obj = load_bpf_and_xdp_attach(&cfg, filename, ifname, xdp_flags, reuse_maps);
        if (bpf_obj == NULL) {
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
        if (xsk_socket == NULL) {
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
        if (ret != 0) {
                printf("Test xdp_link_detach failed\n");
                return;
        }
        printf("xdp_link_detach succeed\n\n");

        printf("Test open_xsk_sock succeed!\n\n");
}

void
test_adaptor_send(char* interface, char *target, char *dst_ip, char *src_ip)
{
        int ret;
        int sock_fd;
        char err_buf[VTL_ERRBUF_SIZE];
        sock_fd = adaptor__create_raw_sock(AF_INET, IPPROTO_RAW, err_buf);
        if (sock_fd < 0) {
                printf("%s", err_buf);
                printf("adaptor_create_raw_sock() failed\n");
                return;
        }

        ret = adaptor__config_raw_sock(sock_fd, interface, err_buf);
        if (ret < 0) {
                printf("%s", err_buf);
                printf("adaptor_config_raw_sock() failed\n");
                return;
        }
        // Allocation
        uint8_t *snd_data = allocate_ustrmem(VTL_DATA_SIZE);
        uint8_t *snd_packet = allocate_ustrmem (IP_MAXPACKET);
        int *ip_flags = allocate_intmem(4);

        vtlhdr_t vtlh = {0};
        struct ip iphdr = {0};


        char str[] = "TEST";
        strcpy(snd_data, str);
        ret = adaptor__send_packet(sock_fd, snd_packet, &vtlh, &iphdr,target, dst_ip, 
                                src_ip, ip_flags, snd_data, VTL_DATA_SIZE, err_buf);
        
        if (ret != 0) {
                printf("%s", err_buf);
                printf("adaptor_send_packet() failed\n");
                return;
        }

        printf("Test adaptor_send succeed!\n");

}

int main(int argc, char const *argv[])
{
        char bpf_file[] = BPF_XDP_FILENAME;
        char ifname_1[] = "ens33";

        __u32 xdp_flags = 0;
        xdp_flags &= ~XDP_FLAGS_MODES;    /* Clear flags */
	xdp_flags |= XDP_FLAGS_SKB_MODE;  /* Set   flag */
        //char *ifname_2 = "unknown";

        test_open_xsk_sock(bpf_file, ifname_1, xdp_flags);
        //test_open_xsk_sock(ifname_2);

        // char target[] = DST_IP;
        // char dst_ip[] = DST_IP;
        // char src_ip[] = SRC_IP;

        // test_adaptor_send(ifname_1, target, dst_ip, src_ip);

        return 0;
}
