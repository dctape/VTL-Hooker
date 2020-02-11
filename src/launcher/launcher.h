#ifndef __LAUNCHER_H
#define __LAUNCHER_H

#include "../common/tc_user_helpers.h"
#include "../common/xdp_user_helpers.h"


//deployy/remove flags
//TODO: Find a better name
#define TC_INGRESS_ATTACH      0x0
#define TC_EGRESS_ATTACH       0x1


int 
launcher__deploy_tc(struct tc_config *cfg, char *bpf_file, char *interface, 
                        int flags);
int 
launcher__remove_tc(struct tc_config *cfg, char *interface, int flags);

int 
launcher__deploy_xdp_xsk(struct xdp_config *cfg, char *bpf_file, char *ifname, 
                        __u32 xdp_flags);
int 
launcher__remove_xdp(char *ifname, __u32 xdp_flags);

int
launcher__arqin_deploy(struct xdp_config *cfg, char *arqin_file, char *ifname, 
                        __u32 xdp_flags);

#endif /* __LAUNCHER_H */