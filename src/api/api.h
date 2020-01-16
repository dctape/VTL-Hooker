
#ifndef __API_H
#define __API_H

#include "../../include/vtl/vtl_macros.h"
#include "../../include/vtl/vtl_structures.h"
//for building library purpose




/**
 * Configure a vtl context
 * @param vtl_md 
 * @param 
 * @param src_ip
 * @retval
 **/ 
vtl_md_t *
vtl_init(char *ifname, char *src_ip, int mode, char *err_buf);
int 
vtl_snd(vtl_md_t *vtl_md, char *target, char *dst_ip, uint8_t *data, size_t datalen, char *err_buf);
void 
vtl_rcv(vtl_md_t *vtl_md, FILE *rx_file);

int
vtl_listen(vtl_md_t *vtl_md);
int 
vtl_listen_stop(vtl_md_t *vtl_md);
ssize_t
vtl_rcv_perf(vtl_md_t *vtl_md, void *buf, ssize_t len);




#endif /* __API_H */