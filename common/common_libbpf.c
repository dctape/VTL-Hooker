/* Common function that with time should be moved to libbpf */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>
#include <getopt.h>


#include <bpf/bpf.h>
#include <bpf/libbpf.h>

#include <net/if.h>
#include <linux/if_link.h> 
#include <linux/err.h>

#include "common_libbpf.h"
#include "common_defines.h"

const char *pin_basedir =  "/sys/fs/bpf";

#ifndef PATH_MAX
#define PATH_MAX	4096
#endif

/* From: include/linux/err.h */
#define MAX_ERRNO       4095
// #define IS_ERR_VALUE(x) ((x) >= (unsigned long)-MAX_ERRNO)
// static inline bool IS_ERR_OR_NULL(const void *ptr)
// {
//         return (!ptr) || IS_ERR_VALUE((unsigned long)ptr);
// }

#define pr_warning printf



int bpf_cgroup_attach(int prog_fd, int cgroup_fd, enum bpf_attach_type type,
		    unsigned int flags)
{
	return bpf_prog_attach(prog_fd, cgroup_fd, type, flags);
}

int bpf_cgroup_detach(int prog_fd, int cgroup_fd, enum bpf_attach_type type)
{
	return bpf_prog_detach2(prog_fd, cgroup_fd, type);
}


/* As close as possible to libbpf bpf_prog_load_xattr(), with the
 * difference of handling pinned maps.
 */
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
		// Was: prog->prog_ifindex = attr->ifindex;
		bpf_program__set_ifindex(prog, attr->ifindex);

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

		if (!bpf_map__is_offload_neutral(map))
			bpf_map__set_ifindex(map, attr->ifindex);
                        /* Was: map->map_ifindex = attr->ifindex; */

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


// Fonction universelle pour le chargement de fichier ELF-BPF
struct bpf_object *load_bpf_object_file(const char *filename, 
					enum bpf_prog_type prog_type, 
					int ifindex)
{
	int bpf_fd = -1;
	struct bpf_object *obj;
	struct bpf_prog_load_attr prog_load_attr;
	int err;

	switch (prog_type)
	{
		case BPF_PROG_TYPE_SK_MSG:
			
			prog_load_attr.prog_type = BPF_PROG_TYPE_SK_MSG;
			prog_load_attr.file = filename;
			break;
		
		case BPF_PROG_TYPE_SOCK_OPS:

			prog_load_attr.prog_type = BPF_PROG_TYPE_SOCK_OPS;
			prog_load_attr.file = filename;	
			break;
		
		case BPF_PROG_TYPE_XDP:

			prog_load_attr.prog_type = BPF_PROG_TYPE_XDP;
			prog_load_attr.ifindex = ifindex;
			prog_load_attr.file = filename;			
			break;

		default:
			fprintf(stderr, "ERR: unknown BPF-TYPE\n");
			return NULL;
			break;
	}

	// bpf_prog_load_xattr or bpf_prog_load
	// Choisir selon le type
	// BPF_PROG_TYPE en paramètre
	err = bpf_prog_load_xattr(&prog_load_attr, &obj, &bpf_fd);
	if (err) {
		fprintf(stderr, "ERR: loading BPF-OBJ file(%s) (%d): %s\n",
			filename, err, strerror(-err));
		return NULL;
	}

	return obj;
}

// Voir ou cette fonction est-elle utilisée...
// TODO: revoir les définitions avec static
struct bpf_object *open_bpf_object(const char *file, 
					  enum bpf_prog_type prog_type,
					  int ifindex)
{

	int err;
	struct bpf_object *obj;
	struct bpf_map *map;
	struct bpf_program *prog, *first_prog = NULL;

	struct bpf_object_open_attr open_attr = {
		.file = file,
		.prog_type = prog_type,
	};
	obj = bpf_object__open_xattr(&open_attr);
	if (IS_ERR_OR_NULL(obj)) {
		err = -PTR_ERR(obj);
		fprintf(stderr, "ERR: opening BPF-OBJ file(%s) (%d): %s\n",
			file, err, strerror(-err));
		return NULL;
	}
	
	// En quoi cette étape est-elle nécessaire ???

	if (prog_type == BPF_PROG_TYPE_XDP) {

		bpf_object__for_each_program(prog, obj) {
			bpf_program__set_type(prog, prog_type);
			bpf_program__set_ifindex(prog, ifindex);
			if (!first_prog)
				first_prog = prog;
			}

			bpf_object__for_each_map(map, obj) {
			if (!bpf_map__is_offload_neutral(map))
				bpf_map__set_ifindex(map, ifindex);
		}

	}
	else {
		bpf_object__for_each_program(prog, obj) {
		bpf_program__set_type(prog, prog_type);
		bpf_program__set_ifindex(prog, ifindex);
		if (!first_prog)
			first_prog = prog;
		}

		// Est-ce nécessaire  ???
		// bpf_object__for_each_map(map, obj) {
		// if (!bpf_map__is_offload_neutral(map))
		// 	bpf_map__set_ifindex(map, ifindex);
		// }

	}

	if (!first_prog) {
		fprintf(stderr, "ERR: file %s contains no programs\n", file);
		return NULL;
	}

	return obj;
}

// Pourquoi static ?
int reuse_maps(struct bpf_object *obj, const char *path)
{
	struct bpf_map *map;

	if (!obj)
		return -ENOENT;
	
	if (!path)
		return -EINVAL;
	
	bpf_object__for_each_map(map, obj) {
		int len, err;
		int pinned_map_fd;
		char buf[PATH_MAX];

		len = snprintf(buf, PATH_MAX, "%s/%s", path, bpf_map__name(map));
		if (len < 0) {
			return -EINVAL;
		} else if (len >= PATH_MAX) {
			return -ENAMETOOLONG;
		}

		pinned_map_fd = bpf_obj_get(buf);
		if (pinned_map_fd < 0)
			return pinned_map_fd;

		err = bpf_map__reuse_fd(map, pinned_map_fd);
		if (err)
			return err;
	}

	return 0;

}

// Charger le fichier ELF-BPF en réutilisant les maps
// Epingler dans un fichier
struct bpf_object *load_bpf_object_file_reuse_maps(const char *file,
						   enum bpf_prog_type prog_type,
						   int ifindex,
						   const char *pin_dir)
{
	int err;
	struct bpf_object *obj;

	obj = open_bpf_object(file, prog_type, ifindex);
	if (!obj) {
		fprintf(stderr, "ERR: failed to open object %s\n", file);
		return NULL;
	}

	err = reuse_maps(obj, pin_dir);
	if (err) {
		fprintf(stderr, "ERR: failed to reuse maps for object %s, pin_dir=%s\n",
				file, pin_dir);
		return NULL;
	}

	err = bpf_object__load(obj);
	if (err) {
		fprintf(stderr, "ERR: loading BPF-OBJ file(%s) (%d): %s\n",
			file, err, strerror(-err));
		return NULL;
	}

	return obj;
}

int check_map_fd_info(const struct bpf_map_info *info,
		      const struct bpf_map_info *exp)
{
	if (exp->key_size && exp->key_size != info->key_size) {
		fprintf(stderr, "ERR: %s() "
			"Map key size(%d) mismatch expected size(%d)\n",
			__func__, info->key_size, exp->key_size);
		return EXIT_FAIL;
	}
	if (exp->value_size && exp->value_size != info->value_size) {
		fprintf(stderr, "ERR: %s() "
			"Map value size(%d) mismatch expected size(%d)\n",
			__func__, info->value_size, exp->value_size);
		return EXIT_FAIL;
	}
	if (exp->max_entries && exp->max_entries != info->max_entries) {
		fprintf(stderr, "ERR: %s() "
			"Map max_entries(%d) mismatch expected size(%d)\n",
			__func__, info->max_entries, exp->max_entries);
		return EXIT_FAIL;
	}
	if (exp->type && exp->type  != info->type) {
		fprintf(stderr, "ERR: %s() "
			"Map type(%d) mismatch expected type(%d)\n",
			__func__, info->type, exp->type);
		return EXIT_FAIL;
	}

	return 0;
}

int open_bpf_map_file(const char *pin_dir,
		      const char *mapname,
		      struct bpf_map_info *info)
{
	char filename[PATH_MAX];
	int err, len, fd;
	__u32 info_len = sizeof(*info);

	len = snprintf(filename, PATH_MAX, "%s/%s", pin_dir, mapname);
	if (len < 0) {
		fprintf(stderr, "ERR: constructing full mapname path\n");
		return -1;
	}

	fd = bpf_obj_get(filename);
	if (fd < 0) {
		fprintf(stderr,
			"WARN: Failed to open bpf map file:%s err(%d):%s\n",
			filename, errno, strerror(errno));
		return fd;
	}

	if (info) {
		err = bpf_obj_get_info_by_fd(fd, info, &info_len);
		if (err) {
			fprintf(stderr, "ERR: %s() can't get info - %s\n",
				__func__,  strerror(errno));
			return EXIT_FAIL_BPF;
		}
	}

	return fd;
}

/* Pinning maps under /sys/fs/bpf in subdir */
int pin_maps_in_bpf_object(struct bpf_object *bpf_obj, const char *subdir)
{
	char map_filename[PATH_MAX];
	char pin_dir[PATH_MAX];
	int err, len;

	len = snprintf(pin_dir, PATH_MAX, "%s/%s", pin_basedir, subdir);
	if (len < 0) {
		fprintf(stderr, "ERR: creating pin dirname\n");
		return EXIT_FAIL_OPTION;
	}

	// TODO : évaluer l'importance de ce bloc

	// len = snprintf(map_filename, PATH_MAX, "%s/%s/%s",
	// 	       pin_basedir, subdir, map_name);
	// if (len < 0) {
	// 	fprintf(stderr, "ERR: creating map_name\n");
	// 	return EXIT_FAIL_OPTION;
	// }

	// /* Existing/previous XDP prog might not have cleaned up */
	// if (access(map_filename, F_OK ) != -1 ) {
	// 	if (verbose)
	// 		printf(" - Unpinning (remove) prev maps in %s/\n",
	// 		       pin_dir);

	// 	/* Basically calls unlink(3) on map_filename */
	// 	err = bpf_object__unpin_maps(bpf_obj, pin_dir);
	// 	if (err) {
	// 		fprintf(stderr, "ERR: UNpinning maps in %s\n", pin_dir);
	// 		return EXIT_FAIL_BPF;
	// 	}
	// }
	// if (verbose)
	// 	printf(" - Pinning maps in %s/\n", pin_dir);

	
	/* This will pin all maps in our bpf_object */
	err = bpf_object__pin_maps(bpf_obj, pin_dir);
	if (err)
		return EXIT_FAIL_BPF;

	return 0;
}
