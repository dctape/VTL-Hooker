
//#include <uapi/linux/bpf.h>
#include <linux/bpf.h>
#include "bpf_helpers.h"
#include "bpf_endian.h"


#define SOCKOPS_MAP_SIZE            20
#define H_PORT                      10002
#define S_PORT                      9090


// definition of memcpy
#ifndef memcpy
# define memcpy(dest, src, n)   __builtin_memcpy((dest), (src), (n))
#endif


#define HASH_SIZE   20


#define hash_sock(skey) ( \
( (skey.sport & 0xff) | ((skey.dport & 0xff) << 8) | \
  ((skey.sip4 & 0xff) << 16) | ((skey.dip4 & 0xff) << 24) \
) % HASH_SIZE) 

struct sock_key{

    __u32 sip4;
    __u32 dip4;
    __u32 sport;
    __u32 dport;

}; //TODO : __attribute__((packed))

#define bpf_printk(fmt, ...)					\
({								\
	       char ____fmt[] = fmt;				\
	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
				##__VA_ARGS__);			\
})


// map de passage de valeur

struct bpf_map_def SEC("maps") tx_id = {
    .type = BPF_MAP_TYPE_ARRAY,
    .key_size = sizeof(int),
    .value_size = sizeof(int), // id
    .max_entries = 1,
};


// map de mapping id <----> sock_key

struct bpf_map_def SEC("maps") mapping = {
    .type = BPF_MAP_TYPE_HASH,
    .key_size = sizeof(int),                // id
    .value_size = sizeof(struct sock_key),  // sock_key
    .max_entries = 20,
};

// map de redirection
struct bpf_map_def SEC("maps") hmap = {
	.type = BPF_MAP_TYPE_SOCKHASH,
	.key_size = sizeof(struct sock_key),
	.value_size = sizeof(int),
	.max_entries = 20,
};



void h_add_hmap(struct bpf_sock_ops *skops)
{
    struct sock_key skey = {};
    int tx_key, tx_value,cnt_key = 0 , id;   

    skey.dip4 = skops->remote_ip4;
    skey.sip4 = skops->local_ip4;
    skey.dport = skops->remote_port ; 
    skey.sport = bpf_ntohl(skops->local_port) ;
    
    // get id for skey

    id = hash_sock(skey);

    // on récupère le compteur
    //id = bpf_map_lookup_elem(&counter, &cnt_key);  // plus besoin

    bpf_map_update_elem(&mapping, &id, &skey, BPF_ANY);      
    bpf_sock_hash_update(skops, &hmap, &skey, BPF_NOEXIST);

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
        case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:

                h_add_hmap(skops);

            break;
        default:
            break;
    } 

    return 0;
}

// 1 sk_msg pour msg redirector
SEC("sk_msg")
int hk_msg_redir(struct sk_msg_md *msg)
{
    __u64 flags = BPF_F_INGRESS;
    __u32 lport, rport;
    struct sock_key hsock_key = {};
    struct sock_key skey = {};
    
    int tx_key = 0;

    
    
    //lport = bpf_ntohl(msg->local_port);
    lport = msg->local_port;
    // comparaison au niveau du port
    if(lport == H_PORT){
        
        bpf_printk("hooker -> app : port = %d\n", lport);
        // hooker userspace -> app
        struct sock_key *value ;
        int *val_id;
        int id;
        
        // retrieve id app
        val_id = bpf_map_lookup_elem(&tx_id, &tx_key);
        if(!val_id)
            return SK_DROP;
        id = *val_id;
        // retrieve sock_key app
        value = bpf_map_lookup_elem(&mapping, &id);
        if(!value)
            return SK_DROP;
        skey = *value;

        // redirect to appstruct sock_key skey = {};
        bpf_msg_redirect_hash(msg, &hmap, &skey, flags);
    }
    else {
        // app -> hooker userspace

        // get msg sock_key
        bpf_printk("app -> hooker: app_port = %d\n", lport);
        skey.dip4 = msg->remote_ip4;
        skey.sip4 = msg->local_ip4;
        skey.dport = msg->remote_port ; 
        skey.sport = bpf_ntohl(msg->local_port); //est-ce que cela ne sera pas problématique ?

        // retrieve id app
        int id;
        id = hash_sock(skey);

        // give id to hooker
        bpf_map_update_elem(&tx_id, &tx_key, &id, BPF_EXIST); // for userspace mapping

        // redirect to hooker  
        bpf_msg_redirect_hash(msg, &hmap, &hsock_key, flags);
    } 
    
   
    return SK_PASS;
} 




char _license[] SEC("license") = "GPL";
