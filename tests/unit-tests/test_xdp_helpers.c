#include <stdlib.h> // NULL
#include <stdio.h>

#include <linux/if_link.h>

#include "../../src/common/xdp_user_helpers.h"

#define BPF_XDP_FILENAME        "../../src/bpf/bpf_xdp.o"

void
test_xdp_attach_and_detach(char *filename, char *ifname, __u32 xdp_flags)
{
        struct bpf_object *bpf_obj;
        struct xdp_config cfg = {0};
        bool reuse_maps = false;
        bpf_obj = load_bpf_and_xdp_attach(&cfg, filename, ifname, xdp_flags, reuse_maps);
        if (bpf_obj == NULL) {
                printf("Test load_and_xdp_attach failed \n");
                printf("%s", cfg.err_buf);
                return;
        }

        printf("Test load_and_xdp_attach succeed!\n");

        int ret;
        ret = xdp_link_detach(cfg.ifindex, cfg.xdp_flags, 0);
        if (ret != 0) {
                printf("Test xdp_link_detach failed\n");
                return;
        }

        printf("Test xdp_link_detach succeed\n");

}

int main(int argc, char const *argv[])
{
        char ifname[] = "ens33";
        char bpf_file[] = BPF_XDP_FILENAME;
        __u32 xdp_flags;
        xdp_flags &= ~XDP_FLAGS_MODES;    /* Clear flags */
	xdp_flags |= XDP_FLAGS_SKB_MODE;  /* Set   flag */

        test_xdp_attach_and_detach(bpf_file, ifname, xdp_flags);

       
        return 0;
}
