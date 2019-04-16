/*
 *
 * complément à libbcc
 * 
*/
#include <linux/bpf.h>

int bpf_prog_attach(int progfd, int target_fd, enum bpf_attach_type type, 
					unsigned int flags);
int bpf_prog_detach(int target_fd, enum bpf_attach_type type);
int bpf_prog_detach2(int prog_fd, int target_fd, enum bpf_attach_type type);