# SPDX-License-Identifier: (GPL-2.0)

OBJS := params.o
OBJS += util_libbpf.o
OBJS += util_user_maps.o
OBJS += cgroup_helpers.o
OBJS += sock_user_helpers.o
OBJS += tc_user_helpers.o
OBJS += xdp_user_helpers.o
OBJS += xsk_user_helpers.o

CC := gcc
CFLAGS := -g -Wall

LIBBPF_DIR = ../libbpf/src/
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/  -I../headers

# TODO : améliorer cette partie
# TODO: Do we need to make libbpf from this make file too?
all: $(OBJS)

.PHONY: clean

clean:
	rm -f $(OBJS)

%.o: %.c %.h
	$(CC) $(CFLAGS) -c -o $@ $<


#TODO: add common_libbpf.h ?
# common_user_bpf_xdp.o: common_user_bpf_xdp.c common_libbpf.h common_user_bpf_xdp.h 	
# 	$(CC) $(CFLAGS) -c -o $@ $< 
#common_user_bpf_socket.o: common_user_bpf_socket.c common_libbpf.h common_user_bpf_socket.h



