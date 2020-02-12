/*
 * Client vlt-aware
 * receive data from a server vtl-aware 
 */ 

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <vtl/vtl.h>



#define DATASIZE              1024 // ideal size ? 1024 ? 16k ?

//TODO : Avons-nous besoin de ces données en réception ?
#define SRC_IP          "192.168.130.157" //@vm1 = client
#define DST_IP          "192.168.130.159" //@vm2 = server


#define DEV_NAME         "ens33"

static bool global_exit;

static void exit_application(int signal)
{
	signal = signal;
	global_exit = true;
}

int main(int argc, char const *argv[])
{


        char ifname[] = "ens33";
        char src_ip[] = SRC_IP;

        vtl_md_t *vtl_md;
        char err_buf[VTL_ERRBUF_SIZE];

        /* Global shutdown handler */
	signal(SIGINT, exit_application); 

        printf("Client starting\n");
        int mode = VTL_MODE_IN;
        vtl_md = vtl_init(ifname, src_ip, mode, err_buf);
        if (vtl_md == NULL) {
                fprintf(stderr, "%s", err_buf);
                fprintf(stderr,"ERR: vtl_init failed\n");
                exit(EXIT_FAILURE);

        }

        /* Ouverture */
        //TODO: change error message
        FILE *rx_file = NULL;
        rx_file = fopen("./files-receiver/lion.jpg", "ab");
	if (rx_file == NULL) {
		fprintf(stderr, "ERR: failed to open test file\n");
                exit(EXIT_FAILURE);
	}

        printf("\n");
        printf("Receiving data...");
        global_exit = false;
        while (!global_exit)
        {
                vtl_rcv(vtl_md, rx_file);
                printf("Recv pkt: %d   Recv bytes: %d\r" 
		, vtl_md->cnt_pkts, vtl_md->cnt_bytes);
	        fflush(stdout);
        }
        
        printf("Done\n");
        printf("\n");

        //printf("Nbrs of received packets: %d pkts\n", cnt_pkt);
        // printf("Nbrs of received bytes: %d bytes\n", cnt_bytes);
        // printf("Loop cnt: %d",cnt_pkt);
        printf("\n");

	fclose(rx_file);

        //TODO: vtl_destroy or vtl_close

        return 0;
}