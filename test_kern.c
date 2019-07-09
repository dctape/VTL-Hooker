/*
 *
 * test program ebpf
 *  
 * 
*/

//#include <uapi/linux/bpf.h>
#include <linux/bpf.h>
#include "bpf_helpers.h"
#include "bpf_endian.h"

#define H_PORT                      10002

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

struct bpf_map_def SEC("maps") hooker_map = {
	.type = BPF_MAP_TYPE_SOCKHASH,
	.key_size = sizeof(sock_key_t),
	.value_size = sizeof(int),
	.max_entries = 20
};

void hk_add_hmap(struct bpf_sock_ops *skops)
{
    /* Extract key */
    sock_key_t skey = {};
   
    skey.dip4 = skops->remote_ip4;
    skey.sip4 = skops->local_ip4;
    skey.dport = skops->remote_port ; 
    skey.sport = bpf_ntohl(skops->local_port) ;

    /* Add sock redir to hmap */
    if(skops->local_port == H_PORT) { //ok
        
        sock_key_t skey_redir = {};
        bpf_printk("sock_redir - sport: %d\n", skops->local_port);
        bpf_sock_hash_update(skops, &hooker_map, &skey_redir, BPF_NOEXIST); // ok
    }
    else {
        bpf_printk("other_sock - sport: %d\n", skops->local_port);
        bpf_sock_hash_update(skops, &hooker_map, &skey, BPF_NOEXIST);
    }
    
    /* bpf_printk("sport: %d\n", skops->local_port);
    bpf_sock_hash_update(skops, &hooker_map, &skey, BPF_NOEXIST); */
}

SEC("sockops")
int hk_add_sock(struct bpf_sock_ops *skops)
{
    /* add passive or active established socket  to hooker sockhash  */
  
    int key = 0;
    int *value;
    __u32 family, op = skops->op;

    switch(op){

        case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
                bpf_printk("serveur\n");
                hk_add_hmap(skops);
            break;       
        case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
                bpf_printk("client\n");
                hk_add_hmap(skops);

            break;
       
        default:
            break;
    } 

    return 0;
}



SEC("sk_msg")
int hk_msg_redir(struct sk_msg_md *msg)
{
    __u64 flags = BPF_F_INGRESS;
    __u32 lport;
    sock_key_t hsock_key = {};

    lport = msg->local_port;

    if(lport == H_PORT){

        bpf_printk("hooker -> app\n");
        return SK_DROP;
    }
    else{
        bpf_printk("app -> hooker: port = %d\n", lport);
        bpf_msg_redirect_hash(msg, &hooker_map, &hsock_key, flags);
    }
    
     
   
    return SK_PASS;
} 

char _license[] SEC("license") = "GPL";