
#ifndef __HK_BPF_MANAGER_H
#define __HK_BPF_MANAGER_H

#include "bpf_load.h"
#include "libbpf.h"


#define ERR_REDIRECTOR_SKMSG        1
#define ERR_REDIRECTOR_SOCKOPS      2

//paramétrage commmande tc
#define CMD_MAX 	2048
#define CMD_MAX_TC	256


extern int sock_key_map;
extern int hooker_map;

extern int redirector_sockops_prog;
extern int redirector_skmsg_prog;


int bpf_inject(char *bpf_filename);
int bpf_init_maps(void);

int bpf_attach_redirector_prog(int sock_redir, int cgfd); //TODO : find an other name...
int bpf_detach_redirector_prog(int err_attach, int cgfd);

static int tc_egress_attach_bpf(const char* dev, const char* bpf_obj);
static int tc_remove_egress(const char* dev);


#endif