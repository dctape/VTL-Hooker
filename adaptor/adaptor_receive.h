
#ifndef __ADAPTOR_RECEIVE_H
#define __ADAPTOR_RECEIVE_H

#include "../include/vtl/vtl_macros.h"
#include "../include/vtl/vtl_structures.h"

int adaptor_config_and_open_xsk_sock(vtl_md_t *vtl_md);
void adaptor_rcv_data(vtl_md_t *vtl_md);

#endif /* __ADAPTOR_RECEIVE_H */