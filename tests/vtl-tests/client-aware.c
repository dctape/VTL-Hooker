/**
 * 
 * Client vtl-aware
 * 
 **/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <vtl.h>

#define IP_CLIENT          "192.168.43.151"
#define IP_SERVER          "192.168.43.152"

void 
print_data(void *ctx, uint8_t *data, uint32_t data_size)
{
        printf("From server: %s", data);

}

int main(int argc, char const *argv[])
{
        int err;
        struct vtl_ctx *ctx = NULL;
        char *ifname = "ens33";       
        char err_buf[VTL_ERRBUF_SIZE];

        struct vtl_endpoint local, server;
        struct vtl_channel *ch;

        /* Initiate vtl context */
        ctx = vtl_init_ctx(VTL_USE_MODE_INOUT, ifname, err_buf);
        if (!ctx) {
                fprintf(stderr, "vtl_init_ctx failed : %s\n", err_buf);
                return -1;
        }

        /* Configure endpoint */
        vtl_add_ip4(&local, IP_CLIENT);
        vtl_add_ip4(&server, IP_SERVER);

        /* Request a channel */
        ch = vtl_open_channel(ctx, &local, &server, VTL_LOCAL_NOTFILL, err_buf);
        if (!ch) {
                fprintf(stderr, "vtl_open_channel failed : %s\n", err_buf);
                goto close;
        }
            
        /* Receive data */
        struct vtl_recv_params rp = {
                .recv_cb = print_data,
        };
        vtl_receive(ctx, &rp);

close :        
        /* Destroy vtl context after use */
        vtl_destroy_ctx(ctx);


        return 0;
}
