/*
 * Programme de capture de paquets au niveau 
 * de XDP et Transmission dans l'espace utilisateur
 * avec un socket af_xdp
 *  
 */

#include <assert.h>
#include <errno.h>
#include <poll.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <sys/resource.h>

#include <linux/bpf.h> //TODO: Est-ce nécessaire ??
#include "../bpf/bpf-manager.h" //Pour utiliser le wrapper de libbpf

