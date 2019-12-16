#ifndef __LAUNCHER_H
#define __LAUNCHER_H

#include "../common/tc_user_helpers.h"
#include "../common/xdp_user_helpers.h"


//deployy/remove flags
//TODO: Find a better name
#define TC_INGRESS_ATTACH      0x0
#define TC_EGRESS_ATTACH       0x1


int 
launcher_deploy_tc_tf(struct tc_config *cfg, char *tf_file, char *interface, 
                        int flags);
int 
launcher_remove_tc_tf(struct tc_config *cfg, char *interface, int flags);

int 
launcher_deploy_xdp_tf(struct xdp_config *cfg, char *tf_file, char *ifname, 
                        __u32 xdp_flags);
int 
launcher_remove_xdp_tf(char *ifname, __u32 xdp_flags);

#endif /* __LAUNCHER_H */