/*
 *
 * fonctions pour l'injection de programmes sur skmsg et sockops
 * 
 */ 

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "common_defines.h"
#include "common_libbpf.h"


struct bpf_object *load_bpf_and_skmsg_attach(struct config *cfg)
{
        struct bpf_program *bpf_prog;
	struct bpf_object *bpf_obj;
	int offload_ifindex = 0;
	int prog_fd = -1;
	int err;   

        /* If flags indicate hardware offload, supply ifindex */
	// Si le mode hardware est activé alors...
	// if (cfg->xdp_flags & XDP_FLAGS_HW_MODE)
	// 	offload_ifindex = cfg->ifindex;


        /* Load the BPF-ELF object file and get back libbpf bpf_object */
	// Si
	
	/**  Chargement du fichier ELF-BPF dans le noyau **/
	if (cfg->reuse_maps)
		bpf_obj = load_bpf_object_file_reuse_maps(cfg->filename,
							  cfg->prog_type,
							  offload_ifindex,
							  cfg->pin_dir);
	else
		bpf_obj = load_bpf_object_file(cfg->filename,		 
					       cfg->prog_type,
		 			       offload_ifindex);
        
	/* Récupération du descripteur de la map */
	struct bpf_map *map;
	int sock_map_fd;

	map = bpf_object__find_map_by_name(bpf_obj, ""); // nom de de la sockmap
	sock_map_fd = bpf_map__fd(map);
	if (sock_map_fd < 0) {
		fprintf(stderr)
	}

        if (cfg->progsec[0])
		/* Find a matching BPF prog section name */
		bpf_prog = bpf_object__find_program_by_title(bpf_obj, cfg->progsec);
	else
		/* Find the first program */
		// Contient un seul programme BPF
		bpf_prog = bpf_program__next(NULL, bpf_obj);
	

        

}
