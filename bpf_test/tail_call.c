#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <net/if.h>

#include <linux/if_link.h>

#include <bpf/bpf.h>
#include <bpf/libbpf.h>

#define BPF_XDP_FILENAME        "./bpf/tail_call_kern.o"

/* Exit return codes */
#define EXIT_OK 		 0 /* == EXIT_SUCCESS (stdlib.h) man exit(3) */
#define EXIT_FAIL		 1 /* == EXIT_FAILURE (stdlib.h) man exit(3) */
#define EXIT_FAIL_OPTION	 2
#define EXIT_FAIL_XDP		30
#define EXIT_FAIL_BPF		40
#define EXIT_FAIL_MAP		20

static bool debug = false;
static __u32 prog_id;
 

// static int do_attach(int idx, int fd, const char *name)
// {
// 	struct bpf_prog_info info = {0}; // location linux/bpf.h
// 	__u32 info_len = sizeof(info);
// 	int err;

// 	err = bpf_set_link_xdp_fd(idx, fd, xdp_flags);
// 	if (err < 0) {
// 		printf("ERROR: failed to attach program to %s\n", name);
// 		return err;
// 	}

// 	err = bpf_obj_get_info_by_fd(fd, &info, &info_len);
// 	if (err) {
// 		printf("can't get prog info - %s\n", strerror(errno));
// 		return err;
// 	}
// 	prog_id = info.id;

// 	return err;
// }

static int do_detach(int idx, const char *name)
{
	__u32 curr_prog_id = 0;
	int err = 0;

	err = bpf_get_link_xdp_id(idx, &curr_prog_id, 0);
	if (err) {
		printf("bpf_get_link_xdp_id failed\n");
		return err;
	}
	if (prog_id == curr_prog_id) {
		err = bpf_set_link_xdp_fd(idx, -1, 0);
		if (err < 0)
			printf("ERROR: failed to detach prog from %s\n", name);
	} else if (!curr_prog_id) {
		printf("couldn't find a prog id on a %s\n", name);
	} else {
		printf("program on interface changed, not removing\n");
	}

	return err;
}

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

/* Helper for adding prog to prog_map */
void jmp_table_add_prog(int map_jmp_table_fd, int idx, int bpf_prog_fd)
{
	//int jmp_table_fd = map_fd[map_jmp_table_idx];
	//int prog = prog_fd[prog_idx];
	int err;

	if (bpf_prog_fd == 0) {
		printf("ERR: Invalid zero-FD prog_fd =%d,"
		       " did bpf_load.c fail loading program?!?\n",
		       bpf_prog_fd);
		exit(EXIT_FAIL_MAP);
	}

	err = bpf_map_update_elem(map_jmp_table_fd, &idx, &bpf_prog_fd, 0);
	if (err) {
		// printf("ERR(%d/%d): Fail add prog_fd =%d to jmp_table%d i:%d\n",
		//        err, errno, prog_fd, map_jmp_table_idx+1, idx);
                printf("ERR(%d/%d): Fail add prog_fd =%d to jmp_table i:%d\n",
		       err, errno, bpf_prog_fd, idx);
		exit(EXIT_FAIL_MAP);
	}
	// if (debug) {
	// 	printf("Add XDP prog_fd[%d]=%d to jmp_table%d idx:%d\n",
	// 	       prog_idx, prog, map_jmp_table_idx+1, idx);
	// }
}

static const char *ifname = "ens33";
static int ifindex = -1;

static void int_exit(int sig)
{
	fprintf(stderr,
		"Interrupted: Removing XDP program on ifindex:%d device:%s\n",
		ifindex, ifname);
	if (ifindex > -1)
		do_detach(ifindex, ifname);
	exit(EXIT_OK);
}

static int extract_prog_fd(struct bpf_object *obj, const char *progsec)
{
        struct bpf_program *bpf_prog;
        int prog_fd;
        bpf_prog = bpf_object__find_program_by_title(obj, progsec);
        if (!bpf_prog) {
                fprintf(stderr, "ERR: finding progsec: xdp_entry_point\n");
		exit(EXIT_FAIL_BPF);
        }
        prog_fd = bpf_program__fd(bpf_prog);
        if (prog_fd <= 0) {
		fprintf(stderr, "ERR: bpf_program__fd (%s) failed\n", progsec);
		exit(EXIT_FAIL_BPF);
	}

        return prog_fd;
}

static int extract_map_fd(struct bpf_object *obj, const char *mapname)
{
        int map_fd;
        struct bpf_map *map;
        map = bpf_object__find_map_by_name(obj, mapname);
        map_fd = bpf_map__fd(map);
        if (map_fd < 0) {
                fprintf(stderr, "ERROR: no %s found: %s\n",
				mapname,strerror(map_fd));
			exit(EXIT_FAILURE);
        }

        return map_fd;
}


int main(int argc, char **argv)
{
        int err;
        __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
        
        struct bpf_object *bpf_obj;
        int first_prog_fd;
        struct bpf_prog_load_attr prog_load_attr = {
                .file = BPF_XDP_FILENAME,
                .prog_type = BPF_PROG_TYPE_XDP,
        };

        printf("Chargement du Byte code eBPF\n");
        err = bpf_prog_load_xattr(&prog_load_attr, &bpf_obj, &first_prog_fd);
        if (err) {
		fprintf(stderr, "ERR: loading BPF-OBJ file(%s) (%d): %s\n",
			BPF_XDP_FILENAME, err, strerror(-err));
		exit(EXIT_FAIL_BPF);
	}

        /* Extraction des programmes bpf */
        //xdp_entry_point
        printf("Extraction des programmes bpf et des maps\n");
        int prog_xdp_main = extract_prog_fd(bpf_obj, "xdp_entry_point");

        //xdp_1
        int prog_xdp_1 = extract_prog_fd(bpf_obj, "xdp_1");

        //xdp_5
        int prog_xdp_5 = extract_prog_fd(bpf_obj, "xdp_5");


        /* Extraction des maps */
        int jmp_table1 = extract_map_fd(bpf_obj, "jmp_table1");
        //int jmp_table2 = extract_map_fd(bpf_obj, "jmp_table2");


        /* Ajout des programmes dans les jmp tables */
        
        if (1) {
                jmp_table_add_prog(jmp_table1, 1, prog_xdp_1);
                jmp_table_add_prog(jmp_table1, 5, prog_xdp_5);
        }


        /* Attach XDP program */
        
        ifindex = if_nametoindex(ifname);
        err = xdp_link_attach(ifindex,prog_xdp_main, xdp_flags);
        if (err) {
                fprintf(stderr, "ERR: do_attach(xdp_main_fd) failed\n");
                exit(EXIT_FAIL_XDP);
        }

        /* Remove XDP program when program is interrupted or killed */
	signal(SIGINT,  int_exit);
	signal(SIGTERM, int_exit);

        while (1) {
                printf("En cours de fonctionnement...\r");
        }

        return 0;

}