
#include <linux/socket.h>
#include <linux/net.h>
#include <linux/in.h>



int cgroup(struct bpf_sock *sk)
{	

	//__u32 proto = bpf_ntohs(sk->protocol);
	if (sk->family == PF_INET)
		return 0;

	return 0;
}