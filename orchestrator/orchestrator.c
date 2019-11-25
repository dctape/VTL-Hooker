
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#include "../launcher/launcher.h"

#define BPF_TC_FILENAME "../bpf/bpf_tc.c"

int main()
{
        int ret;
        int sec = 6;

        // ajoute une tf au niveau de tc
        printf("Program start\n");

        printf("Deploy TF on TC\n");
        char *interface = "ens33";
        struct tc_config tc_cfg;
        ret = launcher_deploy_tc_tf(&tc_cfg, BPF_TC_FILENAME, interface, 
                                        TC_EGRESS_ATTACH);


        // fait un sleep de 6 sec
        printf("Sleep for %d sec\n", sec);
        sleep(sec);

        // retire la tf
        printf("Remove TF on TC\n");
        ret = launcher_remove_tc_tf(&tc_cfg, TC_EGRESS_ATTACH);


        // Sort du programme



        return 0;
}