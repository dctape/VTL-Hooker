
OBJS := api.o

ADAPTOR_DIR = ../adaptor
COMMON_DIR = ../common
INCLUDE_DIR = ../include
API_DIR = .

LIBVTL_OBJS := api.o
LIBVTL_OBJS += $(ADAPTOR_DIR)/adaptor_receive.o
LIBVTL_OBJS += $(ADAPTOR_DIR)/adaptor_send.o
LIBVTL_OBJS += $(COMMON_DIR)/util.o

STATIC_LIBVTL = $(API_DIR)/libvtl.a

AR = ar

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
all: $(OBJS) $(STATIC_LIBVTL)

.PHONY: clean

clean:	
	rm -f $(STATIC_LIBVTL)
	rm -f $(OBJS)

$(OBJS): %.o: %.c %.h $(DEPS_H)
	$(CC) $(CFLAGS) -c -o $@ $<

$(STATIC_LIBVTL): $(LIBVTL_OBJS)
	$(AR) rcs $@ $