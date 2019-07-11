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

#define HASH_SIZE   20
#define hash_sock(skey) ( \
( (skey.sport & 0xff) | ((skey.dport & 0xff) << 8) | \
  ((skey.sip4 & 0xff) << 16) | ((skey.dip4 & 0xff) << 24) \
) % HASH_SIZE)

#define bpf_printk(fmt, ...)					\
({								\
	       char ____fmt[] = fmt;				\
	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
				##__VA_ARGS__);			\
})

// definition of memcpy
#ifndef memcpy
# define memcpy(dest, src, n)   __builtin_memcpy((dest), (src), (n))
#endif



typedef struct sock_key sock_key_t;
struct sock_key{

    __u32 sip4;
    __u32 dip4;
    __u32 sport;
    __u32 dport;

};

// map de passage du token -> espace utilisateur
struct bpf_map_def SEC("maps") tx_token = {
    .type = BPF_MAP_TYPE_ARRAY,
    .key_size = sizeof(int),
    .value_size = sizeof(int), // token
    .max_entries = 1,
};

// userspace -> kernel
struct bpf_map_def SEC("maps") rx_token = {
    .type = BPF_MAP_TYPE_ARRAY,
    .key_size = sizeof(int),
    .value_size = sizeof(int), // token
    .max_entries = 1,
};

// map d'association du token avec la sock_key
struct bpf_map_def SEC("maps") mapping = { // TODO: change name later...
    .type = BPF_MAP_TYPE_HASH,
    .key_size = sizeof(int),                // token
    .value_size = sizeof(struct sock_key),  // sock_key
    .max_entries = 20,
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
    int token;
   
    skey.dip4 = skops->remote_ip4;
    skey.sip4 = skops->local_ip4;
    skey.dport = skops->remote_port ; 
    skey.sport = bpf_ntohl(skops->local_port) ;

    /* calculate token for this skey */
    token = hash_sock(skey);

    /* add token in mapping map */
    bpf_map_update_elem(&mapping, &token, &skey, BPF_ANY);

    bpf_printk("sport: %d | token1 = %d\n", skops->local_port, token);
    bpf_sock_hash_update(skops, &hooker_map, &skey, BPF_NOEXIST);
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
    sock_key_t skey = {};
    int token_key = 0, ret; // TODO : change name later...

    lport = msg->local_port; // ok

    if(lport == H_PORT){
        // hooker userpace -> app
        bpf_printk("hooker -> app\n");
        int *token_val;
        int token; // Not necessary

        sock_key_t * skey_val;

        //retrieve token from userspace
        token_val = bpf_map_lookup_elem(&tx_token, &token_key);
        if(!token_val) {
            bpf_printk("token not found\n");
            return SK_DROP;
        }
            
        token = *token_val;

        //retrieve sock_key with token
        skey_val =  bpf_map_lookup_elem(&mapping, &token);
        if(!skey_val){
            bpf_printk("skey not found\n");
            return SK_DROP;
        }
        skey = *skey_val; // Not necessary

        //redirect data to app
        bpf_msg_redirect_hash(msg, &hooker_map, &skey, flags);
        

        //return SK_PASS;
    }
    else{
        // app -> hooker userspace

        bpf_printk("app ->  hooker: port = %d\n", lport);

        // extract key
        skey.dip4 = msg->remote_ip4;
        skey.sip4 = msg->local_ip4;
        skey.dport = msg->remote_port ; 
        skey.sport = bpf_ntohl(msg->local_port); //est-ce que cela ne sera pas problématique ?

        // push header
        int  offset = 0;
        int len = sizeof(sock_key_t);
        ret = bpf_msg_push_data(msg, offset, len, 0);
        if(ret < 0)
            return SK_DROP;

        // encapsulate legacy data
        memcpy(msg, &skey, sizeof(sock_key_t));

        bpf_printk("bpf_push_data worked !\n");



        // calculate token
        int token  =  hash_sock(skey);

        bpf_printk("lport = %d | token2 = %d\n", msg->local_port, token);

        // transmit token to userspace
        bpf_map_update_elem(&tx_token, &token_key, &token, BPF_EXIST);

        //redirect to hooker
        bpf_msg_redirect_hash(msg, &hooker_map, &hsock_key, flags);
    }
    
     
   
    return SK_PASS;
} 

char _license[] SEC("license") = "GPL";