
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include <bpf/bpf.h>
#include <bpf/libbpf.h>

#include "defines.h"
#include "util_user_maps.h"

const char *pin_basedir =  "/sys/fs/bpf";

int 
reuse_maps(struct bpf_object *obj, const char *path)
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

int 
check_map_fd_info(const struct bpf_map_info *info,
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

int 
open_bpf_map_file(const char *pin_dir,
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
	char map_filename[PATH_MAX]; // Warning: Variable non utilisée
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
