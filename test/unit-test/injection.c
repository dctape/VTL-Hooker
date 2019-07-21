
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define PCKT_LEN	8192

struct vtlhdr{

	int value;
	//TODO: add other members according use cases
};

int main(int argc, char **argv)
{   
    char *test_payload = "Test pour voir si ça marche !!!";

    //TODO: use a better way to find the good size
    char *vtl_pkt = (char *)malloc(PCKT_LEN);
	memset(vtl_pkt, 0, PCKT_LEN);
	struct vtlhdr *vtl_hdr1 = (struct vtlhdr *)vtl_pkt;
    vtl_hdr1->value = 10;

    int vtlhdr_len = sizeof(struct vtlhdr);
    
    struct vtlhdr *vtl_hdr2 = (struct vtlhdr *)vtl_pkt;
	char *vtl_payload = (char *)(vtl_pkt + vtlhdr_len);

    memcpy(vtl_payload, test_payload, strlen(test_payload));

    printf("vtl_hdr->value: %d, vtl_payload : %s\n",vtl_hdr2->value, vtl_payload);

    /* write packet with libnet or raw sockets */


    free(vtl_pkt);

    return 0;
    
}