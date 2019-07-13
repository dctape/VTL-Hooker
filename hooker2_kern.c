/*
 *
 * hooker ebpf program
 *  
 * 
*/

//#include <uapi/linux/bpf.h>

#include <linux/bpf.h>
#include "./bpf/bpf_helpers.h"
#include "./bpf/bpf_endian.h"

#include "config.h"
#include "./lib/maps.h"

#define bpf_printk(fmt, ...)					\
({								\
	       char ____fmt[] = fmt;				\
	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
				##__VA_ARGS__);			\
})


void hk_add_hmap(struct bpf_sock_ops *skops)
{
    /* Extract key */
    sock_key_t skey = {};  
    skey.dip4 = skops->remote_ip4;
    skey.sip4 = skops->local_ip4;
    skey.dport = skops->remote_port ; 
    skey.sport = bpf_ntohl(skops->local_port) ;

    /* test */
    bpf_printk("sport: %d", skops->local_port);
    if(skops->local_port == PORT_CLIENT_TCP){
        int key = 0;
        bpf_map_update_elem(&sock_key_map, &key, &skey, BPF_ANY);
    }
   
    bpf_sock_hash_update(skops, &hooker_map, &skey, BPF_NOEXIST);
}

SEC("sockops")
int redirector_sockops(struct bpf_sock_ops *skops)
{
    /* add passive or active established socket  to hooker sockhash  */
  
    int key = 0;
    int *value;
    __u32 family, op = skops->op;

    switch(op){

        case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB: // pas la peine d'ajouter tous les sockets
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
int redirector_skmsg(struct sk_msg_md *msg) // TODO : use a better name...
{
    __u64 flags = BPF_F_INGRESS;
    __u32 lport;
    sock_key_t hsock_key = {};  

    lport = msg->local_port; // ok

    switch(lport){

        case PORT_SOCK_REDIR:
           // hooker userpace -> app
           bpf_printk("hooker -> app\n");

           //retrieve sock_key client
           int key = 0;
           sock_key_t *value;
           sock_key_t c_skey = {};
           value = bpf_map_lookup_elem(&sock_key_map, &key); // pas optimal
           if(!value)
                return SK_DROP;
           c_skey = *value;

           //redirect data to app
           bpf_msg_redirect_hash(msg, &hooker_map, &c_skey, flags);
           break;
              
        case PORT_CLIENT_TCP:
            
           // app client -> hooker userspace
           bpf_msg_redirect_hash(msg, &hooker_map, &hsock_key, flags);
           break;
      
        
        default:
            break; //optional
    }

   
    return SK_PASS;
} 

char _license[] SEC("license") = "GPL";