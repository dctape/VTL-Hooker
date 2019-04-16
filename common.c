#include "common.h"
#include <string.h>
#include <linux/bpf.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>
#include <asm/unistd.h>
#include <stdint.h>

/*
 * When building perf, unistd.h is overridden. __NR_bpf is
 * required to be defined explicitly.
 */
#ifndef __NR_bpf
# if defined(__i386__)
#  define __NR_bpf 357
# elif defined(__x86_64__)
#  define __NR_bpf 321
# elif defined(__aarch64__)
#  define __NR_bpf 280
# elif defined(__sparc__)
#  define __NR_bpf 349
# elif defined(__s390__)
#  define __NR_bpf 351
# else
#  error __NR_bpf not defined. libbpf does not support your arch.
# endif
#endif



static inline int sys_bpf(enum bpf_cmd cmd, union bpf_attr *attr,
			  unsigned int size)
{
	return syscall(__NR_bpf, cmd, attr, size);
}
int bpf_prog_attach(int progfd, int target_fd, enum bpf_attach_type type, 
					unsigned int flags)
{
	union bpf_attr attr;

	bzero(&attr, sizeof(attr));
	attr.target_fd = target_fd;
	attr.attach_bpf_fd = progfd;
	attr.attach_type = type;
	attr.attach_flags = flags;

	return sys_bpf(BPF_PROG_ATTACH, &attr, sizeof(attr));
}

int bpf_prog_detach(int target_fd, enum bpf_attach_type type)
{
	union bpf_attr attr;

	bzero(&attr, sizeof(attr));
	attr.target_fd	 = target_fd;
	attr.attach_type = type;

	return sys_bpf(BPF_PROG_DETACH, &attr, sizeof(attr));
}

int bpf_prog_detach2(int prog_fd, int target_fd, enum bpf_attach_type type)
{
	union bpf_attr attr;

	bzero(&attr, sizeof(attr));
	attr.target_fd	 = target_fd;
	attr.attach_bpf_fd = prog_fd;
	attr.attach_type = type;

	return sys_bpf(BPF_PROG_DETACH, &attr, sizeof(attr));
}