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

        int cnt_pkt = 0;
        int cnt_bytes = 0;
       
        FILE *rx_file = NULL;
        uint8_t *rcv_data;
        size_t rcv_data_s;

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
        rx_file = fopen("./files-receiver/lion.jpg", "ab");
	if (rx_file == NULL) {
		fprintf(stderr, "ERR: failed to open test file\n");
                exit(EXIT_FAILURE);
	}

        printf("\n");
        printf("Receiving data...");
        rcv_data = (uint8_t *) malloc (DATASIZE * sizeof (uint8_t));
        if (rcv_data == NULL) {
                fprintf (stderr, 
                        "ERR: Cannot allocate memory for snd_data.\n");
                exit(EXIT_FAILURE);
        }
        memset (rcv_data, 0, DATASIZE * sizeof (uint8_t));
        global_exit = false;
        while (!global_exit)
        {
                rcv_data_s = vtl_rcv(vtl_md, rcv_data);
                fwrite(rcv_data, 1, rcv_data_s, rx_file);
                fflush(rx_file);

                cnt_pkt++;
                cnt_bytes += rcv_data_s;

                printf("Recv bytes: %d\r", cnt_bytes);
	        fflush(stdout);
        }
        
        printf("Done\n");
        printf("\n");

        //printf("Nbrs of received packets: %d pkts\n", cnt_pkt);
        printf("Nbrs of received bytes: %d bytes\n", cnt_bytes);
        printf("Loop cnt: %d",cnt_pkt);
        printf("\n");

	fclose(rx_file);




        return 0;
}