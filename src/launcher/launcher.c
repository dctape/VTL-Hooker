#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <linux/if_link.h>

//TODO: découpler launcher de libbpf
#include <bpf/bpf.h>
#include <bpf/libbpf.h>

#include "../common/tc_user_helpers.h"
#include "../common/xdp_user_helpers.h"
#include "../../include/vtl.h"

#include "launcher.h"

int perf_map_fd;

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
launcher__deploy_tc(struct tc_config *cfg, char *bpf_file, char *interface, int flags)
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
        strcpy(cfg->filename, bpf_file);
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
launcher__remove_tc(struct tc_config *cfg, char *interface, int flags)
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
launcher__deploy_xdp_xsk(struct xdp_config *cfg, char *bpf_file, char *ifname, 
                        __u32 xdp_flags)
{       

        struct bpf_object *bpf_obj = NULL;

        if (bpf_file[0] == 0) {
                snprintf(cfg->err_buf, ERRBUF_SIZE, "ERR: bad tf_file\n");
                return -1;
        }
                
        //TODO: 2nd test on tf_file - verify that ebpf prog type is XDP
        bool reuse_maps = false;
        bpf_obj = load_bpf_and_xdp_attach(cfg, bpf_file, ifname, xdp_flags, reuse_maps);
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
launcher__remove_xdp(char *ifname, __u32 xdp_flags)
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

/** deploy and remove ARQ functions **/
// // Error: 'xdp_sock' not found
// struct bpf_object * 
// launcher__xdp_deploy(struct xdp_config *cfg, char *bpf_file, char *ifname, 
//                         __u32 xdp_flags)
// {       

//         struct bpf_object *bpf_obj = NULL;

//         if (bpf_file[0] == 0) {
//                 snprintf(cfg->err_buf, ERRBUF_SIZE, "ERR: bad tf_file\n");
//                 return NULL;
//         }
                
//         //TODO: 2nd test on tf_file - verify that ebpf prog type is XDP
//         bool reuse_maps = false;
//         bpf_obj = load_bpf_and_xdp_attach(cfg, bpf_file, ifname, xdp_flags, reuse_maps);
// 	if (bpf_obj == NULL) {
// 		/* Error handling done in load_bpf_and_xdp_attach */
// 		return NULL;
// 	}

//         // struct bpf_map *map = NULL;
//         // map = bpf_object__find_map_by_name(bpf_obj, "xsks_map");
//         // int xsks_map_fd = bpf_map__fd(map);
//         // if (xsks_map_fd < 0) {
//         //         snprintf(cfg->err_buf, ERRBUF_SIZE, "ERR: no xsks map found: %s\n",
//         //                 strerror(xsks_map_fd));
//         //         return -1;
// 	// }
//         return bpf_obj;
// }

// int
// launcher__xdp_remove(char *ifname, __u32 xdp_flags)
// {
//         int ret;
//         int ifindex = if_nametoindex(ifname);
//         ret = xdp_link_detach(ifindex, xdp_flags, 0);
//         if (ret != 0) {
//                 // Error message ?
//                 return -1;
//         }
//         return 0;
// }

// static int do_attach(int idx, int fd, const char *name,  __u32 xdp_flags)
// {
// 	struct bpf_prog_info info = {0}; // location linux/bpf.h
// 	__u32 info_len = sizeof(info);
// 	int err;

// 	err = bpf_set_link_xdp_fd(idx, fd, xdp_flags);
// 	if (err < 0) {
// 		printf("ERROR: failed to attach program to %s\n", name);
// 		return err;
// 	}

// 	err = bpf_obj_get_info_by_fd(fd, &info, &info_len);
// 	if (err) {
// 		printf("can't get prog info - %s\n", strerror(errno));
// 		return err;
// 	}
// 	//prog_id = info.id;

// 	return err;
// }

// //retval 0 success, -1 failure
// int
// launcher__arqin_deploy(struct xdp_config *cfg, char *arqin_file, char *ifname, 
//                         __u32 xdp_flags)
// {
//         int prog_fd;
//         struct bpf_object *bpf_obj = NULL;
//         struct bpf_prog_load_attr prog_load_attr = {
// 		.prog_type	= BPF_PROG_TYPE_XDP,
// 	};
//         prog_load_attr.file = arqin_file;
        
//         if (bpf_prog_load_xattr(&prog_load_attr, &bpf_obj, &prog_fd))
// 		return -1;
//         if (!prog_fd) {
// 		printf("bpf_prog_load_xattr: %s\n", strerror(errno));
// 		return -1;
// 	}

//         struct bpf_map *map;
//         map = bpf_map__next(NULL, bpf_obj);
// 	if (!map) {
// 		printf("ERR: finding perf map in obj file failed\n");
// 		return -1;
// 	}
//         perf_map_fd = bpf_map__fd(map);

//         int if_idx = if_nametoindex(ifname);
// 	if (!if_idx)
// 		if_idx = strtoul(ifname, NULL, 0);

// 	if (!if_idx) {
// 		fprintf(stderr, "Invalid ifname\n");
// 		return 1;
// 	}

//         int err = do_attach(if_idx, prog_fd, ifname, xdp_flags);
// 	if (err)
// 		return -1;
//                 //return err;

//         return 0;
// }

// int 
// launcher_arqin_remove()
// {

// }



