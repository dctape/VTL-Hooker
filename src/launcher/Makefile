
OBJS := launcher.o

CC ?= gcc
CFLAGS := -g -Wall -Wextra
CFLAGS += -Wnull-dereference -Wjump-misses-init

LIBBPF_DIR = ../libbpf/src/
COMMON_DIR = ../common
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/  -I../headers

#TODO: use later a more dynamic way...
DEPS_H := $(COMMON_DIR)/tc_user_helpers.h 
DEPS_H += $(COMMON_DIR)/xdp_user_helpers.h

# TODO : améliorer cette partie
# TODO: Do we need to make libbpf from this make file too?
all: $(OBJS)

.PHONY: clean

clean:
	rm -f $(OBJS)

$(OBJS):%.o: %.c %.h Makefile $(DEPS_H)
	$(CC) $(CFLAGS) -c -o $@ $<

