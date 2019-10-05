/* Common function that with time should be moved to libbpf */
#ifndef __COMMON_LIBBPF_H
#define __COMMON_LIBBPF_H

#include <bpf/libbpf.h>





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

int bpf_cgroup_attach(int prog_fd, int cgroup_fd, enum bpf_attach_type type,
		    unsigned int flags);

int bpf_cgroup_detach(int prog_fd, int cgroup_fd, enum bpf_attach_type type);

int bpf_prog_load_xattr_maps(const struct bpf_prog_load_attr_maps *attr,
			     struct bpf_object **pobj, int *prog_fd);

struct bpf_object *load_bpf_object_file(const char *filename, 
					enum bpf_prog_type prog_type, 
					int ifindex);

struct bpf_object *open_bpf_object(const char *file, 
					  enum bpf_prog_type prog_type,
					  int ifindex);

int reuse_maps(struct bpf_object *obj, const char *path);

struct bpf_object *load_bpf_object_file_reuse_maps(const char *file,
						   enum bpf_prog_type prog_type,
						   int ifindex,
						   const char *pin_dir);

int check_map_fd_info(const struct bpf_map_info *info,
		      const struct bpf_map_info *exp);

int open_bpf_map_file(const char *pin_dir,
		      const char *mapname,
		      struct bpf_map_info *info);


#endif /* __COMMON_LIBBPF_H */
