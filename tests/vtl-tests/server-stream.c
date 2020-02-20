/*
 * Serveur  vtl-aware
 *  send numerous datas towards a client
 */ 

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//TODO: change to <api/api.h>
#include <vtl.h>

#define DATASIZE              1024 // ideal size ? 1024 ? 16k ?

#define SRC_IP          "192.168.130.159" //@vm2
#define DST_IP          "192.168.130.157" //@vm1


#define DEV_NAME         "ens33"


int main(int argc, char const *argv[])
{
        int ret;
        int cnt_pkt = 0;
        int cnt_bytes = 0;
        
        FILE *tx_file = NULL;
        uint8_t *snd_data;
        size_t snd_data_s;

        char ifname[] = "ens33";
        char src_ip[] = SRC_IP;
        char dst_ip[] = DST_IP;
        char target[] = DST_IP; //redondant

        vtl_md_t *vtl_md;
        char err_buf[VTL_ERRBUF_SIZE];

        

        printf("Server starting\n");

        /* VTL Preparation */ 
        int mode = VTL_MODE_OUT;
        struct vtl_socket *sock;
        sock = vtl_create_socket(mode, ifname, err_buf);
        if (sock) {
                fprintf(stderr, "%s\n", err_buf);
                fprintf(stderr, "ERR: vtl_create_socket failed\n");
                exit(EXIT_FAIL);
        }
        
        /* Configure endpoint */
        struct vtl_endpoint server = {0};
        vtl_add_interface(&server, ifname);
        vtl_add_ip4(&server, src_ip);

        /* Waiting connexions */
        //vtl_accept();

        /* listen over a channel */
        // For now, call vtl_open_channel server side or client side
        struct vtl_channel *ch = NULL;
        


        /* Configurer l'objet vtl */
        // déterminer l'interface d'envoi de données
        // l'adresse ip src
        
        vtl_md = vtl_init(ifname, src_ip, mode, err_buf);
        if (vtl_md == NULL) {
                fprintf(stderr, "%s", err_buf);
                fprintf(stderr,"ERR: vtl_init failed\n");
                exit(EXIT_FAILURE);

        }

        /* Ouverture du fichier de test */
        // TODO: close test_file
        tx_file = fopen("./files-sender/lion.jpg", "rb"); // or ../files/file.txt
        if (tx_file == NULL){
                fprintf(stderr, "ERR: failed to open test file\n");
                exit(EXIT_FAILURE);
        }

        printf("\nSending data...");
        snd_data = (uint8_t *) malloc (DATASIZE * sizeof (uint8_t));
        if (snd_data == NULL) {
                fprintf (stderr, 
                        "ERR: Cannot allocate memory for snd_data.\n");
                exit(EXIT_FAILURE);
        }
        memset (snd_data, 0, DATASIZE * sizeof (uint8_t));

        while (!feof(tx_file))
        {
                snd_data_s = fread(snd_data, 1, DATASIZE, tx_file);
                ret = vtl_snd(vtl_md, target, dst_ip, snd_data, snd_data_s, err_buf);
                if (ret < 0) {
                        fprintf(stderr,"%s",err_buf);
                        fprintf(stderr,"vtl_snd failed\n");
                        exit(EXIT_FAILURE);
                }
                cnt_pkt++;
                cnt_bytes += snd_data_s;
        }
        printf("Done\n\n");
  
        printf("Nbrs of sent packets: %d pkts\n", cnt_pkt);
        printf("Nbrs of sent bytes: %d bytes\n\n", cnt_bytes);

        /* Close test file  */
        fclose(tx_file);
        // TODO: destroy vtl_md...      

        return 0;
}
