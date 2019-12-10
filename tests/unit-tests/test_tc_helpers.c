
#include <stdio.h>
#include <stdlib.h>

#include <common/tc_user_helpers.h>

#include "test_tc_helpers.h"

#define BPF_TC_FILENAME        "../../bpf/bpf_tc.o"

void
test_tc_egress_attach(struct tc_config *cfg)
{
        int ret;
        ret = tc_egress_attach_bpf(cfg);
        if(ret == -1) {
                printf("Test failed \n");
                printf("%s", cfg->err_buf);
                return;
        }

        printf("Test tc_egress_attach succeed!\n");
}

void
test_tc_egress_remove(struct tc_config *cfg)
{
        int ret;
        ret = tc_remove_egress(cfg);
        if(ret == -1) {
                printf("Test failed \n");
                printf("%s", cfg->err_buf);
                return;
        }

        printf("Test tc_remove_egress succeed!\n");
}

int main(int argc, char const *argv[])
{
        struct tc_config cfg_s = {
                .filename = BPF_TC_FILENAME,
                .dev = "ens33"
        };

         struct tc_config cfg_i = {
                .filename = BPF_TC_FILENAME,
                .dev = "ens"
        };

        struct tc_config cfg_f = {
                .filename = "",
                .dev = "ens33"
        };

        fprintf(stderr, "Test tc_egress_attach():");
        test_tc_egress_attach(&cfg_s);
        printf("\n\n");

        // fprintf(stderr, "Test false interface:");
        // test_tc_egress_attach(&cfg_i);
        // fflush(stdout);
        // printf("\n\n");

        // fprintf(stderr, "Test false filename:");
        // test_tc_egress_attach(&cfg_f);
        // fflush(stdout);
        // printf("\n\n");

        fprintf(stderr, "Test tc_remove_egress()\n");
        test_tc_egress_remove(&cfg_s);


        return 0;
}
