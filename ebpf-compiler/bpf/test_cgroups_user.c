#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <string.h>
#include <mntent.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/mount.h>
#include <fcntl.h>
#include <errno.h>
#include <sched.h>
#include <sys/syscall.h>
#include <linux/limits.h>
#include <linux/sched.h>
#include <ftw.h>


#include <bpf/bpf.h>
#include "libbpf.h"
#include "bpf_load.h"
#include "bpf_util.h" // Pas trop utile pour ce programme

#define  CGROUP_PATH            "/test_cgroup"
#define WALK_FD_LIMIT			16
#define CGROUP_MOUNT_PATH		"/mnt"
#define CGROUP_WORK_DIR			"/cgroup-test-work-dir"
#define format_cgroup_path(buf, path) \
	snprintf(buf, sizeof(buf), "%s%s%s", CGROUP_MOUNT_PATH, \
		 CGROUP_WORK_DIR, path)
#define clean_errno() (errno == 0 ? "None" : strerror(errno))
#define log_err(MSG, ...) fprintf(stderr, "(%s:%d: errno: %s) " MSG "\n", \
	__FILE__, __LINE__, clean_errno(), ##__VA_ARGS__)

int setup_cgroup_environment(void);
static int nftwfunc(const char *filename, const struct stat *statptr,
		    int fileflags, struct FTW *pfwt);
static int join_cgroup_from_top(char *cgroup_path);
int join_cgroup(const char *path);
void cleanup_cgroup_environment(void);
int create_and_get_cgroup(const char *path);
unsigned long long get_cgroup_id(const char *path);


int main(int argc, char **argv)
{   

	int nb_sec = 50;
    char filename[256];
	int cgroup_fd;

    /* Copie du nom du programme eBPF, précisément du .o */
	snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);

    /* Chargement du programme eBPF */
	printf("Loading bpf program in kernel...\n");
	if (load_bpf_file(filename)){
		fprintf(stderr, "ERR in load_bp_file(): %s", bpf_log_buf);
		return -1;
	}

    printf("prog_fd = %d\n", prog_fd[0]);

    /* setup cgroup environnment */
    printf("Setup cgroup environnment ....\n");
    	if (setup_cgroup_environment()) {
		printf("Failed to setup cgroup environment\n");
		goto err;
	}
    /* Create a cgroup, get fd and join it */
    printf("Creating test cgroup...\n");
    cgroup_fd = create_and_get_cgroup(CGROUP_PATH);
    if (cgroup_fd < 0) {
            printf("Failed to create test cgroup\n");
            goto err;
    }
    printf("cgroup_fd = %d\n", cgroup_fd);
    printf("joining test cgroup...\n");
    if (join_cgroup(CGROUP_PATH)) {  // est-ce obligatoire ????
        printf("Failed to join test cgroup\n");
        goto err;
    }

    /* Attach the bpf program */
    int ret;
    printf("Attaching bpf program...\n");
    ret = attach_cgroup(prog_fd[0], cgroup_fd, BPF_CGROUP_SOCK_OPS, 0);    
    if(ret) {
            printf("Failed to attach bpf program\tret = %d\n", ret);
            perror("bpf_prog_attach");
            goto err;
    }

	printf("Sleeping  during : %d\n ", nb_sec);
	sleep(nb_sec);


    /* Removing bpf_program */
	printf("Removing bpf program...\nExit\n");
	detach_cgroup(prog_fd[0], cgroup_fd, BPF_CGROUP_INET_EGRESS);

err:
    cleanup_cgroup_environment();

    return 0;
}




int setup_cgroup_environment(void)
{
	char cgroup_workdir[PATH_MAX + 1];

	format_cgroup_path(cgroup_workdir, "");

	if (unshare(CLONE_NEWNS)) {
		log_err("unshare");
		return 1;
	}

	if (mount("none", "/", NULL, MS_REC | MS_PRIVATE, NULL)) {
		log_err("mount fakeroot");
		return 1;
	}

	if (mount("none", CGROUP_MOUNT_PATH, "cgroup2", 0, NULL) && errno != EBUSY) {
		log_err("mount cgroup2");
		return 1;
	}

	/* Cleanup existing failed runs, now that the environment is setup */
	cleanup_cgroup_environment();

	if (mkdir(cgroup_workdir, 0777) && errno != EEXIST) {
		log_err("mkdir cgroup work dir");
		return 1;
	}

	return 0;
}

static int nftwfunc(const char *filename, const struct stat *statptr,
		    int fileflags, struct FTW *pfwt)
{
	if ((fileflags & FTW_D) && rmdir(filename))
		log_err("Removing cgroup: %s", filename);
	return 0;
}

static int join_cgroup_from_top(char *cgroup_path)
{
	char cgroup_procs_path[PATH_MAX + 1];
	pid_t pid = getpid();
	int fd, rc = 0;

	snprintf(cgroup_procs_path, sizeof(cgroup_procs_path),
		 "%s/cgroup.procs", cgroup_path);

	fd = open(cgroup_procs_path, O_WRONLY); // ouverture en écriture
	if (fd < 0) {
		log_err("Opening Cgroup Procs: %s", cgroup_procs_path);
		return 1;
	}

	/* joindre le cgroup */
	if (dprintf(fd, "%d\n", pid) < 0) {
		log_err("Joining Cgroup");
		rc = 1;
	}

	close(fd);
	return rc;
}


int join_cgroup(const char *path)
{
	char cgroup_path[PATH_MAX + 1];

	format_cgroup_path(cgroup_path, path);
	return join_cgroup_from_top(cgroup_path);
}

void cleanup_cgroup_environment(void)
{
	char cgroup_workdir[PATH_MAX + 1];

	format_cgroup_path(cgroup_workdir, "");
	join_cgroup_from_top(CGROUP_MOUNT_PATH);
	nftw(cgroup_workdir, nftwfunc, WALK_FD_LIMIT, FTW_DEPTH | FTW_MOUNT);
}

int create_and_get_cgroup(const char *path)
{
	char cgroup_path[PATH_MAX + 1];
	int fd;

	format_cgroup_path(cgroup_path, path);
	if (mkdir(cgroup_path, 0777) && errno != EEXIST) {
		log_err("mkdiring cgroup %s .. %s", path, cgroup_path);
		return -1;
	}

	fd = open(cgroup_path, O_RDONLY);
	if (fd < 0) {
		log_err("Opening Cgroup");
		return -1;
	}

	return fd;
}

unsigned long long get_cgroup_id(const char *path)
{
	int dirfd, err, flags, mount_id, fhsize;
	union {
		unsigned long long cgid;
		unsigned char raw_bytes[8];
	} id;
	char cgroup_workdir[PATH_MAX + 1];
	struct file_handle *fhp, *fhp2;
	unsigned long long ret = 0;

	format_cgroup_path(cgroup_workdir, path);

	dirfd = AT_FDCWD;
	flags = 0;
	fhsize = sizeof(*fhp);
	fhp = calloc(1, fhsize);
	if (!fhp) {
		log_err("calloc");
		return 0;
	}
	err = name_to_handle_at(dirfd, cgroup_workdir, fhp, &mount_id, flags);
	if (err >= 0 || fhp->handle_bytes != 8) {
		log_err("name_to_handle_at");
		goto free_mem;
	}

	fhsize = sizeof(struct file_handle) + fhp->handle_bytes;
	fhp2 = realloc(fhp, fhsize);
	if (!fhp2) {
		log_err("realloc");
		goto free_mem;
	}
	err = name_to_handle_at(dirfd, cgroup_workdir, fhp2, &mount_id, flags);
	fhp = fhp2;
	if (err < 0) {
		log_err("name_to_handle_at");
		goto free_mem;
	}

	memcpy(id.raw_bytes, fhp->f_handle, 8);
	ret = id.cgid;

free_mem:
	free(fhp);
	return ret;
}
