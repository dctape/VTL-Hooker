
#ifndef __TC_USER_HELPERS_H
#define __TC_USER_HELPERS_H

//TODO: put it common.h
#define ERRBUF_SIZE     256
struct tc_config {

        char filename[512];
        char dev[20];
        char err_buf[ERRBUF_SIZE];

};

/**
 * Attach bpf programs on a tc hook point.
 * @param cfg pointer to a tc configuration object
 * @retval  >= 0 on success
 * @retval -1 on failure
 **/ 
int 
tc_egress_attach_bpf(struct tc_config *cfg);

/**
 * Remove bpf programs on a tc hook point. 
 * @param cfg pointer to a tc configuration object
 * @retval  >= 0 on success
 * @retval -1 on failure
 **/ 
int 
tc_remove_egress(struct tc_config *cfg);

#endif /*__TC_USER_HELPERS_H */