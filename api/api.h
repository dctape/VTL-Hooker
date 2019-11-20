
#ifndef __API_H
#define __API_H

#include "../include/vtl/vtl_structures.h"

int vtl_config(vtl_md_t *vtl_md, char *interface, char *src_ip);
int vtl_snd(vtl_md_t *vtl_md, char *dst_ip, uint8_t *data,  size_t datalen);
ssize_t vtl_rcv(vtl_md_t *vtl_md, void *buf);




#endif /* __API_H */