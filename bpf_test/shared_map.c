#include <errno.h>
#include <libgen.h>      /* dirname */
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <time.h> 	/* clock_t */
#include <unistd.h>      /* access */

#include <net/if.h>	/* ifnametoindex */

#include <sys/statfs.h>  /* statfs */
#include <sys/stat.h>    /* stat(2) + S_IRWXU */
#include <sys/mount.h>   /* mount(2) */

#include <linux/err.h>
#include <linux/if_link.h>

#include <bpf/bpf.h>
#include <bpf/libbpf.h>

#define BPF_TC_FILENAME              "./bpf/tc_kern.o"
#define BPF_XDP_FILENAME             "./bpf/xdp_kern.o"

#define BPF_DIR_MNT	"/sys/fs/bpf"

/* Basedir due to iproute2 use this path */
#define BASEDIR_MAPS "/sys/fs/bpf/tc/globals"

const char *mapfile_map_shared = BASEDIR_MAPS "/map_shared";

/* Exit return codes */
#define	EXIT_OK			0 /* == EXIT_SUCCESS (stdlib.h) man exit(3) */
#define EXIT_FAIL		1 /* == EXIT_FAILURE (stdlib.h) man exit(3) */
#define EXIT_FAIL_OPTION	2
#define EXIT_FAIL_XDP		3
#define EXIT_FAIL_MAP		20
#define EXIT_FAIL_MAP_KEY	21
#define EXIT_FAIL_MAP_FILE	22
#define EXIT_FAIL_MAP_FS	23
#define EXIT_FAIL_IP		30
#define EXIT_FAIL_CPU		31
#define EXIT_FAIL_BPF		40
#define EXIT_FAIL_BPF_ELF	41
#define EXIT_FAIL_BPF_RELOCATE	42

/* paramétrage commmande tc */
#define CMD_MAX 	2048
#define CMD_MAX_TC	256
static char tc_cmd[CMD_MAX_TC] = "tc";

struct bpf_count
{
        int xdp_cnt;
        int tc_cnt;
        int tot_cnt;
};



int verbose = 1; /* extern in common_user.h */

#ifndef BPF_FS_MAGIC
# define BPF_FS_MAGIC   0xcafe4a11
#endif

#define FILEMODE (S_IRWXU | S_IRGRP | S_IXGRP | S_IROTH | S_IXOTH)

/* Verify BPF-filesystem is mounted on given file path */
int __bpf_fs_check_path(const char *path)
{
	struct statfs st_fs;
	char *dname, *dir;
	int err = 0;

	if (path == NULL)
		return -EINVAL;

	dname = strdup(path);
	if (dname == NULL)
		return -ENOMEM;

	dir = dirname(dname);
	if (statfs(dir, &st_fs)) {
		fprintf(stderr, "ERR: failed to statfs %s: (%d)%s\n",
			dir, errno, strerror(errno));
		err = -errno;
	}
	free(dname);

	if (!err && st_fs.f_type != BPF_FS_MAGIC) {
		err = -EMEDIUMTYPE;
	}

	return err;
}

int __bpf_fs_subdir_check_and_fix(const char *dir)
{
	int err;

	err = access(dir, F_OK);
	if (err) {
		if (errno == EACCES) {
			fprintf(stderr,"ERR: "
				"Got root? dir access %s fail: %s\n",
				dir, strerror(errno));
			return -1;
		}
		err = mkdir(dir, FILEMODE);
		if (err) {
			fprintf(stderr, "ERR: mkdir %s failed: %s\n",
				dir, strerror(errno));
				return -1;
		}
		// printf("DEBUG: mkdir %s\n", dir);
	}

	return err;
}

int bpf_fs_check()
{
	const char *path = BPF_DIR_MNT "/some_file";
	int err;

	err = __bpf_fs_check_path(path);

	if (err == -EMEDIUMTYPE) {
		fprintf(stderr,
			"ERR: specified path %s is not on BPF FS\n\n"
			" You need to mount the BPF filesystem type like:\n"
			"  mount -t bpf bpf /sys/fs/bpf/\n\n",
			path);
	}
	return err;
}

int bpf_fs_check_and_fix()
{
	const char *some_base_path = BPF_DIR_MNT "/some_file";
	const char *dir_tc_globals = BPF_DIR_MNT "/tc/globals";
	const char *dir_tc = BPF_DIR_MNT "/tc";
	const char *target = BPF_DIR_MNT;
	bool did_mkdir = false;
	int err;

	err = __bpf_fs_check_path(some_base_path);

	if (err) {
		/* First fix step: mkdir /sys/fs/bpf if dir not exist */
		struct stat sb = {0};
		int ret;

		ret = stat(target, &sb);
		if (ret) {
			ret = mkdir(target, FILEMODE);
			if (ret) {
				fprintf(stderr, "mkdir %s failed: %s\n", target,
					strerror(errno));
				return ret;
			}
			did_mkdir = true;
		}
	}

	if (err == -EMEDIUMTYPE || did_mkdir) {
		/* Fix step 2: Mount bpf filesystem */
		if (mount("bpf", target, "bpf", 0, "mode=0755")) {
			fprintf(stderr, "ERR: mount -t bpf bpf %s failed: %s\n",
				target,	strerror(errno));
			return -1;
		}
	}

	/* Fix step 3: Check sub-directories exists */
	err = __bpf_fs_subdir_check_and_fix(dir_tc);
	if (err)
		return err;

	err = __bpf_fs_subdir_check_and_fix(dir_tc_globals);
	if (err)
		return err;

	return 0;
}


int open_bpf_map_file(const char *file)
{
	int fd;

	fd = bpf_obj_get(file);
	if (fd < 0) {
		fprintf(stderr,
			"WARN: Failed to open bpf map file:%s err(%d):%s\n",
			file, errno, strerror(errno));
		return fd;
	}
	return fd;
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

int tc_remove_ingress_filter(const char* dev)
{
	char cmd[CMD_MAX];
	int ret = 0;

	memset(&cmd, 0, CMD_MAX);
	snprintf(cmd, CMD_MAX,
		 /* Remove all egress filters on dev */
		 "%s filter delete dev %s egress",
		 /* Alternatively could remove specific filter handle:
		 "%s filter delete dev %s egress prio 1 handle 1 bpf",
		 */
		 tc_cmd, dev);
	if (verbose) printf(" - Run: %s\n", cmd);
	ret = system(cmd);
	if (ret) {
		fprintf(stderr,
			"ERR(%d): tc cannot remove filters\n Cmdline:%s\n",
			ret, cmd);
		exit(EXIT_FAILURE);
	}
	return ret;
}

/* TODO move to libbpf */
struct bpf_pinned_map {
	const char *name;
	const char *filename;
	int map_fd;
};

/*     bpf_prog_load_attr extended */
struct bpf_prog_load_attr_maps {
	const char *file;
	enum bpf_prog_type prog_type;
	enum bpf_attach_type expected_attach_type;
	int ifindex;
	int nr_pinned_maps;
	struct bpf_pinned_map *pinned_maps;
};

static int find_map_fd_by_name(struct bpf_object *obj,
			       const char *mapname,
			       struct bpf_prog_load_attr_maps *attr)
{
	int map_fd, i;

	/* Prefer using libbpf function to find_fd_by_name */
	map_fd = bpf_object__find_map_fd_by_name(obj, mapname);
	if (map_fd > 0)
		return map_fd;

	/* If an old TC tool created and pinned map then it have no "name".
	 * In that case use the FD that was returned when opening pinned file.
	 */
	for (i = 0; i < attr->nr_pinned_maps; i++) {
		struct bpf_pinned_map *pin_map = &attr->pinned_maps[i];

		if (strcmp(mapname, pin_map->name) != 0)
				continue;

		/* Matched, use FD stored in bpf_pinned_map */
		map_fd = pin_map->map_fd;
		if (verbose)
			printf("TC workaround for mapname: %s map_fd:%d\n",
			       mapname, map_fd);
	}
	return map_fd;
}

// static int init_map_fds(struct bpf_object *obj,
// 			struct bpf_prog_load_attr_maps *attr)
// {
// 	cpu_map_fd           = find_map_fd_by_name(obj,"cpu_map", attr);
// 	cpus_available_map_fd= find_map_fd_by_name(obj,"cpus_available",attr);
// 	ip_hash_map_fd       = find_map_fd_by_name(obj,"map_ip_hash", attr);
// 	ifindex_type_map_fd  = find_map_fd_by_name(obj,"map_ifindex_type",attr);
// 	txq_config_map_fd    = find_map_fd_by_name(obj,"map_txq_config", attr);

// 	if (cpu_map_fd < 0 || ip_hash_map_fd < 0 ||
// 	    cpus_available_map_fd < 0 || ifindex_type_map_fd < 0) {
// 		fprintf(stderr,
// 			"FDs cpu_map:%d ip_hash:%d cpus_avail:%d ifindex:%d\n",
// 			cpu_map_fd, ip_hash_map_fd,
// 			cpus_available_map_fd, ifindex_type_map_fd);
// 		return -ENOENT;
// 	}

// 	return 0;
// }

/* As close as possible to libbpf bpf_prog_load_xattr(), with the
 * difference of handling pinned maps.
 */

#define pr_warning printf
int bpf_prog_load_xattr_maps(const struct bpf_prog_load_attr_maps *attr,
			     struct bpf_object **pobj, int *prog_fd)
{
	struct bpf_object_open_attr open_attr = {
		.file		= attr->file,
		.prog_type	= attr->prog_type,
	};
	struct bpf_program *prog, *first_prog = NULL;
	enum bpf_attach_type expected_attach_type;
	enum bpf_prog_type prog_type;
	struct bpf_object *obj;
	struct bpf_map *map;
	int err;
	int i;

	if (!attr)
		return -EINVAL;
	if (!attr->file)
		return -EINVAL;


	obj = bpf_object__open_xattr(&open_attr);
	if (IS_ERR_OR_NULL(obj))
		return -ENOENT;

	bpf_object__for_each_program(prog, obj) {
		/*
		 * If type is not specified, try to guess it based on
		 * section name.
		 */
		prog_type = attr->prog_type;
#if 0 /* Use internal libbpf variables */
		prog->prog_ifindex = attr->ifindex;
#endif
		expected_attach_type = attr->expected_attach_type;
#if 0 /* Use internal libbpf variables */
		if (prog_type == BPF_PROG_TYPE_UNSPEC) {
			err = bpf_program__identify_section(prog, &prog_type,
							    &expected_attach_type);
			if (err < 0) {
				bpf_object__close(obj);
				return -EINVAL;
			}
		}
#endif

		bpf_program__set_type(prog, prog_type);
		bpf_program__set_expected_attach_type(prog,
						      expected_attach_type);

		if (!first_prog)
			first_prog = prog;
	}

	/* Reset attr->pinned_maps.map_fd to identify successful file load */
	for (i = 0; i < attr->nr_pinned_maps; i++)
		attr->pinned_maps[i].map_fd = -1;

	bpf_map__for_each(map, obj) {
		const char* mapname = bpf_map__name(map);

#if 0 /* Use internal libbpf variables */
		if (!bpf_map__is_offload_neutral(map))
			map->map_ifindex = attr->ifindex;
#endif
		for (i = 0; i < attr->nr_pinned_maps; i++) {
			struct bpf_pinned_map *pin_map = &attr->pinned_maps[i];
			int fd;

			if (strcmp(mapname, pin_map->name) != 0)
				continue;

			/* Matched, try opening pinned file */
			fd = bpf_obj_get(pin_map->filename);
			if (fd > 0) {
				/* Use FD from pinned map as replacement */
				bpf_map__reuse_fd(map, fd);
				/* TODO: Might want to set internal map "name"
				 * if opened pinned map didn't, to allow
				 * bpf_object__find_map_fd_by_name() to work.
				 */
				pin_map->map_fd = fd;
				continue;
			}
			/* Could not open pinned filename map, then this prog
			 * should then pin the map, BUT this can only happen
			 * after bpf_object__load().
			 */
		}
	}

	if (!first_prog) {
		pr_warning("object file doesn't contain bpf program\n");
		bpf_object__close(obj);
		return -ENOENT;
	}

	err = bpf_object__load(obj);
	if (err) {
		bpf_object__close(obj);
		return -EINVAL;
	}

	/* Pin the maps that were not loaded via pinned filename */
	bpf_map__for_each(map, obj) {
		const char* mapname = bpf_map__name(map);

		for (i = 0; i < attr->nr_pinned_maps; i++) {
			struct bpf_pinned_map *pin_map = &attr->pinned_maps[i];
			int err;

			if (strcmp(mapname, pin_map->name) != 0)
				continue;

			/* Matched, check if map is already loaded */
			if (pin_map->map_fd != -1)
				continue;

			/* Needs to be pinned */
			err = bpf_map__pin(map, pin_map->filename);
			if (err)
				continue;
			pin_map->map_fd = bpf_map__fd(map);
		}
	}

	/* Help user if requested map name that doesn't exist */
	for (i = 0; i < attr->nr_pinned_maps; i++) {
		struct bpf_pinned_map *pin_map = &attr->pinned_maps[i];

		if (pin_map->map_fd < 0)
			pr_warning("%s() requested mapname:%s not seen\n",
				   __func__, pin_map->name);
	}

	*pobj = obj;
	*prog_fd = bpf_program__fd(first_prog);
	return 0;
}

void remove_xdp_program(int ifindex, const char *ifname, __u32 xdp_flags)
{
	// const char *file = mapfile_ip_hash;
	// __u32 dir = INTERFACE_NONE;

	if (verbose) {
		fprintf(stderr, "Removing XDP program on ifindex:%d device:%s\n",
			ifindex, ifname);
	}
	if (ifindex > -1) {
		bpf_set_link_xdp_fd(ifindex, -1, xdp_flags);
		// if (bpf_map_update_elem(ifindex_type_map_fd,
		// 			&ifindex, &dir, 0) < 0) {
		// 	fprintf(stderr, "ERR: Clear ifindex type failed \n");
		// }
	}

	/* map file is possibly share, cannot remove it here */
	// if (verbose)
	// 	fprintf(stderr,
	// 		"INFO: not cleanup pinned map file:%s (use 'rm')\n",
	// 		file);
}

int main(int argc, char const *argv[])
{
        /* Depend on sharing pinned maps */
	// partagé entre user programme XDP et TC
	if (bpf_fs_check_and_fix()) {
		fprintf(stderr, "ERR: "
			"Need access to bpf-fs(%s) for pinned maps "
			"(%d): %s\n", BPF_DIR_MNT, errno, strerror(errno));
		return EXIT_FAIL_MAP_FS;
	}
        printf("bpf_fs_check_and_fix success!\n");

        int map_shared_fd = -1;
        map_shared_fd = open_bpf_map_file(mapfile_map_shared);
        // if (shared_map_fd < 0) {
        //         printf("open_bpf_map_file(mapfile_shared_map) failed!\n");
        //         return -1;
        // }
        printf("open_bpf_map_file(mapfile_shared_map) success!\n");

        /* load tc_kern in kernel */
        char *ifname = "ens33";
        char *sec_name = "tc_count";
        int err;
        err = tc_ingress_attach_bpf(ifname, BPF_TC_FILENAME, sec_name);
	if (err) {
		fprintf(stderr, "ERR: dev:%s"
			" Fail TC-clsact loading %s sec:%s\n",
			ifname, BPF_TC_FILENAME, sec_name);
		return err;
	}
        printf("tc_ingress_attach_bpf success!\n");
        
        bool do_map_init = false;
        if (map_shared_fd < 0) {
	        /* Just loaded TC prog should have pinned it */
		map_shared_fd =
			open_bpf_map_file(mapfile_map_shared);
		do_map_init = true;
                
	}
        printf("open_bpf_map_file success --- fd: %d\n", map_shared_fd);
        
        /* Initialize map */
        if (do_map_init) {
                int pos = 0;
                struct bpf_count prog_cnt = {0};
                err = bpf_map_update_elem(map_shared_fd, &pos, &prog_cnt, 0);
                if (err) {
			fprintf(stderr,
				"ERR: bpf_map_update_elem failed err(%d):%s\n",
				errno, strerror(errno));
			return -1;
		}
        }
        printf("bpf_map_update_elem success!\n");

        /* load xdp program */
	struct bpf_pinned_map pinned_map;
        struct bpf_prog_load_attr_maps prog_load_attr_maps = {
		.prog_type	= BPF_PROG_TYPE_XDP,
		.nr_pinned_maps	= 1,
	};
        pinned_map.name = "map_shared";
        pinned_map.filename = mapfile_map_shared;

        prog_load_attr_maps.pinned_maps = &pinned_map;
	prog_load_attr_maps.file = BPF_XDP_FILENAME;

	int ifindex = if_nametoindex(ifname);
	if (ifindex == 0) {
		fprintf(stderr,
			"ERR: --dev name unknown err(%d):%s\n",
			errno, strerror(errno));
		return -1;
	}
	printf("if_nametoindex success!\n");
       
	__u32 xdp_flags = 0;
	xdp_flags |= XDP_FLAGS_SKB_MODE;
	struct bpf_object *xdp_obj;
	int prog_fd;
	if (bpf_prog_load_xattr_maps(&prog_load_attr_maps, &xdp_obj, &prog_fd)) {
		fprintf(stderr,"ERR: Failed loading BPF-prog\n");
		//return EXIT_FAIL_BPF;
		goto remove_tc;
	}

	// init_map_fds
	int xdp_shared_map_fd = -1;
	xdp_shared_map_fd = find_map_fd_by_name(xdp_obj, "map_shared", &prog_load_attr_maps);
	if (xdp_shared_map_fd < 0) {
		fprintf(stderr, "bpf_object__find_map_fd_by_name failed\n");
		goto remove_tc;
	}
	printf("find_map_fd_by_name success!\n");

	if ((err = bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags)) < 0) {
		fprintf(stderr, "ERR: link set xdp fd failed (err:%d)\n", err);
		goto remove_xdp;
	}
	printf("bpf_set_link_xdp_fd success!\n");

	int msec = 0, trigger = 1000000000000000000000000000; /* 10ms */
	clock_t before = clock();
	int key = 0;
	struct bpf_count prog_cnt;
	do {
		
		/* lecture dans la map partagée */
		err = bpf_map_lookup_elem(map_shared_fd, &key,&prog_cnt);
		if (err < 0) {
			fprintf(stderr, " bpf_map_lookup_elem shared map failed!\n");
			break;
		}

		printf("xdp_cnt: %d  tc_cnt: %d  tot_cnt: %d\r", 
			prog_cnt.xdp_cnt, prog_cnt.tc_cnt, prog_cnt.tot_cnt);

		// clock_t difference = clock() - before;
		// msec = difference * 1000 / CLOCKS_PER_SEC;
	} while (1);
	// while ( msec < trigger );

remove_tc:
	/* unload tc prog kern */
	tc_remove_ingress_filter(ifname);
	printf("tc_remove_ingress_filter success!\n");

remove_xdp:
	remove_xdp_program(ifindex, ifname, xdp_flags);
	printf("remove_xdp_program success!\n");
        return 0;
}
