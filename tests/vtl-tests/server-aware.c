/**
 * 
 * Serveur vtl-aware
 * 
 **/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <vtl.h>

#define IP_CLIENT          "192.168.43.151"
#define IP_SERVER          "192.168.43.152"

int main(int argc, char const *argv[])
{
        int err;
        struct vtl_ctx *ctx = NULL;
        char *ifname = "ens33";       
        char err_buf[VTL_ERRBUF_SIZE];

        struct vtl_endpoint local, client;
        struct vtl_channel *ch;

        /* Initiate vtl context */
        ctx = vtl_init_ctx(VTL_USE_MODE_INOUT, ifname, err_buf);
        if (!ctx) {
                fprintf(stderr, "vtl_init_ctx failed : %s\n", err_buf);
                return -1;
        }

        /* Configure endpoint */
        vtl_add_ip4(&local, IP_SERVER);
        vtl_add_ip4(&client, IP_CLIENT);

        /* waiting request */
        ch = vtl_accept_channel(ctx, &local, &client, VTL_LOCAL_NOTFILL, err_buf);
        if (!ch) {
                fprintf(stderr, "vtl_open_channel failed : %s\n", err_buf);
                goto close;
        }

        /* send data */
        uint8_t *data = "Hello, minimal Server";
        size_t datalen = strlen(data);
        err = vtl_send(ctx, ch, data, datalen, err_buf);
        if (err) {
                fprintf(stderr, "vtl_send failed : %s\n", err_buf);
                return -1; //goto close channel
        }

close :        
        /* Destroy vtl context after use */
        vtl_destroy_ctx(ctx);

        return 0;
}
