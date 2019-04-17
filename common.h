/*
 *
 * complément à libbcc
 * 
*/
#include <linux/bpf.h>
#include <netinet/in.h> 
#include <netinet/ip_icmp.h>

// Define the Packet Constants 
// ping packet size 
#define PING_PKT_S 64 

// Automatic port number 
#define PORT_NO 0 

// Automatic port number 
#define PING_SLEEP_RATE 1000000 

// Gives the timeout delay for receiving packets 
// in seconds 
#define RECV_TIMEOUT 1 




// ping packet structure 
struct ping_pkt 
{ 
	struct icmphdr hdr; 
	char msg[PING_PKT_S-sizeof(struct icmphdr)]; 
}; 

int bpf_prog_attach(int progfd, int target_fd, enum bpf_attach_type type, 
					unsigned int flags);
int bpf_prog_detach(int target_fd, enum bpf_attach_type type);
int bpf_prog_detach2(int prog_fd, int target_fd, enum bpf_attach_type type);

unsigned short checksum(void *b, int len);
char *dns_lookup(char *addr_host, struct sockaddr_in *addr_con);
char* reverse_dns_lookup(char *ip_addr);
void send_ping(int ping_sockfd, struct sockaddr_in *ping_addr, 
				char *ping_dom, char *ping_ip, char *rev_host);