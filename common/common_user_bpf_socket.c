/*
 *
 * fonctions pour l'injection de programmes sur skmsg et sockops
 * 
 */ 

#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <bpf/bpf.h>
#include <bpf/libbpf.h>

#include "common_defines.h"
#include "common_libbpf.h"

#include "../lib/config.h" // pour la définition sock_key_t
// TODO : Trouver une meilleure alternative



struct bpf_object *load_bpf_progs(struct config *cfg)
{
	struct bpf_program *bpf_prog;
	struct bpf_object *bpf_obj;
	int i = 0;
	long err;

	bpf_obj = bpf_object__open(cfg->filename);
	err = libbpf_get_error(bpf_obj);
	if (err) {
		char err_buf[256];

		libbpf_strerror(err, err_buf, sizeof(err_buf));
		fprintf(stderr,"Unable to load eBPF objects in file '%s' : %s\n",
		       cfg->filename, err_buf);
		exit(EXIT_FAILURE);
	}

	/* Configuration des programmes de bpf_obj */
	bpf_object__for_each_program(bpf_prog, bpf_obj) {
		bpf_program__set_type(bpf_prog, cfg->prog_type[i]);
		bpf_program__set_expected_attach_type(bpf_prog,
						      cfg->prog_attach_type[i]);
		i++;
	}

	i = bpf_object__load(bpf_obj);

	return bpf_obj;

}

// struct bpf_object *load_bpf_and_skmsg_attach(struct config *cfg, 
// 					      int sock_redir_fd)
// {
//         struct bpf_program *bpf_prog;
// 	struct bpf_object *bpf_obj;
// 	struct bpf_map *map;
	
// 	int prog_fd = -1;
// 	int err;   

//         /* Load the BPF-ELF object file and get back libbpf bpf_object */
// 	// Si
	
// 	/**  Chargement du fichier ELF-BPF dans le noyau **/
// 	// WARN: Ne marche pas pour sk_msg
// 	// if (cfg->reuse_maps)
// 	// 	bpf_obj = load_bpf_object_file_reuse_maps(cfg->filename,
// 	// 						  cfg->prog_type,
// 	// 						  0 /*offload_ifindex */,
// 	// 						  cfg->pin_dir);
// 	// else
// 	// 	bpf_obj = load_bpf_object_file(cfg->filename,		 
// 	// 				       cfg->prog_type,
// 	// 	 			       0 /*offload_ifindex */);
        
// 	// Autre méthode pour charger le programme...Mais ne pas oublier le reuse_maps
// 	// Ok!!
// 	if (bpf_prog_load(cfg->filename, BPF_PROG_TYPE_SK_MSG, &bpf_obj, &prog_fd)) {
// 		fprintf(stderr, "ERR: failed to load program\n");
// 		exit(EXIT_FAIL_BPF);
// 	}

// 	/* Récupération du descripteur de la sockmap */
	
// 	map = bpf_object__find_map_by_name(bpf_obj, "hooker_map"); // nom de de la sockmap
// 	cfg->sock_map_fd = bpf_map__fd(map);
// 	if (cfg->sock_map_fd < 0) {
// 		fprintf(stderr, "ERR: no sockmap found: %s\n",
// 			strerror(cfg->sock_map_fd));
// 		exit(EXIT_FAILURE);
// 	}

// 	/* Ajouter la socket de redirection à la sockmap */
// 	// sock_key_t sock_redir_key = {};
// 	// err = bpf_map_update_elem(sock_map_fd, &sock_redir_key, 
// 	// 			  &sock_redir, BPF_ANY);
	
// 	// if (err != 0) {
// 	// 	fprintf(stderr, "ERR: fail to add redirection socket to sockmap\n");
// 	// 	exit(err); //goto or return;
// 	// }


// 	/* récupération du descripteur de programme */
//         if (cfg->progsec[0])
// 		/* Find a matching BPF prog section name */
// 		bpf_prog = bpf_object__find_program_by_title(bpf_obj, cfg->progsec);
// 	else
// 		/* Find the first program */
// 		// Contient un seul programme BPF
// 		bpf_prog = bpf_program__next(NULL, bpf_obj);
	
// 	if (!bpf_prog) {
// 		fprintf(stderr, "ERR: couldn't find a program in ELF section '%s'\n", cfg->progsec);
// 		exit(EXIT_FAIL_BPF);
// 	}

// 	strncpy(cfg->progsec, bpf_program__title(bpf_prog, false), sizeof(cfg->progsec));

// 	prog_fd = bpf_program__fd(bpf_prog);
// 	if (prog_fd <= 0) {
// 		fprintf(stderr, "ERR: bpf_program__fd failed\n");
// 		exit(EXIT_FAIL_BPF);
// 	}
	
// 	/* Attacher le programme skmsg à la sockmap */

// 	err = bpf_prog_attach(prog_fd, cfg->sock_map_fd, BPF_SK_MSG_VERDICT,
// 				 cfg->attach_flags /* flags */);
// 	if(err) {
// 		fprintf(stderr, "ERR: bpf_prog_attach skmsg failed\n");
// 		exit(err);//goto or return
// 	}

//        return bpf_obj; 

// }

// struct bpf_object *load_bpf_and_sockops_attach(struct config *cfg)
// {
// 	struct bpf_program *bpf_prog;
// 	struct bpf_object *bpf_obj;

// 	int prog_fd = -1;
// 	int err; 

// 	/**  Chargement du fichier ELF-BPF dans le noyau **/
// 	if (cfg->reuse_maps)
// 		bpf_obj = load_bpf_object_file_reuse_maps(cfg->filename,
// 							  cfg->prog_type,
// 							  0 /*offload_ifindex */,
// 							  cfg->pin_dir);
// 	else
// 		bpf_obj = load_bpf_object_file(cfg->filename,		 
// 					       cfg->prog_type,
// 		 			       0 /*offload_ifindex */);
	
// 	/* récupération du descripteur du programme sockops */
//         if (cfg->progsec[0])
// 		/* Find a matching BPF prog section name */
// 		bpf_prog = bpf_object__find_program_by_title(bpf_obj, cfg->progsec);
// 	else
// 		/* Find the first program */
// 		// Contient un seul programme BPF
// 		bpf_prog = bpf_program__next(NULL, bpf_obj);
	
// 	if (!bpf_prog) {
// 		fprintf(stderr, "ERR: couldn't find a program in ELF section '%s'\n", cfg->progsec);
// 		exit(EXIT_FAIL_BPF);
// 	}

// 	strncpy(cfg->progsec, bpf_program__title(bpf_prog, false), sizeof(cfg->progsec));

// 	prog_fd = bpf_program__fd(bpf_prog);
// 	if (prog_fd <= 0) {
// 		fprintf(stderr, "ERR: bpf_program__fd failed\n");
// 		exit(EXIT_FAIL_BPF);
// 	}

// 	/* attachage de sockops au cgroup */
// 	err = bpf_prog_attach(prog_fd, cfg->cgroup_fd, BPF_CGROUP_SOCK_OPS,
// 				cfg->attach_flags);
// 	if (err) {
// 		fprintf(stderr, "ERR: bpf_prog_attach sockops failed!\n");
// 		exit(err);
// 	}

// 	return bpf_obj;
// }

int skmsg_detach (struct config *cfg, int skmsg_prog_fd)
{
	int err;

	err = bpf_prog_detach2(skmsg_prog_fd, cfg->sock_map_fd,
				BPF_SK_MSG_VERDICT);
	if (err) {
		fprintf(stderr, "ERR: bpf_prog_detach skmsg failed\n");
		exit(err);
	}

	return err;
}

int sockops_detach(struct config *cfg, int sockops_prog_fd)
{
	int err;

	err = bpf_prog_detach2(sockops_prog_fd, cfg->cgroup_fd, 
				BPF_CGROUP_SOCK_OPS);
	if (err) {
		fprintf(stderr, "ERR: bpf_prog_detach sockops failed\n");
		exit(err);
	}

	return err;
}