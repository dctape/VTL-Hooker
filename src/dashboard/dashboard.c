
#include <curses.h>
#include <locale.h>
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

static const char *vtl_banner = "VTL Dashboard";
static const char *start_choices[] = {
        "1 - Deploy a Transport Function",
        "2 - Remove a Transport Function",
        "3 - Exit",
};

static const char *tf_choices[] = {
        "1 - Basic TF",
        "2 - ARQ TF",
};

static const char *mode_choices[] = {
        "1 - Input mode (reception ~~ XDP)",
        "2 - Output mode (emission ~~ TC)",
};
struct tr_function {

        int index; /* Index dans le tableau des TFs */
        int mode; /* mode de déploiement */
        char interface[20];

};

struct cursor {

        int posy;
        int posx;
};

/** Dashboard with ncurses **/
void
dashboard_init_ncurses(void)
{
        initscr();
        clear();
        noecho();
        setlocale (LC_CTYPE, "");
        raw();
        curs_set(0);
        if(has_colors() == FALSE)
	{	endwin();
		printf("Your terminal does not support color\n");
		exit(1);
	}
	start_color();
        init_pair(1, COLOR_WHITE, COLOR_BLACK);

}

static WINDOW *
dashboard_init_win(int row, int col, int posy, int posx)
{
        WINDOW *win;
        win = newwin(row, col, posy, posx);
        keypad(win, TRUE);
        refresh();
        return win;
}

static void
print_banner(WINDOW *win, const char *title, int win_col)
{
        int title_y = 1;
        int title_x = (win_col - strlen(title))/2;
        wattron(win, A_BOLD);
        mvwprintw(win, title_y, title_x, title);
        wattroff(win, A_BOLD);
        //wprintw(win, "\n\n");
        wrefresh(win); 


}

static void
dashboard__set_win(WINDOW *win, int col)
{
        box(win, 0, 0);
        print_banner(win, vtl_banner, col);

}

static void
_print_menu(WINDOW *win, const char *choices[], 
                int n_choices, int highlight,
                int pos_y, int pos_x)
{
        int i;
        //int n_choices = sizeof(choices) / sizeof(char *);

        //print_banner(win, title, ncol);

        // item_y = 3;
        // item_x = 2;
        box(win, 0, 0);
        //wattron(win,COLOR_PAIR(1));
        for(i = 0; i < n_choices; ++i)
	{	if(highlight == i + 1) /* High light the present choice */
		{	wattron(win, A_REVERSE); 
			mvwprintw(win, pos_y, pos_x, "%s", choices[i]);
			wattroff(win, A_REVERSE);
                        wrefresh(win);
		}
		else {
                        
                        mvwprintw(win, pos_y, pos_x, "%s", choices[i]);
                        wrefresh(win);
                }
			
		++pos_y;
	}
        //wattroff(win, COLOR_PAIR(1));
        //wrefresh(win);
        

}

int 
print_menu(WINDOW *win, const char *choices[],
                int n_choices ,
                int pos_y, int pos_x)
{
        int key;
        int cur_row = 1;
        _print_menu(win, choices, n_choices, cur_row, pos_y, pos_x);
        do
        {
                key = wgetch(win);
                switch (key)
                {
                case KEY_UP:
			if(cur_row == 1)
				cur_row = n_choices;
			else
				cur_row--;
			break;
                case KEY_DOWN:
			if(cur_row == n_choices)
				cur_row = 1;
			else 
				cur_row++;
			break;
                
                default:
                        // mvwprintw(win,24, 0, "Charcter pressed is = %3d Hopefully it can be printed as '%c'", key, key);
                        // wrefresh(win);
                        break;
                }
                _print_menu(win, choices, n_choices, cur_row, pos_y, pos_x);
        } while (key != '\n' && key != '\r' && key != 459);

        return cur_row;
        
}

int
dashboard__start(WINDOW *win, int ncol)
{
        //Phrase d'introduction
        // int y, x;
        int choice;
        int n_choices = sizeof(start_choices) / sizeof(char *);
        dashboard__set_win(win, ncol);
        mvwprintw(win, 3, 2, "Choose from the options given below");
        choice = print_menu(win, start_choices, n_choices, 4, 4);

        return choice;
}

int 
dashboard__list_tf(WINDOW *win, int ncol)
{
        int choice;
        int n_choices = sizeof(tf_choices) / sizeof(char *);
        dashboard__set_win(win, ncol);
        mvwprintw(win, 3, 2, "Choose a transport function:");
        choice = print_menu(win, tf_choices, n_choices, 4, 4);

        return choice;
}

int 
dashboard__mode(WINDOW *win, int ncol)
{
        int choice;
        int n_choices = sizeof(mode_choices) / sizeof(char *);
        dashboard__set_win(win, ncol);
        mvwprintw(win, 3, 2, "Choose mode:");
        choice = print_menu(win, mode_choices, n_choices, 4, 4);

        
        return choice;

}


static void
_dashboard__interface(WINDOW *win, struct cursor *curs,char *interface, int posy, int posx)
{
        echo();
        

        pcap_if_t *alldevsp, *device;
        char errbuf[100], devs[100][100];
        int count = 1, n;

        //First get the list of available devices
        mvwprintw(win, posy, posx, "Finding available devices ... ");
        if (pcap_findalldevs(&alldevsp, errbuf))
        {
                mvwprintw(win, posy, posx + 31, "Error finding devices : %s", errbuf);
                wrefresh(win);
                exit(1);
        }
        mvwprintw(win, posy, posx + 31, "Done");

        posy++;
        //Print the available devices
        mvwprintw(win, posy, posx, "Available Devices are :");
        posy++;
        posx++;
        for (device = alldevsp; device != NULL; device = device->next)
        {
                mvwprintw(win, posy, posx, "%d. %s - %s\n", count, device->name, device->description);
                if (device->name != NULL)
                {
                        strcpy(devs[count], device->name);
                        posy++;
                }
                count++;
                wrefresh(win);
        }
        posy++;
        posx--;
        curs_set(1);
        mvwprintw(win, posy, posx, "Enter the number of the device you want use : ");
        wrefresh(win);
        mvwscanw(win, posy, posx + 46,"%d", &n);

        strcpy(interface, devs[n]);
        
        // Update cursor
        curs->posy = posy;
        curs->posx = posx;
        noecho();
        curs_set(0);

}

static void
dashboard__interface(WINDOW *win, struct cursor *curs, int ncol, char *interface)
{
        int posy = 3, posx = 2;
        dashboard__set_win(win, ncol);
        _dashboard__interface(win, curs, interface, posy, posx);
}

static int deploy_basic(WINDOW *win, struct cursor *curs,int mode, char *interface)
{
        int ret; //use it

        int y,x;
        y = curs->posy;
        x = curs->posx;

        int xdp_flags = 0;
        struct xdp_config xdp_cfg = {0};
        struct tc_config tc_cfg = {0};

        switch (mode)
        {
        case INPUT_MODE /* xdp */:               

                y++;
                mvwprintw(win, y, x,
                        "Deploying Basic TF on %s interface in input mode...", interface);
                
                //TODO : Put it globals
                xdp_flags &= ~XDP_FLAGS_MODES;   /* Clear flags */
                xdp_flags |= XDP_FLAGS_SKB_MODE; /* Set   flag */             
                ret = launcher__deploy_xdp_xsk(&xdp_cfg, BPF_XDP_FILENAME, interface,
                                       xdp_flags);
                // Call launcher function
                if (ret < 0) {
                        mvwprintw(win, y, x + 51,
                                 "%s", xdp_cfg.err_buf);
                        mvwprintw(win,y + 1, x, "ERR: launcher_deploy_xdp_tf failed");
                        return -1;
                }
                mvwprintw(win, y, x + 51,"Success");

                break;
        
        case OUTPUT_MODE /* Output mode = tc */:
        {
                y++;
                mvwprintw(win, y, x,
                        "Deploying Basic TF on %s interface in output mode...", interface);
                
                //Call launcher function
                ret = launcher__deploy_tc(&tc_cfg, BPF_TC_FILENAME, interface,
                                    TC_EGRESS_ATTACH);
                if (ret < 0) {

                        mvwprintw(win, y, x + 52,
                                 "%s", tc_cfg.err_buf);
                        mvwprintw(win,y + 1, x, "ERR: launcher_deploy_tc_tf failed");
                        return -1;
                }

                mvwprintw(win, y, x + 52,"Success");
                break;
        }
   
                

        default:
                y++;
                mvwprintw(win, y, x, "ERR: unknown mode\n");
                return -1;
                break;
        }

        curs->posy = y;

        return 0;

}

// static int deploy_arq()
// {

// }

static int dashboard__deploy(WINDOW *win, struct cursor *curs,struct tr_function *tf)
{
        int ret = -1;
        switch (tf->index) {
        case BASIC_TF /* index == 1 */ :
                ret = deploy_basic(win, curs,tf->mode, tf->interface);
                break;
        case ARQ_TF : /* index == 2 */
                break;
        default :
                break;
        }

        return ret;
}


static int remove_basic(WINDOW *win, struct cursor *curs,int mode, char *interface)
{
        int ret; 
        int y,x;
        y = curs->posy;
        x = curs->posx;     
        int xdp_flags = 0;
        struct tc_config tc_cfg = {0};

        switch (mode)
        {
        case INPUT_MODE /* xdp */:

                /* Remove tf on selected interface */
                y++;
                mvwprintw(win, y, x,
                        "Removing Basic TF on %s interface in input mode...", interface);
                
                xdp_flags &= ~XDP_FLAGS_MODES;   /* Clear flags */
                xdp_flags |= XDP_FLAGS_SKB_MODE; /* Set   flag */
                ret = launcher__remove_xdp(interface, xdp_flags);
                if (ret < 0) {
                        mvwprintw(win,y + 1, x, "ERR: launcher_remove_xdp_tf failed");
                        fprintf(stderr, "ERR: launcher_remove_xdp_tf failed\n");                        return -1;
                }

                mvwprintw(win, y, x + 51,"Success");

                break;
        
        case OUTPUT_MODE /* tc */:

                /* Remove tf on selected interface */
                y++;
                mvwprintw(win, y, x,
                        "Removing Basic TF on %s interface in output mode...", interface);
                ret = launcher__remove_tc(&tc_cfg, interface, TC_EGRESS_ATTACH);
                if (ret < 0) {
                        mvwprintw(win,y + 1, x, "ERR: launcher_remove_tc_tf failed\n");
                        return -1;
                }

                mvwprintw(win, y, x + 52,"Success");
                break;

        default:
                y++;
                mvwprintw(win, y, x, "ERR: unknown mode\n");
                return -1;
                break;
        }
        curs->posy = y;

        return 0;

}

static int dashboard__remove(WINDOW *win, struct cursor *curs,struct tr_function *tf)
{
        int ret = -1;
        switch (tf->index) {
        case BASIC_TF /* index == 1 */ :
                ret = remove_basic(win, curs,tf->mode, tf->interface);
                break;
        case ARQ_TF : /* index == 2 */
                break;
        default :
                break;
        }

        return ret;

}

int main(int argc, char const *argv[])
{
        int ret;
        int menu_choice;
        struct tr_function tf;

        

        /* Temporary: Call VTL Initializer */
        
        dashboard_init_ncurses();
        int wrow, wcol;
        getmaxyx(stdscr, wrow, wcol);
        
        WINDOW *dash = NULL;
        struct cursor curs = {0};
        dash = dashboard_init_win(wrow, wcol, 0, 0);
        wattron(dash,COLOR_PAIR(1));
        


        do
        {
                // start menu
                //dashboard__set_win(win, wcol);
                menu_choice = dashboard__start(dash, wcol);
  

                switch (menu_choice)
                {
                case 1 /* Deploy TF*/:
                        
                        //TODO: Display TF list
                        wclear(dash); // clear screen before

                        tf.index = dashboard__list_tf(dash, wcol);
                        wclear(dash);

                        tf.mode = dashboard__mode(dash, wcol);
                        wclear(dash);


                        dashboard__interface(dash, &curs,wcol, tf.interface);
                        ret = dashboard__deploy(dash, &curs, &tf);
                        if (ret < 0) {
                                menu_choice = 3;
                                break;
                        }

                        mvwprintw(dash, curs.posy + 3, curs.posx,
                                "Press Enter to return to main menu");
                        wgetch(dash);
                        wclear(dash);

                        break;
                case 2 /* Remove TF */:
                        wclear(dash);

                        tf.mode = dashboard__mode(dash, wcol);
                        wclear(dash);

                        dashboard__interface(dash, &curs, wcol, tf.interface);
                        ret = dashboard__remove(dash, &curs,&tf);
                        if (ret < 0) {
                                menu_choice = 3;
                                break;
                        }
                       
                        mvwprintw(dash, curs.posy + 3, curs.posx,
                                "Press Enter to return to main menu");
                        wgetch(dash);
                        wclear(dash);

                        break;

                case 3 /* program exit */:
                        //Temporary: remove all tf at program exit.
                        printf("Exit program\n");

                        break;

                default:
                        break;
                }

        } while (menu_choice != 3 /* Exit */);
        wattroff(dash, COLOR_PAIR(1));
        delwin(dash);
        endwin();

        return 0;
}