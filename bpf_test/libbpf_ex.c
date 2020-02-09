#include <errno.h>
#include <net/if.h>
#include <stdlib.h> //exit()
#include <string.h>
#include <unistd.h>

#include <linux/if_link.h>

#include <bpf/bpf.h>
#include <bpf/libbpf.h>

#define BPF_XDP_FILENAME        "./bpf/xdp_basic.o"

/* Exit return codes */
#define EXIT_OK 		 0 /* == EXIT_SUCCESS (stdlib.h) man exit(3) */
#define EXIT_FAIL		 1 /* == EXIT_FAILURE (stdlib.h) man exit(3) */
#define EXIT_FAIL_OPTION	 2
#define EXIT_FAIL_XDP		30
#define EXIT_FAIL_BPF		40


static int xdp_link_detach(int ifindex, __u32 xdp_flags)
{
        int err;

        if ((err = bpf_set_link_xdp_fd(ifindex, -1, xdp_flags)) < 0) {
		fprintf(stderr, "ERR: link set xdp unload failed (err=%d):%s\n",
			err, strerror(-err));
		return EXIT_FAIL_XDP;
	}
	return EXIT_OK;
}

static int xdp_link_attach(int ifindex,int prog_fd, __u32 xdp_flags)
{
        int err;

        err = bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags);
        if (err == -EEXIST && !(xdp_flags & XDP_FLAGS_UPDATE_IF_NOEXIST)) {
		/* Force mode didn't work, probably because a program of the
		 * opposite type is loaded. Let's unload that and try loading
		 * again.
		 */

		__u32 old_flags = xdp_flags;

		xdp_flags &= ~XDP_FLAGS_MODES;
		xdp_flags |= (old_flags & XDP_FLAGS_SKB_MODE) ? XDP_FLAGS_DRV_MODE : XDP_FLAGS_SKB_MODE;
		err = bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
		if (!err)
			err = bpf_set_link_xdp_fd(ifindex, prog_fd, old_flags);
	}

        if (err < 0) {
		fprintf(stderr, "ERR: "
			"ifindex(%d) link set xdp fd failed (%d): %s\n",
			ifindex, -err, strerror(-err));

		switch (-err) {
		case EBUSY:
		case EEXIST:
			fprintf(stderr, "Hint: XDP already loaded on device"
				" use --force to swap/replace\n");
			break;
		case EOPNOTSUPP:
			fprintf(stderr, "Hint: Native-XDP not supported"
				" use --skb-mode or --auto-mode\n");
			break;
		default:
			break;
		}
		return EXIT_FAIL_XDP;
	}

	return EXIT_OK;


}

int load_bpf_object_file__simple(const char *filename) // filename == _kern.o
{
        int first_prog_fd = -1;
        struct bpf_object *bpf_obj;
        int err;

        /*
         * bpf_prog_load convertit le filename en un objet bpf.
         * fixe le type de tous les programmes contenus dans le filename
         * à BPF_PROG_TYPE_XDP
         * Et charge l'objet dans le noyau et
         * retourne un pointeur vers cet objet et un autre pointeur
         * vers le premier programme eBPF.
         * 
         */ 
        err = bpf_prog_load(filename,BPF_PROG_TYPE_XDP, &bpf_obj, &first_prog_fd);
        if (err) {
		fprintf(stderr, "ERR: loading BPF-OBJ file(%s) (%d): %s\n",
			filename, err, strerror(-err));
		return -1;
	}

        /* Simply return the first program file descriptor.
	 * (Hint: This will get more advanced later)
	 */
	return first_prog_fd;
}

struct bpf_object * __load_bpf_object_file(const char *filename, int ifindex)
{
        int first_prog_fd = -1;
        struct bpf_object *bpf_obj;
        int err;

        struct bpf_prog_load_attr prog_load_attr = {
                .prog_type = BPF_PROG_TYPE_XDP,
        };
        prog_load_attr.file = filename;

        /* Use libbpf for extracting BPF byte-code from BPF-ELF object, and
	 * loading this into the kernel via bpf-syscall
	 */
        err = bpf_prog_load_xattr(&prog_load_attr, &bpf_obj, &first_prog_fd);
        if (err) {
		fprintf(stderr, "ERR: loading BPF-OBJ file(%s) (%d): %s\n",
			filename, err, strerror(-err));
		return NULL;
	}

	/* Notice how a pointer to a libbpf bpf_object is returned */
	return bpf_obj;


}

static void list_avail_progs(struct bpf_object *obj)
{
	struct bpf_program *pos;

	printf("BPF object (%s) listing avail --progsec names\n",
	       bpf_object__name(obj));

	bpf_object__for_each_program(pos, obj) {
		if (bpf_program__is_xdp(pos))
			printf(" %s\n", bpf_program__title(pos, false));
	}
}

int main (int argc, char **argv)
{
        int err;
        const char *ifname = "ens33";
        __u32 xdp_flags = XDP_FLAGS_SKB_MODE;

        struct bpf_object *bpf_obj;
        int ifindex = if_nametoindex(ifname);

        int xdp_prog_fd;

        printf("Chargement du programme XDP dans le noyau.\n");
        // xdp_prog_fd = load_bpf_object_file__simple(BPF_XDP_FILENAME);

        // if (xdp_prog_fd < 0) {
        //         fprintf(stderr, "ERR: load_bpf_object_file__simple failed\n");
        //         return EXIT_FAIL;
        // }

        /* Extraction et injection du BPF_BYTE code du filename. Retourne un objet bpf */
        const char *bpf_file = BPF_XDP_FILENAME;
        bpf_obj = __load_bpf_object_file(bpf_file, ifindex);
        if (!bpf_obj) {
                fprintf(stderr, "ERR: loading file: %s\n", BPF_XDP_FILENAME);
		exit(EXIT_FAIL_BPF);
        }

        /* Récupération du programme à attacher */
        struct bpf_program *bpf_prog;
        char progsec[] = "xdp";
        bpf_prog = bpf_object__find_program_by_title(bpf_obj, progsec);
        if (!bpf_prog) {
		fprintf(stderr, "ERR: finding progsec: %s\n", progsec);
		exit(EXIT_FAIL_BPF);
	}
        xdp_prog_fd = bpf_program__fd(bpf_prog);
        if (xdp_prog_fd  <= 0) {
		fprintf(stderr, "ERR: bpf_program__fd failed\n");
		exit(EXIT_FAIL_BPF);
	}




        printf("Attachage du programme XDP au hook XDP.\n");
        
        err = xdp_link_attach(ifindex, xdp_prog_fd, xdp_flags);
        if (err) {
                fprintf(stderr, "ERR: xdp_link_attach failed (err=%d):%s\n",
                        err, strerror(-err));
                return EXIT_FAIL;
        }

       
        int nb_sec = 60;
        printf("Sleep for %d sec\n", nb_sec);
        sleep(nb_sec);

        printf("Retrait du programme XDP du hook XDP\n");
        err = xdp_link_detach(ifindex, xdp_flags);
        if (err) {
                fprintf(stderr, "ERR: xdp_link_detach failed (err=%d):%s\n",
                        err, strerror(-err));
                return EXIT_FAIL;

        }

        return 0;
        
}