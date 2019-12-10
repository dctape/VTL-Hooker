#include <stdio.h>
#include <stdlib.h>

#include <bpf/xsk.h> // For xsk_bind_flags
//TODO: use vtl/if_link.h ??
#include <linux/if_link.h> // For XDP_FLAGS_MODES

#include "../../adaptor/adaptor_receive.h"
#include "../../adaptor/adaptor_send.h"

#define VTL_ERRBUF_SIZE       256 



void test_open_xsk_sock(char *ifname)
{

       
        __u32 xdp_flags;
        xdp_flags = &= ~XDP_FLAGS_MODES;  /* Clear flags */
        xdp_flags |= XDP_FLAGS_SKB_MODE; /* Set   flag */

        __u16 xsk_bind_flags;
        xsk_bind_flags &= XDP_ZEROCOPY;
	xsk_bind_flags |= XDP_COPY;

        int xsk_if_queue = 0;

        char err_buf[VTL_ERRBUF_SIZE];

        struct xsk_socket_info *xsk_test;
        xsk_test = adaptor_create_xsk_sock(ifname, xdp_flags, xsk_bind_flags
                        xsk_if_queue, err_buf);
        if (xsk_test != NULL) {
                printf("test_open_xsk_sock succeed\n");
        }                
        else {
                printf("test_open_xsk_sock failed\n");
        }

}

int main(int argc, char const *argv[])
{
        char *ifname_1 = "ens33";
        char *ifname_2 = "unknown";

        test_open_xsk_sock(ifname_1);
        test_open_xsk_sock(ifname_2);

        return 0;
}
