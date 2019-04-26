/*
 * Programme comptant le nombre de paquets reçus par protocole
 * de niveau 4. Objectif : voir l'impact(performance) de programme XDP 
 * sur le bon fonctionnement des applications.
 * 
 */

#define KBUILD_MODNAME "foo"
#include <uapi/linux/bpf.h>
#include <uapi/linux/if_ether.h>
#include <uapi/linux/if_packet.h>
#include <uapi/linux/ip.h>
#include <uapi/linux/in.h>
#include <uapi/linux/tcp.h>
#include "bpf_helpers.h"


struct bpf_map_def SEC("maps") tcp_cnt = {
        .type = BPF_MAP_TYPE_HASH,
        .key_size = sizeof(u32),
        .value_size = sizeof(long),
        .max_entries = 1  // Un nombre trop grand  peut ne pas être permis par le kernel (??)
};

struct bpf_map_def SEC("maps") udp_cnt = {
        .type = BPF_MAP_TYPE_HASH,
        .key_size = sizeof(u32),
        .value_size = sizeof(long),
        .max_entries = 1  // Un nombre trop grand  peut ne pas être permis par le kernel (??)
};

struct bpf_map_def SEC("maps") pkt_cnt = {
        .type = BPF_MAP_TYPE_HASH,
        .key_size = sizeof(u32),
        .value_size = sizeof(long),
        .max_entries = 1  // Un nombre trop grand  peut ne pas être permis par le kernel (??)
};

/* Parse Ethernet layer 2, extract network layer 3 offset and protocol
 *
 * Returns false on error and non-supported ether-type
 */

/* Faire une sorte d'initialisation d'abord */

static  __always_inline
bool parse_eth(struct ethhdr *eth, void *data_end, 
                u16 *eth_proto, u64 *l3_offset)
{
    u16 eth_type;
    u64 offset;

    offset = sizeof(*eth);
    if((void *)eth + offset > data_end) // Données corrompues ??
            return false;
    
    eth_type = eth->h_proto;


    /* Skip non 802.3 Ethertypes */

    if(unlikely(ntohs(eth_type) < ETH_P_802_3_MIN))
            return false;
    
    /* TODO: Handle VLAN tagged packet */

    /* TODO: Handle double VLAN tagged packet */

    *eth_proto = ntohs(eth_type);
    *l3_offset = offset;
    return true;
}

static __always_inline
u32 parse_ipv4(struct xdp_md *ctx, u64 l3_offset) // Pourquoi passer struct xdp_md *ctx ??
{
    void *data_end = (void *)(long)ctx->data_end;
	void *data     = (void *)(long)ctx->data;

    struct iphdr *iph = data + l3_offset;
    u8 ipproto; // u32 ? u8 ? u64 ?
    u32 key = 0;
    long *value = 0;
    /* Valid IPv4 packet */
    if(iph + 1 > data_end)
    {
        //bpf_debug("Invalid IPv4 packet: L3off:%llu\n", l3_offset);
		return XDP_ABORTED;
    }

    /* extract protocol */
    /* TODO: compter ou mettre à jour les maps */
    ipproto = ntohs(iph->protocol);
    switch (ipproto) //DEBUG: eBPF VM ne permet pas iph->protocol
    {
        case 6:
            value = bpf_map_lookup_elem(&udp_cnt, &ipproto);
            if(value)
                //__sync_fetch_and_add((long *)value, 1);
                *value += 1;
            break;
        
        case 17:
            value = bpf_map_lookup_elem(&tcp_cnt, &ipproto);
            if(value)
                //__sync_fetch_and_add((long *)value, 1);
                *value += 1; 
            break;

        default:
            value = bpf_map_lookup_elem(&pkt_cnt, &key);
            if(value)
                 //__sync_fetch_and_add((long *)value, 1);
                *value += 1;
            break;
    }

    return XDP_PASS;
}

static __always_inline
u32  handle_eth_protocol(struct xdp_md *ctx, u16 eth_proto, u64 l3_offset)
{
    switch (eth_proto)
    {
        case ETH_P_IP:
            return parse_ipv4(ctx, l3_offset);
            break;
        
        case ETH_P_IPV6:  /* Not handler for IPv6 yet */
        case ETH_P_ARP: /* Let OS handle ARP */
    
        default:
            return XDP_PASS;
            break;
    }
    return XDP_PASS;
}




SEC("xdp_counter_l4proto")
int xdp_counter_l4proto_program(struct xdp_md *ctx){

    void *data_end = (void *)(long)ctx->data_end;
    void *data     = (void *)(long)ctx->data; // Pourquoi long ?
    struct ethhdr *eth = data;
    u16 eth_proto = 0;
    u64 l3_offset = 0;
    u32 action;

    if(!parse_eth(eth, data_end, &eth_proto, &l3_offset))
        return XDP_PASS; /* Skip */ 
    
    action = handle_eth_protocol(ctx, eth_proto, l3_offset);
    
    return action;

}

char _license[] SEC("license") = "GPL";