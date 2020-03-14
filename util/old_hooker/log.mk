# SPDX-License-Identifier: (GPL-2.0)$
CC := gcc$
$
# TODO : amM-CM-)liorer cette partie$
all: common_params.o \ $
     common_libbpf.o \$
     common_user_bpf_xdp.o \$
     common_user_bpf_xsk.o \$
     common_user_cgroup.o \$
     common_user_bpf_socket.o$
$
CFLAGS := -g -Wall$
$
LIBBPF_DIR = ../libbpf/src/$
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/  -I../headers$
# TODO: Do we need to make libbpf from this make file too?$
$
common_params.o: common_params.c common_params.h$
^I$(CC) $(CFLAGS) -c -o $@ $<$
$
common_libbpf.o: common_libbpf.c common_libbpf.h$
^I$(CC) $(CFLAGS) -c -o $@ $<$
$
## TODO: modify it$
common_user_bpf_xdp.o: common_user_bpf_xdp.c common_libbpf.h common_user_bpf_xdp.h ^I$
^I$(CC) $(CFLAGS) -c -o $@ $< $
$
## add common_libbpf.h ?$
common_user_bpf_xsk.o: common_user_bpf_xsk.c common_user_bpf_xsk.h ^I$
^I$(CC) $(CFLAGS) -c -o $@ $< $
$
common_user_cgroup.o: common_user_cgroup.c common_user_cgroup.h ^I$
^I$(CC) $(CFLAGS) -c -o $@ $< $
$
common_user_bpf_socket.o: common_user_bpf_socket.c common_libbpf.h common_user_bpf_socket.h^I$
^I$(CC) $(CFLAGS) -c -o $@ $<$
$
.PHONY: clean$
$
clean:$
^Irm -f *.o$
