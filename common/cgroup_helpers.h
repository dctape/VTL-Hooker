/*
 *
 * utilities
 * 
 */

#ifndef __CGROUP_HELPERS_H
#define __CGROUP_HELPERS_H

#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <string.h>



#define clean_errno() (errno == 0 ? "None" : strerror(errno))
#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)


char *find_cgroup_root(void);
int get_cgroup_root_fd(void);
//bool validate_ifname(const char* input_ifname, char *output_ifname);


#endif /*__CGROUP_HELPERS_H */