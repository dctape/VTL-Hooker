/*
 *
 * hooker ebpf program : redirector.
 *  
 * 
*/

//#include <uapi/linux/bpf.h>

#include <stdbool.h>
#include <linux/bpf.h>
#include "bpf/bpf_helpers.h"
#include "bpf/bpf_endian.h"



#define bpf_printk(fmt, ...)                               \
        ({                                                 \
                char ____fmt[] = fmt;                      \
                bpf_trace_printk(____fmt, sizeof(____fmt), \
                                 ##__VA_ARGS__);           \
        })


#define SERVER_PORT          9091
#define CLIENT_PORT          9092
#define HOOKER_REDIR_PORT    10002
#define HOOKER_SERV_PORT     10000

#define LEGMAP_SIZE     64 // arbritrary number

struct sock_key{

    __u32 sip4;
    __u32 dip4;
    __u32 sport;
    __u32 dport;

};

struct sock_cookie {
	__u64 key;
};


struct bpf_map_def SEC("maps") LEG_APP_MAP = {
        .type = BPF_MAP_TYPE_SOCKHASH,
        .key_size = sizeof(struct sock_key),
        .value_size = sizeof(int) ,
        .max_entries = LEGMAP_SIZE
};

struct bpf_map_def SEC("maps") LEG_ADDR_MAP = {
        .type = BPF_MAP_TYPE_HASH,
        .key_size = sizeof(struct sock_key),
        .value_size = sizeof(struct sock_cookie),
        .max_entries = LEGMAP_SIZE
};

struct bpf_map_def SEC("maps") SK_STORAGE_MAP = {
        .type = BPF_MAP_TYPE_SK_STORAGE,
        .key_size = sizeof(int),
        .value_size = sizeof(struct sock_cookie),
        .map_flags = BPF_F_NO_PREALLOC
};



void legapp_register(struct bpf_sock_ops *skops)
{

        struct sock_cookie cookie = {0};
    
        
        struct sock_key skey = {0};
        skey.dip4 = skops->remote_ip4;
        skey.sip4 = skops->local_ip4;
        skey.dport = skops->remote_port;
        skey.sport = bpf_htonl(skops->local_port);

        
        cookie.key = bpf_get_socket_cookie(skops);
        
        /* 1- save addr */
        bpf_map_update_elem(&LEG_ADDR_MAP, &skey, &cookie, BPF_ANY);

        /* 2- save app in sockmap */
        bpf_sock_hash_update(skops, &LEG_APP_MAP, &skey, BPF_NOEXIST);
}

SEC("sockops")
int hooker_monitor(struct bpf_sock_ops *skops)
{
        /* add passive or active established socket  to hooker sockhash  */

        __u32 op = skops->op;

        switch (op)
        {

        case BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB: // pas la peine d'ajouter tous les sockets
        case BPF_SOCK_OPS_ACTIVE_ESTABLISHED_CB:
                bpf_printk("legacy app registered\n");
                legapp_register(skops);

                break;

        default:
                break;
        }

        return 0;
}

SEC("sk_msg")
int hooker_redirector(struct sk_msg_md *msg) // TODO : use a better name...
{
        
        
        
        __u64 flags = BPF_F_INGRESS;
        __u32 lport;
        
        lport = msg->local_port; // ok


        if (lport == HOOKER_REDIR_PORT) {
                /* Redirection vers les applications legacy */

                
                

        }
        else {
                // Redirection vers le Hooker
                
                /* récupération du cookie de l'application */
                struct sock_cookie *cookie;

                struct sock_key skey = {0};
                struct sock_key hkey = {0}; // sock_key for hooker

                skey.dip4 = msg->remote_ip4;
                skey.sip4 = msg->local_ip4;
                skey.dport = msg->remote_port;
                skey.sport = bpf_htonl(msg->local_port);

                cookie = bpf_map_lookup_elem(&SK_STORAGE_MAP, &skey);
                if (!cookie)
                        return SK_DROP;
                
                /* Ajout du cookie aux données */
                //void *data_end = (void *)(long)msg->data_end;
                void *data = (void *)(long)msg->data;
                bpf_msg_push_data(msg, 0, sizeof(cookie->key), 0);
                __builtin_memcpy(data, &cookie->key, sizeof(cookie->key));

                /* redirection vers le hooker */
                bpf_msg_redirect_hash(msg, &LEG_APP_MAP, &hkey, flags);
        }     

        // switch (lport)
        // {

        // case PORT_SOCK_REDIR:
        //         // hooker userpace -> app
        //         bpf_printk("hooker -> app\n");

        //         //retrieve sock_key client
        //         int key = 0;
        //         sock_key_t *value;
        //         sock_key_t c_skey = {};
        //         value = bpf_map_lookup_elem(&sock_key_map, &key); // pas optimal
        //         if (!value)
        //                 return SK_DROP;
        //         c_skey = *value;

        //         //redirect data to app
        //         bpf_msg_redirect_hash(msg, &hooker_map, &c_skey, flags);
        //         break;

        // case PORT_CLIENT_TCP:

        //         // app client -> hooker userspace
        //         bpf_msg_redirect_hash(msg, &hooker_map, &hsock_key, flags);
        //         break;

        // default:
        //         break; //optional
        // }

        return SK_PASS;
}

char _license[] SEC("license") = "GPL";