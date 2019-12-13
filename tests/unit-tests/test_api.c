#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "../../src/api/api.h"

#define SRC_IP                  "192.168.130.157"
#define DST_IP                  "192.168.130.159"

void
test_vtl(char *ifname, uint8_t *data, size_t datalen, char *target,
                 char *dst_ip, char *src_ip, int mode) 
{
        vtl_md_t *vtl_md;
        char err_buf[VTL_ERRBUF_SIZE];
        vtl_md = vtl_init(ifname, src_ip, mode, err_buf);
        if (vtl_md == NULL) {
                printf("%s", err_buf);
                printf("Test vtl_init failed\n");
                return;

        }
        printf("Test vtl_init succeed\n");
        int ret;
        ret = vtl_snd(vtl_md, target, dst_ip, data, datalen, err_buf);
        if (ret < 0) {
                printf("%s",err_buf);
                printf("Test vtl_snd failed\n");
                return;
        }
        printf("Test vtl_snd succeed\n");


}

int main(int argc, char const *argv[])
{
        char ifname[] = "ens33";
        char src_ip[] = SRC_IP;
        char dst_ip[] = DST_IP;
        char target[] = DST_IP;
        int mode = VTL_MODE_OUT;
        uint8_t data[] = "TEST";
        size_t datalen = strlen(data) + 1;
        test_vtl(ifname, data, datalen, target, dst_ip, src_ip, mode);

        return 0;
}
