# SPDX-License-Identifier: (GPL-2.0)

TARGETS := params
TARGETS += util_libbpf
TARGETS += util_user_maps
TARGETS += cgroup_helpers
TARGETS += sock_user_helpers
TARGETS += tc_user_helpers
TARGETS += xdp_user_helpers
TARGETS += xsk_user_helpers

CC := gcc
CFLAGS := -g -Wall

LIBBPF_DIR = ../libbpf/src/
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/  -I../headers

# TODO : améliorer cette partie
# TODO: Do we need to make libbpf from this make file too?
all: $(TARGETS)

.PHONY: clean

clean:
	rm -f *.o

%.o: %.c %.h
	$(CC) $(CFLAGS) -c -o $@ $<


#TODO: add common_libbpf.h ?
# common_user_bpf_xdp.o: common_user_bpf_xdp.c common_libbpf.h common_user_bpf_xdp.h 	
# 	$(CC) $(CFLAGS) -c -o $@ $< 
#common_user_bpf_socket.o: common_user_bpf_socket.c common_libbpf.h common_user_bpf_socket.h



