
/*
 * utilities functions for cgroup manipulations
 */

#define _GNU_SOURCE //for strdup

#include <ctype.h>
#include <fcntl.h>
#include <mntent.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <net/if.h>

#include "cgroup_helpers.h"


/* retourne le chemin du cgroup root */
char 
*find_cgroup_root(void)  // pas nécessaire
{
	struct mntent *mnt;
	FILE *f;

	f = fopen("/proc/mounts", "r");
	if(f == NULL)
		return NULL;
	while ((mnt = getmntent(f))) {
		if(strcmp(mnt->mnt_type, "cgroup2") == 0) {
			fclose(f);
			return strdup(mnt-> mnt_dir);
		}
	}

	fclose(f);
	return NULL;
}

/* récupère le descripteur du cgroup root   */
int 
get_cgroup_root_fd(void)
{   
    int cgfd;
    char *cgroup_root_path = find_cgroup_root();
    cgfd = open(cgroup_root_path, O_RDONLY);
	if (cgfd < 0) {
		// TODO: Améliorer le code d'erreur
		log_err("Opening Cgroup");
        	return -1;
	}
    return cgfd;
}