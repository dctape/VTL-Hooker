
OBJS := api.o

ADAPTOR_DIR = ../adaptor
COMMON_DIR = ../common
INCLUDE_DIR = ../include

CC := gcc
CFLAGS := -g -Wall -Wextra
CFLAGS += -Wnull-dereference -Wjump-misses-init

## Pour bpf/xsk...
LIBBPF_DIR = ../libbpf/src/
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/  -I../headers

#CFLAGS += -I../headers

DEPS_H := $(ADAPTOR_DIR)/adaptor_receive.h
DEPS_H += $(ADAPTOR_DIR)/adaptor_send.c
DEPS_H +=$(INCLUDE_DIR)/vtl/vtl_macros.h 
DEPS_H += $(INCLUDE_DIR)/vtl/vtl_structures.h 
DEPS_H += $(INCLUDE_DIR)/vtl/vtl_util.h
DEPS_H += $(COMMON_DIR)/util.h

# TODO : améliorer cette partie
# TODO: Do we need to make libbpf from this make file too?
all: $(OBJS)

.PHONY: clean

clean:
	rm -f $(OBJS)

$(OBJS): %.o: %.c %.h $(DEPS_H)
	$(CC) $(CFLAGS) -c -o $@ $<