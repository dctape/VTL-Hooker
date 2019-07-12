
#ifndef __HK_BPF_MANAGER_H
#define __HK_BPF_MANAGER_H


#define ERR_REDIRECTOR_SKMSG        1
#define ERR_REDIRECTOR_SOCKOPS      2



extern int sock_key_map;
extern int hooker_map;

extern int redirector_sockops_prog;
extern int redirector_skmsg_prog; 


int bpf_inject(char *bpf_filename);
int bpf_init_maps(void);

int bpf_attach_prog_redirector(int cgfd); //TODO : find an other name...
int bpf_detach_redirector_prog(int err_attach, int cgfd);


#endif