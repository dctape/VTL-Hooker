
#include <errno.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include <linux/err.h>

#include <bpf/bpf.h>
#include <bpf/libbpf.h>

#define BPF_TC_FILENAME              "./bpf/tc_kern.o"
#define BPF_XDP_FILENAME             "./bpf/xdp_kern.o"

/* paramétrage commmande tc */
#define CMD_MAX 	2048
#define CMD_MAX_TC	256
static char tc_cmd[CMD_MAX_TC] = "tc";

struct bpf_cnt
{
        int xdp_cnt;
        int tc_cnt;
        int tot_cnt;
};

int verbose = 1; /* extern in common_user.h */

struct bpf_object *
load_xdp_object_file(const char *filename, int ifindex);
struct bpf_object *
open_xdp_object(const char *file, int ifindex);

int tc_ingress_attach_bpf(const char* dev, const char* bpf_obj,
			 const char* sec_name);

int main(int argc, char const *argv[])
{
        int ret;
        struct bpf_program *prog;
        struct bpf_map *tc_map;
        //création de la map partagée
        int sd_map_fd = bpf_create_map(BPF_MAP_TYPE_ARRAY, 
                                sizeof(int), sizeof(struct bpf_cnt), 2, 0);
        if (sd_map_fd < 0) {
                printf("Failed to create map: %d (%s)\n", sd_map_fd, strerror(errno));
                return -1;
        }

	/* Récupération de la map de map ~ TC */
        struct bpf_object *bpf_obj;
        bpf_obj = bpf_object__open(BPF_TC_FILENAME);
        tc_map = bpf_object__find_map_by_name(bpf_obj, "tc_map");
        if (IS_ERR(tc_map)) {
		printf("Failed to load array of maps from test prog\n");
		exit(EXIT_FAILURE);
	}

	/* set inner map fd */
        ret = bpf_map__set_inner_map_fd(tc_map, sd_map_fd);
        if (ret != 0) {
		printf("Failed to set inner_map_fd for array of maps: '%s'\n", strerror(errno));
		exit(EXIT_FAILURE);
	}

	/* Ajout de la shared_map dans la map de map (tc_map)  */
	int tc_map_fd;
	tc_map_fd = bpf_map__fd(tc_map);
	/*if (tc_map_fd < 0) {
		printf("Failed to get descriptor for array of maps\n");
		exit(EXIT_FAILURE);
	} */
	int pos = 0;
	ret = bpf_map_update_elem(tc_map_fd, &pos, &sd_map_fd, 0);
	if (ret) {
		printf("Failed to update array of maps\n");
		exit(EXIT_FAILURE);
	}

        //Chargement des programmes eBPF
        char *ifname = "ens33";
        //char *bpf_tc_filename;
        /* tc */
        char *sec_name = "tc_count";
        tc_ingress_attach_bpf(ifname, BPF_TC_FILENAME, sec_name);

        /* xdp */
        struct bpf_object *xdp_obj;

        //mis à jour des différents programmes eBPF

        //lecture des compteurs de la map
        return 0;
}

int tc_ingress_attach_bpf(const char* dev, const char* bpf_obj,
			 const char* sec_name)
{
	char cmd[CMD_MAX];
	int ret = 0;

	/* Step-1: Delete clsact, which also remove filters */
	memset(&cmd, 0, CMD_MAX);
	snprintf(cmd, CMD_MAX,
		 "%s qdisc del dev %s clsact 2> /dev/null",
		 tc_cmd, dev);
	if (verbose) printf(" - Run: %s\n", cmd);
	ret = system(cmd);
	if (!WIFEXITED(ret)) {
		fprintf(stderr,
			"ERR(%d): Cannot exec tc cmd\n Cmdline:%s\n",
			WEXITSTATUS(ret), cmd);
		exit(EXIT_FAILURE);
	} else if (WEXITSTATUS(ret) == 2) {
		/* Unfortunately TC use same return code for many errors */
		if (verbose) printf(" - (First time loading clsact?)\n");
	}

	/* Step-2: Attach a new clsact qdisc */
	memset(&cmd, 0, CMD_MAX);
	snprintf(cmd, CMD_MAX,
		 "%s qdisc add dev %s clsact",
		 tc_cmd, dev);
	if (verbose) printf(" - Run: %s\n", cmd);
	ret = system(cmd);
	if (ret) {
		fprintf(stderr,
			"ERR(%d): tc cannot attach qdisc hook\n Cmdline:%s\n",
			WEXITSTATUS(ret), cmd);
		exit(EXIT_FAILURE);
	}

	/* Step-3: Attach BPF program/object as ingress filter */
	memset(&cmd, 0, CMD_MAX);
	snprintf(cmd, CMD_MAX,
		 "%s filter add dev %s "
		 "ingress prio 1 handle 1 bpf da obj %s sec %s",
		 tc_cmd, dev, bpf_obj, sec_name);
	if (verbose) printf(" - Run: %s\n", cmd);
	ret = system(cmd);
	if (ret) {
		fprintf(stderr,
			"ERR(%d): tc cannot attach filter\n Cmdline:%s\n",
			WEXITSTATUS(ret), cmd);
		exit(EXIT_FAILURE);
	}

	return ret;
}

struct bpf_object *
load_xdp_object_file(const char *filename, int ifindex)
{
	int bpf_prog_fd = -1;
	struct bpf_object *bpf_obj;
	int err;

	/* This struct allow us to set ifindex, this features is used for
	 * hardware offloading XDP programs (note this sets libbpf
	 * bpf_program->prog_ifindex and foreach bpf_map->map_ifindex).
	 */
	struct bpf_prog_load_attr prog_load_attr = {
		.prog_type = BPF_PROG_TYPE_XDP,
		.ifindex   = ifindex,
	};
	prog_load_attr.file = filename;

	/* Use libbpf for extracting BPF byte-code from BPF-ELF object, and
	 * loading this into the kernel via bpf-syscall
	 */
	err = bpf_prog_load_xattr(&prog_load_attr, &bpf_obj, &bpf_prog_fd);
	if (err) {
		fprintf(stderr, "ERR: loading BPF-OBJ file(%s) (%d): %s\n",
			filename, err, strerror(-err));
		return NULL;
	}

	return bpf_obj;
}

struct bpf_object *
open_xdp_object(const char *file, int ifindex)
{
	int err;
	struct bpf_object *obj;
	struct bpf_map *map;
	struct bpf_program *prog, *first_prog = NULL;

	struct bpf_object_open_attr open_attr = {
		.file = file,
		.prog_type = BPF_PROG_TYPE_XDP,
	};

	obj = bpf_object__open_xattr(&open_attr);
	if (IS_ERR_OR_NULL(obj)) {
		err = -PTR_ERR(obj);
		fprintf(stderr, "ERR: opening BPF-OBJ file(%s) (%d): %s\n",
			file, err, strerror(-err));
		return NULL;
	}

	bpf_object__for_each_program(prog, obj) {
		bpf_program__set_type(prog, BPF_PROG_TYPE_XDP);
		bpf_program__set_ifindex(prog, ifindex);
		if (!first_prog)
			first_prog = prog;
	}

	bpf_object__for_each_map(map, obj) {
		if (!bpf_map__is_offload_neutral(map))
			bpf_map__set_ifindex(map, ifindex);
	}

	if (!first_prog) {
		fprintf(stderr, "ERR: file %s contains no programs\n", file);
		return NULL;
	}

	return obj;
}