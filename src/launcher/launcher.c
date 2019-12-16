#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <linux/if_link.h>

//TODO: découpler launcher de libbpf
#include <bpf/libbpf.h>

#include "../common/tc_user_helpers.h"
#include "../common/xdp_user_helpers.h"

#include "launcher.h"

/** 
  * Deploy transport functions on tc hook.
  * @param tc_config *cfg - configure tc attachment
  * @param tf_file - bpf file to load in kernel
  * @param interface - interface where to load tf
  * @param  flags -        
  * @retval 0 on success
  * @retval -1 on failure 
  * 
*/ 
int
launcher_deploy_tc_tf(struct tc_config *cfg, char *tf_file, char *interface, int flags)
{
        int ifindex = if_nametoindex(interface);    
        
        //TODO : change this part later... remove egress
        if (!(ifindex)) { 
                        snprintf(cfg->err_buf, ERRBUF_SIZE, "ERR: --egress \"%s\" not real dev\n",
                                        interface);
                        return -1;
        }

        //WARN: strcpy is not very safe, it's better to uses his self-made function
        //...or strncpy ??
        strcpy(cfg->filename, tf_file);
        //snprintf(cfg->filename, sizeof(cfg->filename), "%s", tf_file);
        strcpy(cfg->dev, interface);
        //cfg->dev = interface;
       
        printf("Inject tc-bpf-file in the kernel...\n");
        printf("TC attach BPF object %s to device %s\n", cfg->filename, cfg->dev);

        switch (flags)
        {
                case TC_INGRESS_ATTACH:
                        //Fill in later...
                        return 0;
                        break;
                
                case TC_EGRESS_ATTACH:
                       //TODO: return code
                        if (tc_egress_attach_bpf(cfg)) {
                                snprintf(cfg->err_buf, ERRBUF_SIZE, "ERR: TC attach failed\n");
                                return -1;
                        }
                        break; 

                default:
                        snprintf(cfg->err_buf, ERRBUF_SIZE, 
                        "ERR: launcher_deploy_tc_tf() failed, flags unknown!\n");
                        return -1;
                        break;
        }

        return 0;
}

/** 
  * Remove transport functions on tc hook.
  * @param struct tc_config *cfg - 
  * @param flags -        
  * @retval 0 on success
  * @retval -1 on failure
  * 
*/ 
//TODO: make it more simple in removing struct tc_config
int
launcher_remove_tc_tf(struct tc_config *cfg, char *interface, int flags)
{       

        int ifindex = if_nametoindex(interface);    
        
        //TODO : change this part later... remove egress
        if (!(ifindex)) { 
                        snprintf(cfg->err_buf, ERRBUF_SIZE,
                                "ERR: --egress \"%s\" not real dev\n",
                                        interface);
                        return -1;
        }

        //snprintf(cfg->filename, sizeof(cfg->filename), "%s", tf_file);
        strcpy(cfg->dev, interface);
       
        /*  remove tc-bpf program */
        printf("TC remove tc-bpf program on device %s\n", cfg->dev);
        switch (flags)
        {
                case TC_INGRESS_ATTACH:
                        // Fill this later...                 
                        return 0;
                        break;
                
                case TC_EGRESS_ATTACH:
                        tc_remove_egress(cfg);
                        break;
                
                default:
                        snprintf(cfg->err_buf, ERRBUF_SIZE,
                                "ERR: launcher_remove_tc_tf() failed, flags unknown!\n");
                                return -1;
                        break;               
                
        }

        return 0;
}


/** 
  * Deploy transport functions on xdp hook.
  * @param cfg - configure xdp attachment
  * @param tf_file - bpf file to load in kernel
  * @param interface - NIC where to load tf        
  * @retval 0 on success
  * @retval -1 on failure
  * 
*/
// TODO: put err_buf as parameter 
int 
launcher_deploy_xdp_tf(struct xdp_config *cfg, char *tf_file, char *ifname, 
                        __u32 xdp_flags)
{       

        struct bpf_object *bpf_obj = NULL;

        if (tf_file[0] == 0) {
                snprintf(cfg->err_buf, ERRBUF_SIZE, "ERR: bad tf_file\n");
                return -1;
        }
                
        //TODO: 2nd test on tf_file - verify that ebpf prog type is XDP
        bool reuse_maps = false;
        bpf_obj = load_bpf_and_xdp_attach(cfg, tf_file, ifname, xdp_flags, reuse_maps);
	if (bpf_obj == NULL) {
		/* Error handling done in load_bpf_and_xdp_attach */
		return -1;
	}

        struct bpf_map *map = NULL;
        map = bpf_object__find_map_by_name(bpf_obj, "xsks_map");
        int xsks_map_fd = bpf_map__fd(map);
        if (xsks_map_fd < 0) {
                snprintf(cfg->err_buf, ERRBUF_SIZE, "ERR: no xsks map found: %s\n",
                        strerror(xsks_map_fd));
                return -1;
	}

        return 0;
}

/** 
  * Remove transport functions on xdp hook.
  * @param cfg -
  * @param interface - NIC where to remove tf
  * @param flags -         
  * @retval 
  * 
*/
int
launcher_remove_xdp_tf(char *ifname, __u32 xdp_flags)
{
        int ret;
        int ifindex = if_nametoindex(ifname);
        ret = xdp_link_detach(ifindex, xdp_flags, 0);
        if (ret != 0) {
                // Error message ?
                return -1;
        }
        return 0;
}




