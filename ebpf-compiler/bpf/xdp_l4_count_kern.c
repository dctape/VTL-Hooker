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
#include <uapi/linux/ipv6.h>
#include <linux/if_vlan.h>  // Pour traiter les paquets "vlan"
#include <uapi/linux/in.h>
#include <uapi/linux/tcp.h>
#include "bpf_helpers.h"

struct bpf_map_def SEC("maps") rxcnt = {
    .type = BPF_MAP_TYPE_HASH,
    .key_size = sizeof(u32),
    .value_size = sizeof(long),
    .max_entries = 256,
};  // Préférable d'optimiser l'utilisation des maps.

static __always_inline
int parse_ipv4(void *data, u64 l3_offset, void *data_end)
{
    struct iphdr *iph = data + l3_offset;

    if (iph + 1 > data_end)
        return 0; 
    return iph->protocol;
}

static __always_inline 
int parse_ipv6(void *data, u64 l3_offset, void *data_end)
{
    struct ipv6hdr *ip6h = data + l3_offset;

    if (ip6h + 1 > data_end)
        return 0;
    return ip6h->nexthdr;
}

static __always_inline
void count(int ipproto)
{
    u64 *value;
    switch (ipproto)
    {
        case IPPROTO_UDP:
            value = bpf_map_lookup_elem(&rxcnt, &ipproto);
            if(value)
                //__sync_fetch_and_add((long *)value, 1);
                *value += 1;
            break;
        
        case IPPROTO_TCP:
            value = bpf_map_lookup_elem(&rxcnt, &ipproto);
            if(value)
                //__sync_fetch_and_add((long *)value, 1);
                *value += 1;
            break;

        case IPPROTO_ICMP:
            value = bpf_map_lookup_elem(&rxcnt, &ipproto);
            if(value)
                //__sync_fetch_and_add((long *)value, 1);
                *value += 1;
            break;
        default:
            break;
    }
    ipproto = 0; // Pour le nombre total de paquet traité
    value = bpf_map_lookup_elem(&rxcnt, &ipproto);
            if(value)
                //__sync_fetch_and_add((long *)value, 1);
                *value += 1;
}

/* TODO : améliorer le code */
/*static __always_inline
u32  handle_eth_protocol(struct xdp_md *ctx, u16 eth_proto, u64 l3_offset)
{
    
    switch (eth_proto)
    {
        case :
            
            break;
    
        default:
            break;
    }
} */

SEC("xdp_l4_count")
int xdp_l4_count_program(struct xdp_md *ctx)
{
    void *data_end = (void *)(long)ctx->data_end;
    void *data = (void *)(long)ctx->data;
    struct ethhdr *eth = data;
    u16 eth_proto;
    u64 l3_offset;
    u32 ipproto;

    //long *value;

    l3_offset = sizeof(*eth);
    if(data + l3_offset > data_end)
        return XDP_ABORTED;
    
    eth_proto = eth->h_proto;

    if(eth_proto == htons(ETH_P_8021Q) || eth_proto == htons(ETH_P_8021AD))
    {
        struct vlan_hdr *vhdr;

        vhdr = data + l3_offset;
        l3_offset += sizeof(struct vlan_hdr);
        if(data + l3_offset > data_end)
            return XDP_ABORTED;
        eth_proto = vhdr->h_vlan_encapsulated_proto;
    }

    if(eth_proto == htons(ETH_P_IP))
    {
        ipproto = parse_ipv4(data, l3_offset, data_end);
        count(ipproto);
    }   
    else if(eth_proto == htons(ETH_P_IPV6))
    {
        ipproto = parse_ipv6(data, l3_offset, data_end);
        count(ipproto);
    }  
   /* TODO: Gérer les paquets ARP */
          
    return XDP_PASS;
    
}
char _license[] SEC("license") = "GPL";
