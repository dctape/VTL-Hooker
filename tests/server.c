/*
 * Serveur  vtl-aware
 *  send numerous datas towards a client
 */ 

#include <stdio.h>
#include <stdlib.h>

//TODO: change to <api/api.h>
#include "../api/api.h"

#define DATASIZE              1024 // ideal size ? 1024 ? 16k ?

#define SRC_IP          "192.168.130.158"
#define DST_IP          "192.168.130.157"


#define DEV_NAME                                "ens33"

int main()
{
        int ret;
        int cnt_pkt = 0;
        int cnt_bytes = 0;

        vtl_md_t vtl_md = {};
        FILE *tx_file = NULL;
        uint8_t *snd_data;
        size_t snd_data_s; 

        printf("Server starting\n");

        /* Configurer l'objet vtl */
        // déterminer l'interface d'envoi de données
        // l'adresse ip src

        ret = vtl_config(&vtl_md, DEV_NAME, SRC_IP);

        /* Ouverture du fichier de test */
        // TODO: close test_file
        tx_file = fopen("../files-sender/lion.jpg", "rb"); // or ../files/file.txt
        if (tx_file == NULL){
                fprintf(stderr, "ERR: failed to open test file\n");
                exit(EXIT_FAILURE);
        }

        printf("\nSending data...");

        while (!feof(tx_file))
        {
                snd_data_s = fread(snd_data, 1, DATASIZE, tx_file);
                ret = vtl_snd(&vtl_md, SRC_IP, snd_data, snd_data_s);
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
