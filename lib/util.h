/*
 *
 * utilities
 * 
 */

#ifndef __HK_UTIL_H
#define __HK_UTIL_H

#include <stdio.h>
#include <string.h>
#include <errno.h>

#define clean_errno() (errno == 0 ? "None" : strerror(errno))
#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)


char *find_cgroup_root(void);
int get_cgroup_root_fd(void);



#endif