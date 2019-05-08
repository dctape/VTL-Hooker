
//#include <uapi/linux/bpf.h>
#include <linux/bpf.h>
#include "bpf_helpers.h"
#include "bpf_endian.h"

#define SOCKOPS_MAP_SIZE            20 // augmenter jusqu'à 65535

#define bpf_printk(fmt, ...)					\
({								\
	       char ____fmt[] = fmt;				\
	       bpf_trace_printk(____fmt, sizeof(____fmt),	\
				##__VA_ARGS__);			\
}) 

/*structure clé socket */
struct sock_key{

    __u32 sip4;
    __u32 dip4;
    __u32 sport;
    __u32 dport;

} ;


/* map compteur de socket mis dans la sockmap */
struct bpf_map_def SEC("maps") counter = {
    .type = BPF_MAP_TYPE_HASH,
    .key_size = sizeof(int),
    .value_size = sizeof(int),
    .max_entries = 1,
};

struct bpf_map_def SEC("maps") sockhash= {
	.type = BPF_MAP_TYPE_SOCKHASH,
	.key_size = sizeof(struct sock_key),
	.value_size = sizeof(int),
	.max_entries = 20,
};

struct bpf_map_def SEC("maps") sockhash2= {
	.type = BPF_MAP_TYPE_SOCKHASH,
    .key_size = sizeof(int),
	.value_size = sizeof(int),
	.max_entries = 20,
};

/* Extraire la clé d'une socket */
static __always_inline 
void sk_extract_key(struct bpf_sock_ops *skops, struct sock_key *key)
{
    key->dip4 = skops->remote_ip4;
    key->sip4 = skops->local_ip4;

    key->dport = skops->remote_port ; //  >> 16 à revoir
    key->sport = bpf_ntohl(skops->local_port) ;
}

//efbonfoh :  je ne vois pas l'intérêt de séparer les deux fonctions (dessus - dessous)

/* Extraire la clé de la socket puis l'ajoute à la sockmap */
static __always_inline 
void sk_add_map(struct bpf_sock_ops *skops)
{
    struct sock_key key = {};
    
    sk_extract_key(skops, &key);
    bpf_sock_hash_update(skops, &sockhash, &key, BPF_NOEXIST);
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
                sk_add_map(skops);
                value = bpf_map_lookup_elem(&counter, &key);
                if(value) {
                    *value += 1; 
                    bpf_printk("ajout d'une socket %i dans la sockmap !\n",
                    skops->local_port);
                }
                       
            
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
    struct sock_key redir_key = {};

    /* redirection de l'application legacy vers le hooker userspace */
    bpf_msg_redirect_hash(msg, &sockhash, &redir_key, flags);
    return SK_PASS;
} 




char _license[] SEC("license") = "GPL";
