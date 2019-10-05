# SPDX-License-Identifier: (GPL-2.0)
CC := gcc

# TODO : améliorer cette partie
all: common_params.o \ 
     common_libbpf.o \
     common_user_bpf_xdp.o \
     common_user_bpf_xsk.o \
     common_user_cgroup.o

CFLAGS := -g -Wall

LIBBPF_DIR = ../libbpf/src/
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/  -I../headers
# TODO: Do we need to make libbpf from this make file too?

common_params.o: common_params.c common_params.h
	$(CC) $(CFLAGS) -c -o $@ $<

common_libbpf.o: common_libbpf.c common_libbpf.h
	$(CC) $(CFLAGS) -c -o $@ $<

## TODO: modify it
common_user_bpf_xdp.o: common_user_bpf_xdp.c common_libbpf.h common_user_bpf_xdp.h 	
	$(CC) $(CFLAGS) -c -o $@ $< 

## add common_libbpf.h ?
common_user_bpf_xsk.o: common_user_bpf_xsk.c common_user_bpf_xsk.h 	
	$(CC) $(CFLAGS) -c -o $@ $< 

common_user_cgroup.o: common_user_cgroup.c common_user_cgroup.h 	
	$(CC) $(CFLAGS) -c -o $@ $< 

.PHONY: clean

clean:
	rm -f *.o
