#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <pcap.h>

void select_interface(char *interface)
{
        pcap_if_t *alldevsp, *device;
        char errbuf[100], devs[100][100];
        int count = 1, n;

        //First get the list of available devices
        printf("Finding available devices ... ");
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
                printf("%d. %s - %s\n", count, device->name, device->description);
                if (device->name != NULL)
                {
                        strcpy(devs[count], device->name);
                }
                count++;
        }
        //Ask user which device to use
        printf("Enter the number of the device you want use : ");
        scanf("%d", &n);
        
        //interface = devs[n];
        strcpy(interface, devs[n]);
}

int main()
{
        char interface[512];

        select_interface(interface);
        printf("\nselected interface : %s - size: %ld\n",interface
                , strlen(interface));
        
        
        /* clear input buffer */
        int c;
        while ((c = getchar()) != '\n' && c != EOF) { }

        printf("Press enter to continue\n");
        int enter = 0;
        while (enter != '\r' && enter != '\n') { enter = getchar(); }
        printf("Thank you for pressing enter\n");

        // printf("Press Enter to Continue");
        // getchar();
        // // while( getchar() != '\n' );

        return 0;
}