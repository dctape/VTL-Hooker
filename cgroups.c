#include <uapi/linux/bpf.h>
#include <linux/socket.h>
#include <linux/net.h>
#include <uapi/linux/in.h>
#include <uapi/linux/in6.h>
#include <bcc/helpers.h>

int cgroups(struct bpf_sock *sk)
{
    //char *fmt = "socket: family %d type %d protocol %d\n";

	//bpf_trace_printk(fmt, sizeof(fmt), sk->family, sk->type, sk->protocol);

	/* block PF_INET, SOCK_RAW, IPPROTO_ICMP sockets
	 * ie., make ping fail
	 */
	if (sk->family == PF_INET &&
	    sk->type == SOCK_RAW  &&
	    sk->protocol == IPPROTO_ICMP)
		return 0;

	return 1;
}