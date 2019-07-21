/*
 * kernel code for tc
 * 
*/


#include <linux/bpf.h>
#include "./bpf/bpf_helpers.h"
#include "./bpf/bpf_endian.h" // for now, not necessary.

#include <linux/pkt_cls.h>
//#include <uapi/linux/pkt_cls.h>
//TODO add uapi


/* Notice: TC and iproute2 bpf-loader uses another elf map layout */
struct bpf_elf_map {
	__u32 type;
	__u32 size_key;
	__u32 size_value;
	__u32 max_elem;
	__u32 flags;
	__u32 id;
	__u32 pinning;
};

/* 
 * A file is automatically created here:
 *  /sys/fs/bpf/tc/globals/map_name
 */

/* maps section */

/* Notice this section name is used when attaching TC filter
 *
 * Like:
 *  $TC qdisc   add dev $DEV clsact
 *  $TC filter  add dev $DEV ingress bpf da obj $BPF_OBJ sec ingress_redirect
 *  $TC filter show dev $DEV ingress
 *  $TC filter  del dev $DEV ingress
 *
 * Does TC redirect respect IP-forward settings?
 *
 */

SEC("tf_tc_egress")
int _tf_tc_egress(struct __sk_buff *skb)
{
    /* work only on the vtl packet */
    //Idea : if(ip_proto == ipproto_vtl)

    return TC_ACT_SHOT;
}

char _license[] SEC("license") = "GPL";
