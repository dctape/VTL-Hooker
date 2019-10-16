#ifndef __UTIL_USER_MAPS_H
#define __UTIL_USER_MAPS_H

#ifndef PATH_MAX
#define PATH_MAX	4096
#endif

int reuse_maps(struct bpf_object *obj, const char *path);

int  check_map_fd_info(const struct bpf_map_info *info,
		       const struct bpf_map_info *exp);

int open_bpf_map_file(const char *pin_dir,
		      const char *mapname,
		      struct bpf_map_info *info);

#endif /* __UTIL_USER_MAPS_H */