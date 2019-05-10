
//#include <uapi/linux/bpf.h>
#include <linux/bpf.h>
#include "bpf_helpers.h"
#include "bpf_endian.h"


#define SOCKOPS_MAP_SIZE            20 // augmenter jusqu'à 65535
#define H_PORT                      10002
#define S_PORT                      9090

#define bpf_printk(fmt, ...)					\
({								\
	       char ____fmt[] = fmt;				\
	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
				##__VA_ARGS__);			\
}) 

#ifndef memcpy
# define memcpy(dest, src, n)   __builtin_memcpy((dest), (src), (n))
#endif


/*structure clé socket */
struct sock_key{

    __u32 sip4;
    __u32 dip4;
    __u32 sport;
    __u32 dport;

};//__attribute__((packed)) ; // ne pas oublier packed


/* map compteur de socket mis dans la sockmap */
struct bpf_map_def SEC("maps") tx = {
    .type = BPF_MAP_TYPE_HASH,
    .key_size = sizeof(int),
    .value_size = sizeof(struct sock_key),
    .max_entries = 1,
};

struct bpf_map_def SEC("maps") hmap = {
	.type = BPF_MAP_TYPE_SOCKHASH,
	.key_size = sizeof(struct sock_key),
	.value_size = sizeof(int),
	.max_entries = 20,
};


/* Extraire la clé d'une socket */
static __always_inline 
void h_extract_key(struct bpf_sock_ops *skops, struct sock_key *key)
{
    key->dip4 = skops->remote_ip4;
    key->sip4 = skops->local_ip4;

    key->dport = skops->remote_port ; //  >> 16 à revoir
    key->sport = bpf_ntohl(skops->local_port) ;
}

//efbonfoh :  je ne vois pas l'intérêt de séparer les deux fonctions (dessus - dessous)

/* Extraire la clé de la socket puis l'ajoute à la sockmap */
static __always_inline 
void h_add_hmap(struct bpf_sock_ops *skops)
{
    struct sock_key key = {}; 
    struct sock_key skey = {};  
    int tx_key = 0;

    h_extract_key(skops, &key);
    
    if(key.sport == S_PORT) {
        skey = key;
        bpf_map_update_elem(&tx, &tx_key,&skey, BPF_ANY);
    }
        
    bpf_sock_hash_update(skops, &hmap, &key, BPF_NOEXIST);
}

SEC("sockops")
int bpf_sockops(struct bpf_sock_ops *skops)
{
    __u32 family; 
    //int op = (int)skops->op;
    int key = 0;
    int *value;
    __u32 op = skops->op;

    /* surveillance des connexions socket TCP| uniquement TCP... */
    switch(op){

        case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
        case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:

               /* bpf_printk("ajout d'une socket %i dans la sockmap !\n",
                    skops->local_port); */
                h_add_hmap(skops);
               /* value = bpf_map_lookup_elem(&counter, &key);
                if(value) {
                    *value += 1; 
                    bpf_printk("ajout d'une socket %i dans la sockmap !\n",
                    skops->local_port);
                } */
                       
            
            break;
        default:
            break;
    } 

   

    return 0;
}

// efbonfoh : j'ai dit dans le papier qu'on ajoutait un "extra field" pour gérer les "multithreads" avant cette redirection.
// Je ne vois pas la fonction push() ou le code s'y substituant, je cherche...

/*msg redirection */
SEC("sk_msg")
int bpf_redir(struct sk_msg_md *msg)
{
    __u64 flags = BPF_F_INGRESS;
    __u32 lport, rport;

    struct sock_key hsock_key = {};
    
    
    lport = msg->local_port;
    if(lport == H_PORT){
    
        /*struct sock_key msg_key = {};
        msg_key.dip4 = msg->remote_ip4;
        msg_key.sip4 = msg->local_ip4;
        msg_key.dport = msg->remote_port;
        msg_key.sport =  bpf_ntohl(msg->local_port);

        bpf_map_lookup_elem(&hmap, &msg_key); */
        int tx_key = 0;
        struct sock_key *value = NULL;
        struct sock_key skey = {};
        value = bpf_map_lookup_elem(&tx, &tx_key);
        skey = *value;
        bpf_msg_redirect_hash(msg, &hmap, &skey, flags);
    }
    else {
        bpf_msg_redirect_hash(msg, &hmap, &hsock_key, flags);
    }
    




    

   // __u32 start = 0;
    ///int len = sizeof(struct sock_key);
    //int len = 10;

    //bpf_msg_push_data(msg, start, len, 0);
    //memcpy(msg->data, &hsock_key, len);

    return SK_PASS;
} 




char _license[] SEC("license") = "GPL";
