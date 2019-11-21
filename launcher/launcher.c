#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <bpf/bpf.h>
#include <bpf/xsk.h>
#include <linux/if_link.h>

#include "../common/tc_user_helpers.h"
#include "../common/xdp_user_helpers.h"

#include "launcher.h"

//deploy tc tf
int
launcher_deploy_tc_tf(char *tf_file, char *interface, int flags)
{
        int ifindex = if_nametoindex(interface);    
        //TODO : change this part later... remove egress
        if (!(ifindex)) { 
                        fprintf(stderr,
                                "ERR: --egress \"%s\" not real dev\n",
                                        interface);
                        return EXIT_FAILURE;
        }

        struct tc_config cfg = {
                .filename = tf_file,
                .dev = interface
        };
        printf("Inject tc-bpf-file in the kernel...\n");
        printf("TC attach BPF object %s to device %s\n", cfg.filename, cfg.dev);

        switch (flags)
        {
                case TC_INGRESS:
                        //Fill in later...
                        return 0;
                        break;
                
                case TC_EGRESS:
                       //TODO: return code
                        if (tc_egress_attach_bpf(&cfg)) {
                                fprintf(stderr, "ERR: TC attach failed\n");
                                return EXIT_FAILURE;
                        }
                        break; 

                default:
                        fprintf(stderr, "ERR: launcher_deploy_tc_tf() failed, flags unknown!\n");
                        break;
        }

        return 0;
}

//remove tc tf
int
launcher_remove_tc_tf(char *tf_file, char *interface, int flags)
{       
        struct tc_config cfg = {
                .filename = tf_file,
                .dev = interface
        };

        /*  remove tc-bpf program */
        printf("TC remove tc-bpf program on device %s\n", cfg.dev);
        switch (flags)
        {
                case TC_INGRESS:
                        // Fill this later...                 
                        return 0;
                        break;
                
                case TC_EGRESS:
                        tc_remove_egress(&cfg);
                        break;
                
                default:
                        fprintf(stderr, "ERR: launcher_remove_tc_tf() failed, flags unknown!\n");
                        break;
                
                
        }

        return 0;
}


//deploy xdp tf
//TODO: test on tf_file
//TODO: test on interface
/** 
  * @desc: deploy transport functions on xdp hook
  * @param: struct xdp_config *cfg - configure xdp attachment
  * @param: char *tf_file - bpf file to load in kernel
  * @param: char *interface - NIC where to load tf        
  * @return: 
  * 
*/ 
int 
launcher_deploy_xdp_tf(struct xdp_config *cfg, char *tf_file, char *interface, int flags)
{       

        struct bpf_object *bpf_obj = NULL;

        if (tf_file[0] == 0)
                return EXIT_FAIL;
        //TODO: 2nd test on tf_file - verify that ebpf prog type is XDP

        //WARN: strcpy is not very safe, it's better to uses his self-made function
        strcpy(cfg->filename, tf_file);
        strcpy(cfg->progsec, "xdp_sock");
        
        //TODO: it seems not necessary
        cfg->do_unload = false;
        
        //TODO: redundant, find a better way...
        cfg->ifindex = if_nametoindex(interface);
        strcpy(cfg->ifname, interface);
        if (cfg->ifindex == -1) {
		fprintf(stderr, "ERROR: Required option --dev missing\n\n");
		return EXIT_FAIL_OPTION;
	}

        // XDP Flags
        cfg->xdp_flags = flags;

        bpf_obj = load_bpf_and_xdp_attach(&cfg);
	if (!bpf_obj) {
		/* Error handling done in load_bpf_and_xdp_attach() */
		exit(EXIT_FAILURE);
	}

        if (cfg->use_xsksock == true) {

                struct bpf_map *map = NULL;
                map = bpf_object__find_map_by_name(bpf_obj, "xsks_map");
                cfg->xsks_map_fd = bpf_map__fd(map);
                if (cfg->xsks_map_fd < 0) {
                        fprintf(stderr, "ERROR: no xsks map found: %s\n",
                                strerror(cfg->xsks_map_fd));
                        exit(EXIT_FAILURE);
	        }
        }

        return 0;
}


//remove xdp tf
/** 
  * @desc: remove transport functions on xdp hook
  * @param: struct xdp_config *cfg - configure xdp attachment
  * @param: char *tf_file - bpf file to remove on xdp hook
  * @param: char *interface - NIC where to remove xdp tf        
  * @return: 
  * 
*/
int
launcher_remove_xdp_tf(struct xdp_config *cfg, char *tf_file, char *interface)
{
         
        xdp_link_detach(cfg->ifindex, cfg->xdp_flags, 0);
        return 0;

}




