
#include <linux/bpf.h>
//#include <bpf/bpf.h>

#include "bpf_helpers.h"
#include "bpf_endian.h"

#include "../lib/config.h"
#include "../lib/maps.h"

#define bpf_printk(fmt, ...)					\
({								\
	       char ____fmt[] = fmt;				\
	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
				##__VA_ARGS__);			\
})

// struct bpf_map_def SEC("maps") sock_key_map = {
//     .type = BPF_MAP_TYPE_ARRAY,
//     .key_size = sizeof(int),
//     .value_size = sizeof(sock_key_t), // sock_key
//     .max_entries = 1
// };

// struct bpf_map_def SEC("maps") hooker_map = {
// 	.type = BPF_MAP_TYPE_SOCKHASH,
// 	.key_size = sizeof(sock_key_t),
// 	.value_size = sizeof(int),
// 	.max_entries = 20
// };


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