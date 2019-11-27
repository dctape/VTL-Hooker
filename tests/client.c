/*
 * Client vlt-aware
 * receive data from a server vtl-aware 
 */ 

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>


#include "../api/api.h"


//TODO : Avons-nous besoin de ces données en réception ?
#define SRC_IP          "192.168.130.157"
#define DEV_NAME        "ens33"

static bool global_exit;

static void exit_application(int signal)
{
	signal = signal;
	global_exit = true;
}

int main()
{

        int ret;
        int cnt_pkt = 0;
        int cnt_bytes = 0;
        vtl_md_t vtl_md = {};
        FILE *rx_file = NULL;
        
        uint8_t *rcv_data;
        size_t rcv_data_s;

        /* Global shutdown handler */
	signal(SIGINT, exit_application); 

        printf("Client starting\n");
        ret = vtl_config(&vtl_md, DEV_NAME, SRC_IP);

        /* Ouverture */
        //TODO: change error message
        rx_file = fopen("lion.jpg", "ab");
	if (rx_file == NULL) {
		fprintf(stderr, "ERR: failed to open test file\n");
                exit(EXIT_FAILURE);
	}

        printf("\n");
        printf("Sending data...");
        global_exit = false;
        while (!global_exit)
        {
                rcv_data_s = vtl_rcv(&vtl_md, rcv_data);
                fwrite(rcv_data, 1, rcv_data_s, rx_file);
                fflush(rx_file);

                cnt_pkt++;
                cnt_bytes += rcv_data_s;

                printf("Recv pkt: %d   Recv bytes: %d\r", cnt_pkt, cnt_bytes);
	        fflush(stdout);
        }
        
        printf("Done\n");
        printf("\n");

        printf("Nbrs of received packets: %d pkts\n", cnt_pkt);
        printf("Nbrs of received bytes: %d bytes\n", cnt_bytes);
        printf("\n");

	fclose(rx_file);




        return 0;
}