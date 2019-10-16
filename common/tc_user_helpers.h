
#ifndef __TC_USER_HELPERS_H
#define __TC_USER_HELPERS_H

#include "defines.h"

struct tc_config {

        char filename[512];
        char *dev;

};

int tc_egress_attach_bpf(struct tc_config *cfg);
int tc_remove_egress(struct tc_config *cfg);

#endif /*__TC_USER_HELPERS_H */