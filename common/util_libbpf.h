/* Common function that with time should be moved to libbpf */
#ifndef __UTIL_LIBBPF_H
#define __UTIL_LIBBPF_H

#include <bpf/libbpf.h> /* enum bpf_attach_type */


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


#endif /*__UTIL_LIBBPF_H */
