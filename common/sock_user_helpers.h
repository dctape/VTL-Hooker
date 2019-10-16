#ifndef __SOCK_USER_HELPERS_H
#define __SOCK_USER_HELPERS_H

#include <bpf/libbpf.h> // Quest : est-ce nécessaire ?
#include "defines.h"


struct bpf_object *load_bpf_progs(struct config *cfg);

struct bpf_object *load_bpf_and_skmsg_attach(struct config *cfg, 
					      int sock_redir_fd);

struct bpf_object *load_bpf_and_sockops_attach(struct config *cfg);

int skmsg_detach (struct config *cfg, int skmsg_prog_fd);

int sockops_detach(struct config *cfg, int sockops_prog_fd);

#endif /*__SOCK_USER_HELPERS_H */