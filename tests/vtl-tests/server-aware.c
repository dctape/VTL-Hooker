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
#define IP_SERVER          "192.168.43.153"

int main(int argc, char const *argv[])
{
        int err = 0;
        struct vtl_ctx *ctx = NULL;
        char *ifname = "ens33";       
        char err_buf[VTL_ERRBUF_SIZE];

        struct vtl_endpoint local, client;
        struct vtl_channel *ch;

        /* Initiate vtl context */
        printf("Initiate vtl context\n");
        ctx = vtl_init_ctx(VTL_USE_MODE_OUT, ifname, err_buf);
        if (!ctx) {
                fprintf(stderr, "vtl_init_ctx failed : %s\n", err_buf);
                err = -1;
                goto end;
        }

        /* Configure endpoint */
        printf("Configure endpoint\n");
        // vtl_add_ip4(&local, IP_SERVER);
        // vtl_add_ip4(&client, IP_CLIENT);

        vtl_add_ip4(&local, IP_CLIENT);
        vtl_add_ip4(&client, IP_SERVER);
        vtl_add_hostname(&client, IP_SERVER); //Important

        /* waiting request */
        printf("Waiting a channel request\n");
        ch = vtl_accept_channel(ctx, &local, &client, VTL_LOCAL_NOTFILL, err_buf);
        if (!ch) {
                fprintf(stderr, "vtl_open_channel failed : %s\n", err_buf);
                err = -1;
                goto destroy;
        }

        /* send data */
        printf("Sending data\n");
        uint8_t *data = "Hello, minimal Server";
        size_t datalen = strlen(data);
        err = vtl_send(ctx, ch, data, datalen, err_buf);
        if (err) {
                fprintf(stderr, "vtl_send failed : %s\n", err_buf);
                err = -1;
                goto destroy;
        }
        printf("Data sent :%s\nSize : %ld\n", data, datalen);

destroy :        
        /* Destroy vtl context after use */
        vtl_destroy_ctx(ctx);
end:
        return 0;
}
