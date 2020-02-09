/*
 * Client vlt-aware
 * receive data from a server vtl-aware 
 */ 

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/resource.h> // rlimit

#include <vtl/vtl.h>

#define DATASIZE              1024 // ideal size ? 1024 ? 16k ?

//TODO : Avons-nous besoin de ces données en réception ?
#define SRC_IP          "192.168.130.157" //@vm1 = client
#define DST_IP          "192.168.130.159" //@vm2 = server


#define DEV_NAME         "ens33"

static bool global_exit;

static void recv_image_file(uint8_t *data, int size)
{

	static FILE *rx_file = NULL;
	
	rx_file = fopen("lion.jpg", "ab");
	if (rx_file == NULL) {
		fprintf(stderr, "ERR: failed to open test file\n");
                exit(EXIT_FAILURE);
	}

	fwrite(data, 1, size, rx_file);
	fflush(rx_file);

	fclose(rx_file);

}

static void exit_application(int signal)
{
	signal = signal;
	global_exit = true;
}

int main(int argc, char const *argv[])
{


        char ifname[] = "ens33";
        char src_ip[] = SRC_IP;
        int ret;

        vtl_md_t *vtl_md;
        char err_buf[VTL_ERRBUF_SIZE];

        struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
        if (setrlimit(RLIMIT_MEMLOCK, &r)) {
		perror("setrlimit(RLIMIT_MEMLOCK)");
		return 1;
	}

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

        printf("\n");
        printf("Receiving data...");
        /* vtl listen*/
        ret = vtl_listen(vtl_md);
        if (ret < 0) {
                fprintf(stderr, "ERR: vtl_listen failed\n");
                exit(EXIT_FAILURE);
        }

        uint8_t buf[DATASIZE];
        ssize_t data_len;
        global_exit = false;
        while (!global_exit) {

                data_len = vtl_rcv_perf(vtl_md, buf, DATASIZE);
                recv_image_file(buf, data_len);
                printf("Recv pkt: %d   Recv bytes: %d\r" 
		, vtl_md->cnt_pkts, vtl_md->cnt_bytes);
	        fflush(stdout);
                
        }
        
        printf("Done\n");
        printf("\n");
        vtl_listen_stop(vtl_md);
        //TODO : perf_buffer__free(pb);




        //printf("Nbrs of received packets: %d pkts\n", cnt_pkt);
        // printf("Nbrs of received bytes: %d bytes\n", cnt_bytes);
        // printf("Loop cnt: %d",cnt_pkt);
       

        return 0;
}