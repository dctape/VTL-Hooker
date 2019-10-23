
#include <errno.h>
#include <net/if.h>     /* IF_NAMESIZE */
#include <stdlib.h>     /* exit(3) */
#include <string.h>     /* strerror */

#include <bpf/bpf.h>
#include <bpf/libbpf.h> /* bpf_get_link_xdp_id + bpf_set_link_xdp_id */

#include <linux/if_link.h> /* Need XDP flags */
#include <linux/err.h>

#include "defines.h"
#include "util_user_maps.h"
#include "xdp_user_helpers.h"


static struct bpf_object *
load_bpf_object_file(const char *filename, int ifindex)
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

// Pour l'instant spécifique à XDP
static struct bpf_object *
open_bpf_object(const char *file, int ifindex)
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

// Charger le fichier ELF-BPF en réutilisant les maps
// Epingler dans un fichier
// Pour l'instant spécifique à xdp...changer plus tard!
static struct bpf_object *
load_bpf_object_file_reuse_maps(const char *file,
				int ifindex,
				const char *pin_dir)
{
	int err;
	struct bpf_object *obj;

	obj = open_bpf_object(file, ifindex);
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

int 
xdp_link_attach(int ifindex, __u32 xdp_flags, int prog_fd)
{
	int err;

	/* libbpf provide the XDP net_device link-level hook attach helper */
	err = bpf_set_link_xdp_fd(ifindex, prog_fd, xdp_flags);
	if (err == -EEXIST && !(xdp_flags & XDP_FLAGS_UPDATE_IF_NOEXIST))
	{
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
	if (err < 0)
	{
		fprintf(stderr, "ERR: "
				"ifindex(%d) link set xdp fd failed (%d): %s\n",
			ifindex, -err, strerror(-err));

		switch (-err)
		{
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

int 
xdp_link_detach(int ifindex, __u32 xdp_flags, __u32 expected_prog_id)
{
	__u32 curr_prog_id;
	int err;

	err = bpf_get_link_xdp_id(ifindex, &curr_prog_id, xdp_flags);
	if (err)
	{
		fprintf(stderr, "ERR: get link xdp id failed (err=%d): %s\n",
			-err, strerror(-err));
		return EXIT_FAIL_XDP;
	}

	if (!curr_prog_id)
	{
		if (verbose)
			printf("INFO: %s() no curr XDP prog on ifindex:%d\n",
			       __func__, ifindex);
		return EXIT_OK;
	}

	if (expected_prog_id && curr_prog_id != expected_prog_id)
	{
		fprintf(stderr, "ERR: %s() "
				"expected prog ID(%d) no match(%d), not removing\n",
			__func__, expected_prog_id, curr_prog_id);
		return EXIT_FAIL;
	}

	if ((err = bpf_set_link_xdp_fd(ifindex, -1, xdp_flags)) < 0)
	{
		fprintf(stderr, "ERR: %s() link set xdp failed (err=%d): %s\n",
			__func__, err, strerror(-err));
		return EXIT_FAIL_XDP;
	}

	if (verbose)
		printf("INFO: %s() removed XDP prog ID:%d on ifindex:%d\n",
		       __func__, curr_prog_id, ifindex);

	return EXIT_OK;
}

struct bpf_object *
load_bpf_and_xdp_attach(struct xdp_config *xdp_cfg)
{
	struct bpf_program *bpf_prog;
	struct bpf_object *bpf_obj;
	int offload_ifindex = 0;
	int prog_fd = -1;
	int err;

	/* If flags indicate hardware offload, supply ifindex */
	// Si le mode hardware est activé alors...
	if (xdp_cfg->xdp_flags & XDP_FLAGS_HW_MODE)
		offload_ifindex = xdp_cfg->ifindex;

	/* Load the BPF-ELF object file and get back libbpf bpf_object */
	// Si
	if (xdp_cfg->reuse_maps)
		bpf_obj = load_bpf_object_file_reuse_maps(xdp_cfg->filename,
							  offload_ifindex,
							  xdp_cfg->pin_dir);
	else
		bpf_obj = load_bpf_object_file(xdp_cfg->filename, offload_ifindex);

	if (!bpf_obj)
	{
		fprintf(stderr, "ERR: loading file: %s\n", xdp_cfg->filename);
		exit(EXIT_FAIL_BPF);
	}

	/* At this point: All XDP/BPF programs from the cfg->filename have been
	 * loaded into the kernel, and evaluated by the verifier. Only one of
	 * these gets attached to XDP hook, the others will get freed once this
	 * process exit.
	 */

	if (xdp_cfg->progsec[0])
		/* Find a matching BPF prog section name */
		bpf_prog = bpf_object__find_program_by_title(bpf_obj, xdp_cfg->progsec);
	else
		/* Find the first program */
		// Contient un seul programme BPF
		bpf_prog = bpf_program__next(NULL, bpf_obj);

	if (!bpf_prog)
	{
		fprintf(stderr, "ERR: couldn't find a program in ELF section '%s'\n",xdp_cfg->progsec);
		exit(EXIT_FAIL_BPF);
	}

	strncpy(xdp_cfg->progsec, bpf_program__title(bpf_prog, false), sizeof(xdp_cfg->progsec));

	prog_fd = bpf_program__fd(bpf_prog);
	if (prog_fd <= 0)
	{
		fprintf(stderr, "ERR: bpf_program__fd failed\n");
		exit(EXIT_FAIL_BPF);
	}

	/* At this point: BPF-progs are (only) loaded by the kernel, and prog_fd
	 * is our select file-descriptor handle. Next step is attaching this FD
	 * to a kernel hook point, in this case XDP net_device link-level hook.
	 */
	err = xdp_link_attach(xdp_cfg->ifindex, xdp_cfg->xdp_flags, prog_fd);
	if (err)
		exit(err);

	return bpf_obj;
}

// // Est-ce nécessaire cette partie ??
// #define XDP_UNKNOWN XDP_REDIRECT + 1
// #ifndef XDP_ACTION_MAX
// #define XDP_ACTION_MAX (XDP_UNKNOWN + 1)
// #endif

// static const char *xdp_action_names[XDP_ACTION_MAX] = {
//     [XDP_ABORTED] = "XDP_ABORTED",
//     [XDP_DROP] = "XDP_DROP",
//     [XDP_PASS] = "XDP_PASS",
//     [XDP_TX] = "XDP_TX",
//     [XDP_REDIRECT] = "XDP_REDIRECT",
//     [XDP_UNKNOWN] = "XDP_UNKNOWN",
// };
// const char *action2str(__u32 action)
// {
// 	if (action < XDP_ACTION_MAX)
// 		return xdp_action_names[action];
// 	return NULL;
// }