
#include <stdbool.h>
#include <stdint.h>

#include <linux/if_ether.h>
#include <linux/ip.h>
#include <linux/pkt_cls.h> //TODO: add it to headers repo ?

#include <linux/bpf.h>

#include "bpf/bpf_helpers.h"
#include "bpf/tc_bpf_util.h"

#include "../../include/vtl_kern.h"


// #define MAX_IP_HDR_LEN          60
// #define BPF_ADJ_ROOM_NET        0


#define bpf_debug_printk(fmt, ...)                                      \
    ({                                                                  \
        if(unlikely(is_debug())) {                                      \
            char ____fmt[] = fmt;                                       \
            bpf_trace_printk(____fmt, sizeof(____fmt), ##__VA_ARGS__);  \
        }                                                               \
    }) 







/* Notice: TC and iproute2 bpf-loader uses another elf map layout */

/*** Start: For DEBUGGING... ***/
struct bpf_elf_map SEC("maps") DEBUGS_MAP = {

    .type = BPF_MAP_TYPE_ARRAY,
    .size_key = sizeof(unsigned int),
    .size_value = sizeof(bool),
    .pinning = PIN_GLOBAL_NS,
    .max_elem = 1,
};


// static __always_inline
// bool is_debug(void) 
// {

//         int index = 0;      // The map has size of 1 so index is always 0
//         bool *value = (bool *)bpf_map_lookup_elem(&DEBUGS_MAP, &index);
//         if(!value) {
//             return false;
//         }

//         return *value;
// }


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
    
        // bpf_debug_printk("[START]: packet processing...\n");

        // /* parsing */
        
        // void *data = (void *)(long)skb->data;
        // void *data_end = (void *)(long)skb->data_end;

        // struct ethhdr *eth = (struct ethhdr *) data;                            //#modif1: efbonfoh
        
        // //int offset;

        // /* Verifier Check. */
        // if((void *)(eth + 1) > data_end)                                        //#modif2: efbonfoh
        //                 return TC_ACT_OK;

        //                                                                         //#modif3: efb
        // struct iphdr *iph = (struct iphdr *)(void *)(eth + 1);
        // if((void *)(iph + 1) > data_end)
        //         return TC_ACT_OK;

        // unsigned int iph_len = iph->ihl << 2; // multiplier par 4
        // if(iph_len > MAX_IP_HDR_LEN)
        //         return TC_ACT_OK;                                                   //#modif5: efb; replace return ???
        
        // if(iph->protocol != IPPROTO_VTL){

        //         bpf_debug_printk("No VTL packet, ip_proto = %d\n");

        //         return TC_ACT_OK;
        // }

        // int padlen = sizeof(struct vtlhdr);

        // /*** Resizing ***/
        // int ret = bpf_skb_adjust_room(skb, padlen, BPF_ADJ_ROOM_NET, 0);
        // if(ret) {
        //         bpf_debug_printk("Error calling skb adjust room\n");
        //         return TC_ACT_OK;
        // }
        
        // bpf_debug_printk("Storing VTL header value\n");
        
        // struct vtlhdr vtlh = {
        //         .ctrl_sum = 20,
        //         //.seq_num = 1,
        // };

        // unsigned long offset = sizeof(struct ethhdr) + (unsigned long)iph_len;
        // ret = bpf_skb_store_bytes(skb, (int)offset, &vtlh, sizeof(struct vtlhdr),
        //                                 BPF_F_RECOMPUTE_CSUM); 
	
	void *data = (void *)(long)skb->data;
        void *data_end = (void *)(long)skb->data_end;

	struct ethhdr *eth = (struct ethhdr *)data;
        if(eth + 1 > data_end)
        	return TC_ACT_OK;
        
        struct iphdr *iph = (struct iphdr *)(eth + 1);
        if(iph + 1 > data_end)
             return TC_ACT_OK;
	
	if(iph->protocol != IPPROTO_VTL)
	         return TC_ACT_OK;
	
	//TODO: Modify with bpf_skb_store_bytes ?
	vtlhdr_t *vtlh = (vtlhdr_t *)(iph + 1);
	if(vtlh + 1 > data_end)
             return TC_ACT_OK;

	vtlh->checksum = 30;
	
        return TC_ACT_OK;
}

char _license[] SEC("license") = "GPL";