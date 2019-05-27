/* 
 *
 * hooker userspace
 * 
*/ 
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <stdarg.h>
#include <mntent.h>
#include <stdbool.h>
#include <signal.h>
#include <fcntl.h>
#include <errno.h>

#include <semaphore.h>
#include <pthread.h>
#include <mqueue.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>
#include <arpa/inet.h>
#include <netdb.h>

#include <sys/ioctl.h>
#include <sys/resource.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <linux/bpf.h>
#include "bpf_load.h"
#include "libbpf.h"


#define HOOKER_BPF_FILENAME        "sockops_kern.o"
#define  CGROUP_PATH            "/test_cgroup"
#define MAXDATASIZE 100

#define SA struct sockaddr

#define PORT 8080
#define H_SERV_PORT 10000
#define S2_PORT 10001
#define H_PORT 10002

#define udpsock1_port       10005
#define udpsock2_port       10006


#define clean_errno() (errno == 0 ? "None" : strerror(errno))
#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)



#define HASH_SIZE   20


#define hash_sock(skey) ( \
( (skey.sport & 0xff) | ((skey.dport & 0xff) << 8) | \
  ((skey.sip4 & 0xff) << 16) | ((skey.dip4 & 0xff) << 24) \
) % HASH_SIZE)



/* globals */
int hserv, hsock, hacpt; // hooker sockets

int udpsock1, udpsock2; // udp sockets

typedef struct sockaddr_in sockaddr_in_t;
sockaddr_in_t udpsock1_to;
sockaddr_in_t udpsock2_to;


char *serv_addr = "127.0.0.1";


//maps
int txid_map, mapping_map, hmap;


// structures
struct sock_key{

    __u32 sip4;
    __u32 dip4;
    __u32 sport;
    __u32 dport;

};

typedef struct _hk_frag hk_frag_t;
struct _hk_frag {

    struct sock_key skey;
    void *payload;
};



// part udp

int udp_config(void)
{   
    struct sockaddr_in addr;
    int err;
    
    // initiate udp sockets
    //udpsock1
    udpsock1 = socket(AF_INET, SOCK_DGRAM, 0);
    if(udpsock1 < 0) {
        perror("creation udpsock1 failed!");
        return errno;
    }

    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(udpsock1_port);
    err = bind(udpsock1, (struct sockaddr *)&addr, sizeof(addr));
    if (err < 0) {
		perror("bind udpsock2 failed");
		return errno;
	}

    //udpsock2
    udpsock2 = socket(AF_INET, SOCK_DGRAM, 0);
    if(udpsock2 < 0) {
        perror("creation udpsock2 failed!");
        return errno;
    }

    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(udpsock2_port);
    err = bind(udpsock2, (struct sockaddr *)&addr, sizeof(addr));
    if (err < 0) {
		perror("bind udpsock2 failed");
		return errno;
	}

    //config udp destination
    
    udpsock1_to.sin_family = AF_INET;
    udpsock1_to.sin_port = htons(udpsock2_port);
    udpsock1_to.sin_addr.s_addr = inet_addr(serv_addr); // TODO : serv addr

    udpsock2_to.sin_family = AF_INET;
    udpsock2_to.sin_port = htons(udpsock1_port);
    udpsock2_to.sin_addr.s_addr = inet_addr(serv_addr); // TODO : serv addr


    return 0;

}

int udp_snd(int sockudp, char *data, sockaddr_in_t to)
{   
    return sendto(sockudp, data, strlen(data), 0,
                (const struct sockaddr *) &to, sizeof(to));
}

int udp_rcv(int sockudp, char *data, sockaddr_in_t from)
{   
    // attention to MAXDATASIZE
    int fromsize = sizeof(from);
    return recvfrom(sockudp, data, MAXDATASIZE, 0 ,
                                (struct sockaddr*)&from, (socklen_t *)&fromsize);

}

// hooker listen to app
int hk_get_data(char *rcv_buf)
{   
    bzero(rcv_buf, sizeof(rcv_buf));
    return recv(hsock, rcv_buf, MAXDATASIZE, 0); //hsock global
}

// hooker send data to app
int hk_snd_data(char *snd_buf)
{
    return send(hsock, snd_buf, strlen(snd_buf), 0);
}

int hk_data_encap(char *snd_buf)
{   
    int ret;
    int id, id_key = 0;
    struct sock_key skey = {}; // inside or outside loop
    hk_frag_t snd_frag;
    
    // retrieve id sock...
    //TODO : make txid_map local
    if((ret = bpf_map_lookup_elem(txid_map, &id_key, &id)) < 0)
    {
        printf("get id sock failed\n");
        return -1;
    }

    printf("encap: id = %d\n", id);

    // get hooker header <=> sock key
    //TODO : make mapping_map local
    ret = bpf_map_lookup_elem(mapping_map, &id, &skey);
    if(ret < 0)
    {
        printf("get skey failed\n");
        return -1;
    }

    // build hooker fragment
    snd_frag.skey = skey;
    snd_frag.payload = snd_buf;

    printf("hk_encap:sport %d   dport %d    sip4 %d    dip4 %d \n",
            snd_frag.skey.sport, snd_frag.skey.dport, 
            snd_frag.skey.sip4, snd_frag.skey.dip4);
    // convert to string for sending purpose. NB: byte order issues possible ??
    snd_buf = (char *)malloc(sizeof(snd_frag));
    memcpy(snd_buf, (hk_frag_t *)snd_buf, sizeof(hk_frag_t));

    return 0;

}

int hk_data_decap(char *snd_buf)
{   
    int ret, id, txid_key = 0;
    hk_frag_t rcv_frag;

    //convert buffer to hooker fragment
    memcpy(&rcv_frag, (hk_frag_t *)snd_buf, sizeof(hk_frag_t));

    printf("hk_decap: sport %d   dport %d    sip4 %d    dip4 %d\n",ntohl(rcv_frag.skey.sport), 
                rcv_frag.skey.dport, rcv_frag.skey.sip4, rcv_frag.skey.dip4);
    //calculate id from sock_key
    id =  hash_sock(rcv_frag.skey);
    printf("decap: id = %d\n", id);

    //send id to msg redirector
    ret = bpf_map_update_elem(txid_map, &txid_key, &id, BPF_EXIST);
    if(ret < 0)
    {
        fprintf(stderr, "update tx_id map failed.\n");
        return -1;
    }

    snd_buf = rcv_frag.payload;
    
    return 0;
}

int hk_init_sock(void)
{
 
    int err, one;
    struct sockaddr_in addr;

    // create redirection socket
    // hooker userspace server
    if((hserv= socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket server failed");
        return errno;
	}

    // redirection socket
    if((hsock = socket(AF_INET, SOCK_STREAM, 0)) == -1){
		perror("socket hooker failed");
        return errno;
	}

    // hooker server configuration
    // Allow reuse
    err = setsockopt(hserv, SOL_SOCKET, SO_REUSEADDR,
                        (char *)&one, sizeof(one));
    if(err) {
        perror("setsockopt server failed");
        return errno;
    }

    // Non-blocking sockets
    err = ioctl(hserv, FIONBIO, (char*)&one); 
    if (err < 0)
    {
            perror("ioctl server failed");
            return errno;
    }

    // Bind server socket
    memset(&addr, 0, sizeof(struct sockaddr_in));
    addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    addr.sin_port = htons(H_SERV_PORT);
	err = bind(hserv, (struct sockaddr *)&addr, sizeof(addr));
	if (err < 0) {
		perror("bind server failed()\n");
		return errno;
	}
    
    // listen server socket
    addr.sin_port = htons(H_SERV_PORT);
	err = listen(hserv, 32);
	if (err < 0) {
		perror("listen server failed()\n");
		return errno;
	}   


    //hooker redirection socket 

    // Bind hsock
    struct sockaddr_in caddr;
    memset(&caddr, 0, sizeof(struct sockaddr_in));
    caddr.sin_family = AF_INET;
	caddr.sin_addr.s_addr = inet_addr("127.0.0.1");
    caddr.sin_port = htons(H_PORT);
	err = bind(hsock, (struct sockaddr *)&caddr, sizeof(caddr));
	if (err < 0) {
		perror("bind socket failed()\n");
		return errno;
	}

    // Initiate Connect 
	addr.sin_port = htons(H_SERV_PORT);
	err = connect(hsock, (struct sockaddr *)&addr, sizeof(addr));
	if (err < 0 && errno != EINPROGRESS) {
		perror("connect socket client failed()\n");
		return errno;
	}

    // accept connection
    hacpt = accept(hserv, NULL, NULL);
	if (hacpt < 0) {
		perror("accept server failed()\n");
		return errno;
	}

    
    return 0;
}


int __hk_listen_app(void)
{
    
    char buf[MAXDATASIZE];
    //char *snd_udp_buf;
    int ret;
    while(1)
    {
            // get data from legacy app ... works!
            //bzero(buf, sizeof(buf));
            ret = hk_get_data(buf);
            if(ret < 0) {
                perror("Get data from app failed\n");
                return errno;
            }

            //printf("message rédirigé: %s\n", buf);
            
            ret = hk_data_encap(buf);
            if(ret < 0)
                exit(1);

            //send over udp
            // sockudp global
            // (1) -> (2) ; (1): client, (2): server
            printf("Thr listen: msg rcv from app: %s\n", buf);
            ret = udp_snd(udpsock1, buf, udpsock1_to);
            if(ret < 0)
            {
                perror("sendto failed\n");
                return errno;
            }
            printf("Thr listen: msg sent over udp\n");
    }
    
           
    return 0;

}

int __hk_sendto_app(void)
{
    // read data from server
    char buf[MAXDATASIZE];
    int ret;
    while(1){
            // receive data from hooker userspace
            bzero(buf, sizeof(buf));
            //(2) <- (1)
            ret = udp_rcv(udpsock2, buf, udpsock1_to);
            if(ret < 0)
            {
                perror("udp_rcv failed\n");
                return errno;
            }
            ret = hk_data_decap(buf);
            printf("Thr sendto: msg rcv over udp: %s\n", buf);
            if (ret < 0)
                exit(1);

            // send read data to legacy app
            ret = hk_snd_data(buf);
            printf("sendto: ret = %d",ret);
            if (ret < 0)
            {
                perror("hooker send data to app failed");
                return errno;
            }
            printf("Thr sendto : msg sent to app\n");
                      
    }
    
    return 0;
}

void *hk_listen(void *arg)
{
    (void) arg;
    __hk_listen_app();
    pthread_exit(NULL);
}

void *hk_sendto(void *arg)
{
    (void) arg;
    __hk_sendto_app();
    pthread_exit(NULL);
}

char *
concat (const char *str, ...) // appel à free sur le résultat.
{
  va_list ap;
  size_t allocated = 100;
  char *result = (char *) malloc (allocated);

  if (result != NULL)
    {
      char *newp;
      char *wp;
      const char *s;

      va_start (ap, str);

      wp = result;
      for (s = str; s != NULL; s = va_arg (ap, const char *))
        {
          size_t len = strlen (s);

          /* Resize the allocated memory if necessary.  */
          if (wp + len + 1 > result + allocated)
            {
              allocated = (allocated + len) * 2;
              newp = (char *) realloc (result, allocated);
              if (newp == NULL)
                {
                  free (result);
                  return NULL;
                }
              wp = newp + (wp - result);
              result = newp;
            }

          wp = mempcpy (wp, s, len);
        }

      /* Terminate the result string.  */
      *wp++ = '\0';

      /* Resize memory to the optimal size.  */
      newp = realloc (result, wp - result);
      if (newp != NULL)
        result = newp;

      va_end (ap);
    }

  return result;
}

char *find_cgroup_root(void)
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

/*void detach_cgroup_root(int sig)
{
    fprintf(stderr,"Removing bpf program...\nExit\n");
	int ret = bpf_prog_detach2(prog_fd[0], cg_fd, BPF_CGROUP_SOCK_OPS);
    if(ret) {

            printf("Failed to detach bpf program\tret = %d\n", ret);
            perror("bpf_prog_attach");          
    }
    close(cg_fd);
    exit(0); 
} */


int hk_inject_bpf(char *bpf_filename)
{
   if (load_bpf_file(bpf_filename)) {
        printf("erreur!");
        fprintf(stderr, "ERR in load_bpf_file(): %s\n", bpf_log_buf);
        return -1;
    } 

    if (!prog_fd[0])  {
        fprintf(stderr, "ERR: load_bpf_file : %s\n", strerror(errno));
        return -1;
    }

    return 0; 
}

int hk_get_cgroup_root_fd(void)
{   
    int cgfd;
    char *cgroup_root_path = find_cgroup_root();
    cgfd = open(cgroup_root_path, O_RDONLY);
	if (cgfd < 0) {
		log_err("Opening Cgroup");
        return -1; // Revoir...
	}
    return cgfd;
}

int hk_init_map(void)
{
  
    __u32 key = 0;
    int value = 0;
    txid_map = map_fd[0];
    if(bpf_map_update_elem(txid_map, &key, &value, BPF_ANY) != 0){
        printf("update  txid_map failed\n");
        return -1;
    }

    // mapping map
    mapping_map = map_fd[1];

    // hmap
    // add redirection socket to sockhash 
    struct sock_key hsock_key = {};  
    hmap = map_fd[2];  
    if(bpf_map_update_elem(hmap, &hsock_key, &hsock, BPF_ANY) != 0) {
        printf("bpf_map_update hsockhash failed\n");
        perror("bpf_map_update"); // TODO : remove ...
        return -1;
    }

    return 0; 
}

int hk_bpf_attach(int *cgfd)
{
    int bpf_sockops = prog_fd[0];
    int bpf_redir = prog_fd[1];
    int ret;

    ret = bpf_prog_attach(bpf_sockops, *cgfd, BPF_CGROUP_SOCK_OPS, 
                                BPF_F_ALLOW_MULTI);
	if(ret) {
            printf("Failed to attach bpf_sockops to cgroup root program\tret = %d\n", ret); // TODO : remove...
            perror("bpf_prog_attach"); 
            return -1;
    } 
    
    ret = bpf_prog_attach(bpf_redir, hmap, BPF_SK_MSG_VERDICT,0);
    if(ret) {
            printf("Failed to attach bpf_redir to sockhash\tret = %d\n", ret); // TODO : remove...
            perror("bpf_prog_attach");
            return -1;
    } 

    return 0;
}

int main(int argc, char*argv[])
{
  
    int cgfd = 0, status = 0;
   

    printf("Loading bpf program in kernel...\n");
    /*if (load_bpf_file(HOOKER_BPF_FILENAME)) {
        printf("erreur!");
        fprintf(stderr, "ERR in load_bpf_file(): %s\n", bpf_log_buf);
        status = -1;
        goto out;
    } 

    if (!prog_fd[0])  {
        fprintf(stderr, "ERR: load_bpf_file : %s\n", strerror(errno));
        status = -1;
        goto out;
    } */
    status = hk_inject_bpf(HOOKER_BPF_FILENAME);
    if(status)
        goto out;
    
    if(hk_init_sock())
        goto out;

    if(udp_config() < 0)
        goto close; // TODO: close sockets udp
    
    
    /* get cgroup root descriptor */
    
    /*char *cgroup_root_path = find_cgroup_root();
    cg_fd = open(cgroup_root_path, O_RDONLY);
	if (cg_fd < 0) {
		log_err("Opening Cgroup");
        status = -1;
		goto out;
	} */

    cgfd = hk_get_cgroup_root_fd();
    if(cgfd < 0)
        goto out;

    status = hk_init_map();
    if(status)
        goto close;

    /* Attach ebpf programs to... */
    
    printf("Attaching bpf program...\n");
    int bpf_sockops = prog_fd[0];
    int bpf_redir = prog_fd[1];
    int ret;

    ret = bpf_prog_attach(bpf_sockops, cgfd, BPF_CGROUP_SOCK_OPS, 
                                BPF_F_ALLOW_MULTI);
	if(ret) {
            printf("Failed to attach bpf_sockops to cgroup root program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status = -1;
            goto err_sockops;
    } 
    
    ret = bpf_prog_attach(bpf_redir, hmap, BPF_SK_MSG_VERDICT,0);
    if(ret) {
            printf("Failed to attach bpf_redir to sockhash\tret = %d\n", ret);
            perror("bpf_prog_attach");
            status = -1;
            goto err_skmsg;
    } 

    /*status = hk_bpf_attach(&cgfd);
    if(status)
        goto err_skmsg; */ // TODO: find a mean...
    


    pthread_t hk_listen_thr;
    pthread_t hk_sendto_thr;

    ret = pthread_create(&hk_listen_thr, NULL, hk_listen, NULL);
    if(ret)
    {
        perror("Erreur pthread d'écoute");
        status = -1;
        goto err_skmsg;
    }
    ret = pthread_create(&hk_sendto_thr, NULL, hk_sendto, NULL);
    if(ret)
    {
        perror("Erreur pthread d'envoi");
        status = -1;
        goto err_skmsg;
    }



    ret = pthread_join(hk_listen_thr, NULL);
    if(ret)
    {
        perror("join listen failed");
        status = -1;
        goto err_skmsg;
    }
    ret = pthread_join(hk_sendto_thr, NULL);
    
    if(ret)
    {
        perror("join sendto failed");
        status = -1;
        goto err_skmsg;
    }

err_skmsg:
    
    printf("Removing bpf_redir program...\nExit\n");
    ret = bpf_prog_detach2(bpf_redir, hmap, BPF_SK_MSG_VERDICT);
    if(ret) {
                printf("Failed to detach bpf_redir program\tret = %d\n", ret);
                perror("bpf_prog_attach");
                status =-1; 
               
    }


err_sockops:  

    printf("Removing bpf program...\nExit\n");
    ret = bpf_prog_detach2(bpf_sockops, cgfd, BPF_CGROUP_SOCK_OPS);
    if(ret) {

                printf("Failed to detach bpf program\tret = %d\n", ret);
                perror("bpf_prog_attach");
                status =-1;        
    }


close:
    close(cgfd); 
    close(hsock);

out: 
    return status;
}



