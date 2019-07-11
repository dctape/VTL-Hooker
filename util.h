/*
 *
 * utilities
 * 
 */

#ifndef __HK_UTIL_H
#define __HK_UTIL_H

#include <stdio.h>
#include <string.h>
#include "./bpf/bpf_helpers.h"


#define clean_errno() (errno == 0 ? "None" : strerror(errno))
#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)

#define bpf_printk(fmt, ...)					\
({								\
	       char ____fmt[] = fmt;				\
	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
				##__VA_ARGS__);			\
})


typedef struct sock_key sock_key_t;
struct sock_key{

    __u32 sip4;
    __u32 dip4;
    __u32 sport;
    __u32 dport;

};

#endif