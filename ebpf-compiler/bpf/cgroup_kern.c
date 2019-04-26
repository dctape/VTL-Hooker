/*
 *
 *  Programme BPF bloquant toutes les tentatives d'émissions de paquets au
 * niveau du cgroup root.
 * 
*/

/* clang does not support "asm volatile goto" yet.
 * So redefine asm_volatile_goto to some invalid asm code.
 * If asm_volatile_goto is actually used by the bpf program,
 * a compilation error will appear.
 */

#ifdef asm_volatile_goto
#undef asm_volatile_goto
#define asm_volatile_goto(x...) asm volatile("invalid use of asm_volatile_goto")
#endif

#include <uapi/linux/bpf.h>
#include <linux/socket.h> // mettre les uapi plus tard
#include <linux/net.h>
#include <uapi/linux/in.h>


#include "bpf_helpers.h"




SEC("cgroup/sock1")
int bpf_prog_cgroup(struct bpf_sock *sk)
{	

	//__u32 proto = bpf_ntohs(sk->protocol);
    char fmt[] = "socket: family %d type %d protocol %d\n";

    bpf_trace_printk(fmt, sizeof(fmt), sk->family, sk->type, sk->protocol);
	if (sk->family == PF_INET &&
        sk->type == SOCK_RAW &&
        sk->protocol == IPPROTO_ICMP)
		return 0;

	return 1;
}

char _license[] SEC("license") = "GPL";