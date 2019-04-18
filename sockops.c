#include <linux/bpf.h>
/* programme sockops */



/*structure clé socket */
struct sock_key{

    __u32 sip4;
    __u32 dip4;
    __u32 sport;
    __u32 dport;

};

/* Extraire la clé d'une socket */
static inline
void sk_extract_key(struct bpf_sock_ops *skops, struct sock_key *key)
{
    key->dip4 = skops->remote_ip4;
    key->sip4 = skops->local_ip4;

    key->dport = skops->remote_port  >> 16; // à revoir
    key->sport = (bpf_ntohl(skops->local_port)  >> 16);
}


/* Extraire la clé de la socket puis l'ajoute à la sockmap */
static inline
void sk_select(struct bpf_sock_ops *skops)
{
    struct sock_key key = {};

    sk_extract_key(skops, &key);
    

}

int sockops(struct bpf_sock_ops * skops)
{
    __u32 family, op;

    family = skops->family;
    op = skops->op;

    /* surveillance des connexions socket TCP| uniquement TCP... */
    switch(op){

        case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB:
        case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:

            break;
        default:
            break;
    }

    return 0;
}