
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include <pcap.h>

#include <linux/if_link.h> //for xdp_flags

#include "../launcher/launcher.h"

#define BPF_TC_FILENAME         "../bpf/bpf_tc.o"
#define BPF_XDP_FILENAME        "../bpf/bpf_xdp.o"

int menu_start(void)
{
        int choice;
        printf("\n\tKTF Orchestrator menu\n\n");
        printf("Choose from the options given below\n");
        printf("->> 1- Deploy TF\n");
        printf("->> 2- Remove TF\n");
        printf("->> 3- Exit KTF Orchestrator\n\n");

        printf("Enter your choice: ");
        scanf("%d", &choice);

        return choice;

}

int menu_mode(void)
{
        int choice;
        printf("\n\tKTF Orchestrator\n\n");
        printf("Choose mode:\n");
        printf("->> 1- Input mode (reception ~~ XDP)\n");
        printf("->> 2- Output mode (emission ~~ TC)\n\n");
        
        //3- return to menu start

        printf("Enter your choice: ");
        scanf("%d", &choice);

        return choice;

}

void select_interface(char *interface)
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

void deploy_tf(int mode)
{
        int ret; //use it
        char interface[20];
        switch (mode)
        {
        case 1 /* Input mode = xdp */:

                /* select interface */
                select_interface(interface);
                
                /* deploy tf on selected interface */
                printf("\n\nDeploying TF on %s interface in input mode...", interface);
                struct xdp_config xdp_cfg = {};
                int xdp_flags;
                xdp_flags &= ~XDP_FLAGS_MODES;   /* Clear flags */
                xdp_flags |= XDP_FLAGS_SKB_MODE; /* Set   flag */
                ret = launcher_deploy_xdp_tf(&xdp_cfg, BPF_XDP_FILENAME, interface,
                                       xdp_flags);
                printf("Success\n");

                break;

        case 2 /* Output mode = tc */:
                /* select interface */
                select_interface(interface);

                /* deploy tf on selected interface */
                printf("\n\nDeploying TF on %s interface in output mode...", interface);
                struct tc_config tc_cfg = {};
                ret = launcher_deploy_tc_tf(&tc_cfg, BPF_TC_FILENAME, interface,
                                    TC_EGRESS_ATTACH);
                printf("Success\n");

                break;

        default:
                break;
        }

        return;
}

void remove_tf(int mode)
{
        int ret; //use it
        char interface[20];
    
        switch (mode)
        {
        case 1 /* Input mode = xdp */:
                /* code */

                /* select interface */
                select_interface(interface);

                /* Remove tf on selected interface */
                printf("\n\nDeploying TF on %s interface in input mode...", interface);
                struct xdp_config xdp_cfg = {};
                int xdp_flags;
                xdp_flags &= ~XDP_FLAGS_MODES;   /* Clear flags */
                xdp_flags |= XDP_FLAGS_SKB_MODE; /* Set   flag */
                ret = launcher_remove_xdp_tf(&xdp_cfg, interface, xdp_flags);

                printf("Success\n");


                break;
        
        case 2 /* Output mode = tc */:

                /* select interface */
                select_interface(interface);

                /* Remove tf on selected interface */
                printf("\n\nRemoving TF on %s interface in output mode...", interface);
                struct tc_config tc_cfg = {};
                ret = launcher_remove_tc_tf(&tc_cfg, interface, TC_EGRESS_ATTACH);

                printf("Success\n");
                break;

        default:
                break;
        }

}

void clear_screen()
{
    //system("cls||clear");
    system("clear");
}

int main()
{
        int ret;
        int c;

        int menu_choice;
        int mode;
        char enter = 0;

        clear_screen();

        do
        {
                // start menu
                menu_choice = menu_start();
                clear_screen();

                /* clear input buffer */
                while ((c = getchar()) != '\n' && c != EOF) { } 

                switch (menu_choice)
                {
                case 1 /* Deploy TF*/:
                        
                        //TODO: Display TF list
                        mode = menu_mode();
    
                        deploy_tf(mode);

                        /* clear input buffer */
                        while ((c = getchar()) != '\n' && c != EOF) { }

                        printf("\nPress Enter to return to menu start\n");
                        while (enter != '\r' && enter != '\n') { enter = getchar(); }
  
                        clear_screen();

                        break;
                case 2 /* Remove TF */:
                        mode = menu_mode();
                        remove_tf(mode);

                        /* clear input buffer */
                        while ((c = getchar()) != '\n' && c != EOF) { } 

                        printf("\nPress Enter to return to menu start\n");                      
                        while (enter != '\r' && enter != '\n') { enter = getchar(); }
                        
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