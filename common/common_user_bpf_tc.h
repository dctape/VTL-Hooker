
#ifndef __COMMON_USER_BPF_TC_H
#define __COMMON_USER_BPF_TC_H

#include "common_defines.h"

int tc_egress_attach_bpf(struct config *cfg);
int tc_remove_egress(struct config *cfg);

#endif /* __COMMON_USER_BPF_TC_H */