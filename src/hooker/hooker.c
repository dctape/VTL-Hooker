/**
 * hooker userspace program
 * 
 **/ 

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <semaphore.h>
#include <pthread.h>
#include <mqueue.h>

#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/ioctl.h>
#include <sys/socket.h>

#include <linux/bpf.h>
#include <bpf/bpf.h>
#include <bpf/libbpf.h>

//#include "../common/cgroup_helpers.h"
#include "../../include/vtl.h"

#define BPF_HOOKER_FILENAME     "../bpf/bpf_hooker.o"
// Mettre cette structure dans un header
struct sock_key{

    __u32 sip4;
    __u32 dip4;
    __u32 sport;
    __u32 dport;

};

int map_fd[2];
struct bpf_map *maps[2];
char *map_names[] = {
        "SOCK_MAP",
        "COOKIE_MAP",
};
int prog_fd[2];

int prog_type[] = {
        BPF_PROG_TYPE_SOCK_OPS,
        BPF_PROG_TYPE_SK_MSG,
};

int prog_attach_type[] = {
        BPF_CGROUP_SOCK_OPS,
        BPF_SK_MSG_VERDICT,
};

static int load_bpf_progs(char *bpf_file)
{
        struct bpf_progam *prog;
        struct bpf_object *obj;
        int i = 0;
        long err;
        // Conversion 
        obj = bpf_object__open(bpf_file);
        err = libbpf_get_error(obj);
        if (err) {
                char err_buf[256];

                libbpf_strerror(err, err_buf, sizeof(err_buf));
                printf("Unable to load eBPF objects in file '%s' : %s\n",
		       bpf_file, err_buf);
		return -1;
        }

        bpf_object__for_each_program(prog, obj) {
                bpf_program__set_type(prog,prog_type[i]);
                bpf_program__set_expected_attach_type(prog,
                                                      prog_attach_type[i]);
                i++;
                
        }
        i = bpf_object__load(obj); // Trop bizarre
        /* Récupérer les fd de chaque programmes chargés */
        i = 0;
        bpf_object__for_each_program(prog, obj) {
                prog_fd[i] = bpf_program__fd(prog);
                i++;
        }

        /* Récupérer les descripteurs de chaque map chargés */
        for (i = 0; i < sizeof(map_fd)/sizeof(int); i++) {
                map_fd[i] = bpf_object__find_map_fd_by_name(obj, map_names[i]);
                //map_fd[i] = bpf_map__fd(maps[i]);
                if (map_fd[i] < 0) {
                        fprintf(stderr, "load_bpf_file: (%i) %s\n",
				map_fd[i], strerror(errno));
			return -1;
                }

        }

        return 0;
}

/* Initialise les sockets utilisés durant la redirection */
// Informations partagées avec hooker_kern
// Les mettre dans un fichier de config
#define HOOKER_REDIR_PORT    10002
#define HOOKER_SERV_PORT     10000
#define MAX_DATA_SIZE           1024 // TODO : Find the good size...
struct sock_cookie {
	__u64 key;
};


int sock_server;
int sock_redir;
int hooker_init_sock(void)
{   
        int hacpt;
        
        int err, one;
        struct sockaddr_in addr;
        
        // create redirection socket
        // hooker userspace server
        if((sock_server= socket(AF_INET, SOCK_STREAM, 0)) == -1){
                        perror("socket server failed");
                return errno;
                }

        // redirection socket
        if((sock_redir = socket(AF_INET, SOCK_STREAM, 0)) == -1){
                        perror(" Creation of hooker redirection socket failed");
                return errno;
                }

        // hooker server configuration
        // Allow reuse
        err = setsockopt(sock_server, SOL_SOCKET, SO_REUSEADDR,
                                (char *)&one, sizeof(one));
        if(err) {
                perror("setsockopt sock server failed");
                return errno;
        } 

        // Non-blocking sockets
        err = ioctl(sock_server, FIONBIO, (char*)&one); 
        if (err < 0)
        {
                perror("ioctl server failed");
                return errno;
        }

        // Bind server socket
        memset(&addr, 0, sizeof(struct sockaddr_in));
        addr.sin_family = AF_INET;
        addr.sin_addr.s_addr = inet_addr("0.0.0.0");
        addr.sin_port = htons(HOOKER_SERV_PORT);
                err = bind(sock_server, (struct sockaddr *)&addr, sizeof(addr));
                if (err < 0) {
                        perror("bind server failed()\n");
                        return errno;
                }
        
        // listen server socket
        addr.sin_port = htons(HOOKER_SERV_PORT);
                err = listen(sock_server, 32);
                if (err < 0) {
                        perror("listen server failed()\n");
                        return errno;
                }   


        //hooker redirection socket 

        // Bind sock_redir
        struct sockaddr_in caddr;
        memset(&caddr, 0, sizeof(struct sockaddr_in));
        caddr.sin_family = AF_INET;
                caddr.sin_addr.s_addr = inet_addr("127.0.0.1");
        caddr.sin_port = htons(HOOKER_REDIR_PORT);
                err = bind(sock_redir, (struct sockaddr *)&caddr, sizeof(caddr));
                if (err < 0) {
                        perror("bind socket failed()\n");
                        return errno;
                }

        // Initiate Connect 
                addr.sin_port = htons(HOOKER_SERV_PORT);
                err = connect(sock_redir, (struct sockaddr *)&addr, sizeof(addr));
                if (err < 0 && errno != EINPROGRESS) {
                        perror("connect socket client failed()\n");
                        return errno;
                }

        // accept connection
        hacpt = accept(sock_server, NULL, NULL);
                if (hacpt < 0) {
                        perror("accept server failed()\n");
                        return errno;
                }

        
        return 0;
}

int _recv_from_app(char *buf)
{
        return recv(sock_redir, buf, MAX_DATA_SIZE, 0);
}

/**
 * fonction récupérant les données des applications legacy
 * 
 */ 
int recv_from_app(char *buf)
{
        int numbytes; // TODO : change name later...

        memset(buf, 0, sizeof(buf));
        numbytes = _recv_from_app(buf);
        if(numbytes < 0) {
                perror("Adapter failed to get data from Redirector");
                return errno;
        }
        buf[numbytes] = '\0'; // Important afin d'éviter 
                                 //l'apparition de données étrangères  
                                 //lors de la lecture.
        return 0;
}

#define IFNAME  "ens33"
#define IP_SRC  "192.168.43.148"

struct vtl_endpoint local = {
        .hostname = IFNAME,
        .in_addr = IP_SRC,
};
struct vtl_socket *vtl_sock;

void *hooker__send(void *arg) 
{
        /* Réception des datas venant des applications legacy */

        /* Envoyer les données via l'API VTL */
        int numBytes, err;
	char *io_buffer;
	char hk_buf[MAX_DATA_SIZE];
        struct sock_cookie *cookie;
        struct sock_key skey = {0};
        struct vtl_endpoint remote;
        struct vtl_channel *ch;
        char *err_buf;

	//io_buffer = (char *)malloc(MAX_DATA_SIZE);
	while (1)
	{
		/* Réception à partir de hooker_redir des datas + cookie  */
		numBytes = recv_from_app(hk_buf); // hk_buf = cookie + user_data
		if(numBytes < 0){ // TODO: change this later...
			free(io_buffer); 
			return NULL;
		}
		fprintf(stderr,"Redirector : %s", hk_buf); // for tests

                /* Accéder au cookie */
                cookie = (struct sock_cookie *)hk_buf;

                /* Récupérer l'adresse de destination à partir du cookie */
                bpf_map_lookup_elem(map_fd[1], cookie, &skey);
                vtl_add_ip4(&remote, skey.dip4);

                /* Pointeur vers les données utiles */
                io_buffer = (char *)(cookie + 1);

                /* Ouverture de canal de communication == pas optimal */
                ch = vtl_open_channel(vtl_sock, &local, &remote, 
                                        VTL_LOCAL_NOTFILL, err_buf);
                
                if (!ch) {
                        fprintf(stderr, "ERR : vtl_open_channel failed : %s\n", err_buf);
                        return NULL;
                }
                
                /* send data through api vtl to host */	
                err = vtl_send(vtl_sock, ch, io_buffer, strlen(io_buffer), err_buf);
                if (err) {
                        fprintf(stderr, "ERR: vtl_send failed : %s\n", err_buf);
                        return NULL;
                }
                fprintf(stderr,"data sent : %s", io_buffer);
                fprintf(stderr,"numBytes sent : %d", numBytes);

                //memset ??

			
		
	}
}

int _send_to_app(char *buf)
{
        return send(sock_redir, buf, strlen(buf), 0);
}

/**
 * Envoi les datas vers les applications legacy
 **/ 
int send_to_app(char *buf)
{
        int ret;
        ret = _send_to_app(buf);
        if(ret < 0) {
                perror("Adapter failed to send data to Redirector");
                return errno;
        }

        return ret;
}

int hooker__recv_cb(void *ctx, uint8_t *data, uint32_t data_size) 
{

        int err;	
        err = send_to_app(data);
        if (err) {
                fprintf(stderr, "ERR: send_to_app failed\n");
                return -1;
        }
}

void *hooker__recv(void *arg)
{
        struct vtl_recv_params rp = {
                .recv_cb = hooker__recv_cb,
        };
        vtl_receive(vtl_sock, &rp);
}

/** cgroup helpers **/
/* retourne le chemin du cgroup root */
char 
*find_cgroup_root(void)  // pas nécessaire
{
	struct mntent *mnt;
	FILE *f;

	f = fopen("/proc/mounts", "r");
	if(f == NULL)
		return NULL;
	while ((mnt = getmntent(f))) {
		if(strcmp(mnt->mnt_type, "cgroup2") == 0) {
			fclose(f);
			return strdup(mnt-> mnt_dir);
		}
	}

	fclose(f);
	return NULL;
}

/* récupère le descripteur du cgroup root   */
int 
get_cgroup_root_fd(void)
{   
    int cgfd;
    char *cgroup_root_path = find_cgroup_root();
    cgfd = open(cgroup_root_path, O_RDONLY);
	if (cgfd < 0) {
		// TODO: Améliorer le code d'erreur
		log_err("Opening Cgroup");
        	return -1;
	}
    return cgfd;
}

int main(int argc, char const *argv[])
{
        
        /* Charger bpf_hooker dans le noyau */
        printf("Test load bpf progs\n");
        int err = 0;
        int hk_monitor_fd, hk_redir_fd;
        int sock_map_fd, cookie_map_fd;
        char *bpf_file = BPF_HOOKER_FILENAME; // Pourquoi dois-je le faire ainsi ?
        err = load_bpf_progs(bpf_file);
        if (err < 0) {
                fprintf(stderr, "ERR: (%i) load bpf failed\n", err);
		goto out;
        }
        // TODO : find another way
        hk_monitor_fd = prog_fd[0];
        hk_redir_fd = prog_fd[1];
        sock_map_fd = map_fd[0];
        cookie_map_fd = map_fd[1];
        
        /* Récupérer le descripteur du cgroup root */
        int cgfd;
        cgfd = get_cgroup_root_fd();
        if (cgfd < 0) {
                fprintf (stderr, "ERR: open root cgroup failed\n");
                err = -1;
                goto out;
        }

        /* initialiser les différentes sockets */
        err = hooker_init_sock();
        if (err) {
                fprintf(stderr, "ERR: hooker init sockets failed\n");
                goto out;
        }

        /* Attacher les différents programmes du hooker */
        /* Attach redirector_skmsg program */
        err = bpf_prog_attach(hk_redir_fd, sock_map_fd, BPF_SK_MSG_VERDICT,0);
        if(err) {   
                perror("Attach redirector to hooker map failed\n");
                goto close;
        }

        /* add redirection socket to hooker_map */
        struct sock_key sock_redir_key = {0};   
        if(bpf_map_update_elem(sock_map_fd, &sock_redir_key, &sock_redir, BPF_ANY) != 0) {
                perror("Add redirection socket failed\n"); // TODO : remove ...
                // Retirer hooker_redir
                bpf_prog_detach2(hk_redir_fd, sock_map_fd, BPF_SK_MSG_VERDICT);
                goto close;
        }

        /* attach redirector_sockops program */
        err = bpf_prog_attach(hk_monitor_fd, cgfd, BPF_CGROUP_SOCK_OPS, 
                                        BPF_F_ALLOW_MULTI);
                if(err) {
                perror("Failed to attach redirector to cgroup root\n");
                bpf_prog_detach2(hk_redir_fd, sock_map_fd, BPF_SK_MSG_VERDICT);
                goto close;
        }

        // Création des threads pour l'envoi et la réception
        pthread_t th_snd;
        pthread_t th_rcv;

        err = pthread_create(&th_snd, NULL, hooker__send, NULL);
        if (err != 0) {
            perror("Error creation of adapter send thread");
            goto detach; // don't forget  err =...
        }

        err = pthread_create(&th_rcv, NULL, hooker__recv, NULL);
        if(err != 0){
            perror("Error creation of adapter recv thread");
            goto detach; // don't forget  err =...
        }
        // Retirer hooker_monitor
detach :
        /* wait created threads */
        err = pthread_join(th_snd, NULL);
        err = pthread_join(th_rcv, NULL);
        bpf_prog_detach2(hk_monitor_fd, cgfd ,BPF_CGROUP_SOCK_OPS);
close :
        close(sock_redir);
        close(sock_server);
        close(cgfd);
out:
        return err;
}
