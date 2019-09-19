/*
 * kernel code for tc
 * 
*/

#include <linux/if_ether.h>
#include <linux/ip.h>

#include <linux/bpf.h>
#include "../../bpf/bpf_helpers.h"
#include "../../bpf/bpf_endian.h" // for now, not necessary.

#include <linux/pkt_cls.h>
//#include <uapi/linux/pkt_cls.h>
//TODO add uapi

//#define 

#define IPPROTO_VTL 200
#define MAX_IP_HDR_LEN          60
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


struct vtlhdr{
	int value;
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
    // work only on the vtl packet 
    //Idea : if(ip_proto == ipproto_vtl)

    /* parsing */
    
    /*void *data = (void *)(long)skb->data;
    void *data_end = (void *)(long)skb->data_end;
    
    struct ethhdr *eth = data;
    int offset;

    //Verifier Check.
   if (data + sizeof(*eth) > data_end)
		return TC_ACT_OK;

    
    //struct iphdr *ip = (struct iphdr *)(data + ETH_HLEN);
    struct iphdr *iph = data + sizeof(*eth);
    
    //test iph_len > MAX_IP_HDR_LEN
    if((void *)iph + 1 > data_end)
        return TC_ACT_OK; // Est-ce juste ?
    
    u8  iph_len = iph->ihl << 2; // multiplier par 4
    
    if(iph->protocol != IPPROTO_VTL)
        return TC_ACT_OK;
    
    struct vtlhdr *vtlh = (struct vtlhdr *)(data + ETH_HLEN + iph_len);
    // ou (struct vtlhdr *)(iph + iph_len);

    //int value = 20;
    //offset = ETH_HLEN + ip_len + offsetof(struct vtlhdr, value);

    //bpf_skb_store_bytes(skb, offset, &value, sizeof(value), 0); 

    if((void *)vtlh + 1 > data_end) // Trop important : Vérifier ou tester avant d'accéder.
        return TC_ACT_OK;

    vtlh->value = 20; 

    return TC_ACT_OK; */

    /* parsing */
    
    void *data = (void *)(long)skb->data;
    void *data_end = (void *)(long)skb->data_end;

    struct ethhdr *eth = (struct ethhdr *) data;                            //#modif1: efbonfoh
    
    int offset;

    /* Verifier Check. */
    if((void *)(eth + 1) > data_end)                                        //#modif2: efbonfoh
		return TC_ACT_OK;

                                                                            //#modif3: efb
    struct iphdr *iph = (struct iphdr *)(void *)(eth + 1);
    if((void *)(iph + 1) > data_end)
        return TC_ACT_OK;

    u8  iph_len = iph->ihl << 2; // multiplier par 4
    if(iph_len > MAX_IP_HDR_LEN)
        return TC_ACT_OK;                                                   //#modif5: efb; replace return ???
    
    if(iph->protocol != IPPROTO_VTL)
        return TC_ACT_OK;
    
    //struct vtlhdr *vtlh = (struct vtlhdr *)(void *)(iph + 1);               //#modif6: efb

    struct vtlhdr *vtlh = (struct vtlhdr *)(data + ETH_HLEN + iph_len);

    if((void *)(vtlh + 1) > data_end) // Trop important : Vérifier ou tester avant d'accéder.
        return TC_ACT_OK;

    vtlh->value = 20; 

    return TC_ACT_OK;


}

char _license[] SEC("license") = "GPL";