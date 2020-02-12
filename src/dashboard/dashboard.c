
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include <pcap.h>

#include <linux/if_link.h> //for xdp_flags

#include "../launcher/launcher.h"

#define BASIC_TF        1
#define ARQ_TF          2

#define BPF_TC_FILENAME         "../src/bpf/bpf_tc.o"
#define BPF_XDP_FILENAME        "../src/bpf/bpf_xdp.o"
#define BPF_ARQ_FILENAME        "../src/bpf/bpf_arqin.o"

#define INPUT_MODE             0x1
#define OUTPUT_MODE            0x2
#define INOUT_MODE             0x3     

struct tr_function {

        int index; /* Index dans le tableau des TFs */
        int mode; /* mode de déploiement */
        char interface[20];

};

int dashboard__start(void)
{
        int choice;
        printf("\n\tVTL Dashboard\n\n");
        printf("Choose from the options given below\n");
        printf("->> 1- Deploy a Transport Function\n");
        printf("->> 2- Remove a Transport Function\n"); // display deployed transport function
        printf("->> 3- Exit VTL Dashboard\n\n");

        printf("Enter your choice: ");
        scanf("%d", &choice);

        return choice;

}

int dashboard__list_tf(void)
{
        int choice;
        printf("\n\tVTL Dashboard\n\n");
        printf("Choose a transport function:\n");
        printf("->> 1- Basic TF\n");
        printf("->> 2- ARQ TF\n\n");
        
        //3- return to menu start

        printf("Enter your choice: ");
        scanf("%d", &choice);

        return choice;

}

int dashboard__mode(void)
{
        int choice;
        printf("\n\tVTL Dashboard\n\n");
        printf("Choose mode:\n");
        printf("->> 1- Input mode (reception ~~ XDP)\n");
        printf("->> 2- Output mode (emission ~~ TC)\n\n");
        
        //3- return to menu start

        printf("Enter your choice: ");
        scanf("%d", &choice);

        return choice;

}




static void dashboard__interface(char *interface)
{
        pcap_if_t *alldevsp, *device;
        char errbuf[100], devs[100][100];
        int count = 1, n;

        //First get the list of available devices
        printf("\nFinding available devices ... ");
        if (pcap_findalldevs(&alldevsp, errbuf))
        {
                printf("Error finding devices : %s", errbuf);
                exit(1);
        }
        printf("Done");

        //Print the available devices
        printf("\nAvailable Devices are :\n");
        for (device = alldevsp; device != NULL; device = device->next)
        {
                printf("->> %d. %s - %s\n", count, device->name, device->description);
                if (device->name != NULL)
                {
                        strcpy(devs[count], device->name);
                }
                count++;
        }
        //Ask user which device to use
        printf("\nEnter the number of the device you want use : ");
        scanf("%d", &n);
        strcpy(interface, devs[n]);
}

static void populate_tf_array(char *tab)
{
       tab[1] = BPF_TC_FILENAME;
       tab[2] = BPF_XDP_FILENAME;
       tab[3] = BPF_ARQ_FILENAME;
        
}

static int deploy_basic(int mode, char *interface)
{
        int ret; //use it

        int xdp_flags = 0;
        struct xdp_config xdp_cfg = {0};
        struct tc_config tc_cfg = {0};

        switch (mode)
        {
        case INPUT_MODE /* xdp */:               

                printf("\n\nDeploying Basic TF on %s interface in input mode...", interface);
                
                //TODO : Put it globals
                xdp_flags &= ~XDP_FLAGS_MODES;   /* Clear flags */
                xdp_flags |= XDP_FLAGS_SKB_MODE; /* Set   flag */             
                ret = launcher__deploy_xdp_xsk(&xdp_cfg, BPF_XDP_FILENAME, interface,
                                       xdp_flags);
                // Call launcher function
                if (ret < 0) {
                        fprintf(stderr, "%s", xdp_cfg.err_buf);
                        fprintf(stderr, "ERR: launcher_deploy_xdp_tf failed\n");
                        return -1;
                }
                printf("Success\n");

                break;
        
        case OUTPUT_MODE /* Output mode = tc */:
        {

                printf("\n\nDeploying Basic TF on %s interface in output mode...", interface);
                
                //Call launcher function
                ret = launcher__deploy_tc(&tc_cfg, BPF_TC_FILENAME, interface,
                                    TC_EGRESS_ATTACH);
                if (ret < 0) {
                        fprintf(stderr, "%s", tc_cfg.err_buf);
                        fprintf(stderr, "ERR: launcher_deploy_tc_tf failed\n");
                        return -1;
                }

                printf("Success\n");
                break;
        }
   
                

        default:
                fprintf(stderr, "ERR: unknown mode\n");
                return -1;
                break;
        }

        return 0;

}

static int deploy_arq()
{

}

static int dashboard__deploy(struct tr_function *tf)
{
        int ret;
        switch (tf->index) {
        case BASIC_TF /* index == 1 */ :
                return deploy_basic(tf->mode, tf->interface);
                break;
        case ARQ_TF : /* index == 2 */
                break;
        default :
                break;
        }

}


static int remove_basic(int mode, char *interface)
{
        int ret; //use it      
        int xdp_flags = 0;
        struct tc_config tc_cfg = {0};

        switch (mode)
        {
        case INPUT_MODE /* xdp */:
                /* code */

                /* Remove tf on selected interface */
                printf("\n\nDeploying Basic TF on %s interface in input mode...", interface);
                
                xdp_flags &= ~XDP_FLAGS_MODES;   /* Clear flags */
                xdp_flags |= XDP_FLAGS_SKB_MODE; /* Set   flag */
                ret = launcher__remove_xdp(interface, xdp_flags);
                if (ret < 0) {
                        fprintf(stderr, "ERR: launcher_remove_xdp_tf failed\n");
                        return -1;
                }

                printf("Success\n");

                break;
        
        case OUTPUT_MODE /* tc */:

                /* select interface */
                select_interface(interface);

                /* Remove tf on selected interface */
                printf("\n\nRemoving Basic TF on %s interface in output mode...", interface);              
                ret = launcher__remove_tc(&tc_cfg, interface, TC_EGRESS_ATTACH);
                if (ret < 0) {
                        fprintf(stderr, "ERR: launcher_remove_tc_tf failed\n");
                        return -1;
                }

                printf("Success\n");
                break;

        default:
                fprintf(stderr, "ERR: unknown mode\n");
                return -1;
                break;
        }

        return 0;

}

static int dashboard__remove(struct tr_function *tf)
{
        int ret;
        switch (tf->index) {
        case BASIC_TF /* index == 1 */ :
                return remove_basic(tf->mode, tf->interface);
                break;
        case ARQ_TF : /* index == 2 */
                break;
        default :
                break;
        }

}

static void clear_screen(void)
{
    //system("cls||clear");
    system("clear");
}


int main(int argc, char const *argv[])
{
        int ret;

        int menu_choice;
        int mode;
        char enter = 0;
        char c;

        struct tr_function tf;

        /* Temporary: Call VTL Initializer */
        
        clear_screen();

        do
        {
                // start menu
                menu_choice = menu_start();
                clear_screen();

                switch (menu_choice)
                {
                case 1 /* Deploy TF*/:
                        
                        //TODO: Display TF list
                        
                        tf.index = dashboard__list_tf();
                        tf.mode = dashboard__mode();
                        dashboard__interface(tf.interface);
                        ret = dashboard__deploy(&tf);
                        if (ret < 0) {
                                menu_choice = 3;
                                break;
                        }

                        printf("Do you return to main menu or exit ? (M or E)\n");
                        scanf("%c", &c);
                        if (c == 'E') {
                                menu_choice = 3;
                        }
  
                        clear_screen();

                        break;
                case 2 /* Remove TF */:
                        tf.mode = dashboard__mode();
                        dashboard__interface(tf.interface);
                        ret = dashboard__remove(&tf);
                        if (ret < 0) {
                                menu_choice = 3;
                                break;
                        }
                       
                        printf("Do you return to main menu or exit ? (M or E)\n");
                        scanf("%c", &c);
                        if (c == 'E') {
                                menu_choice = 3;
                        }
                         
                        clear_screen();

                        break;

                case 3 /* program exit */:
                        //Temporary: remove all tf at program exit.
                        printf("Exit program\n");

                        break;

                default:
                        break;
                }

        } while (menu_choice != 3 /* Exit */);


        return 0;
}