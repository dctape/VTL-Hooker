
#OBJS := adaptor_receive.o
#OBJS += adaptor_send.o
RCV_OBJ = adaptor_receive.o
SND_OBJ = adaptor_send.o

COMMON_DIR = ../common
INCLUDE_DIR = ../include

CC ?= gcc
CFLAGS := -g -Wall -Wextra
CFLAGS += -Wnull-dereference -Wjump-misses-init

## Ajouter libbpf à cause de bpf/xsk.h
LIBBPF_DIR = ../libbpf/src/
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/  -I../headers
#CFLAGS += -I../headers

COMMON_DEPS_H := $(INCLUDE_DIR)/vtl/vtl_macros.h
COMMON_DEPS_H := $(INCLUDE_DIR)/vtl/vtl_structures.h

RCV_DEPS_H := $(COMMON_DIR)/xsk_user_helpers.h
SND_DEPS_H := $(COMMON_DIR)/util.h 

# TODO : améliorer cette partie
# TODO: Do we need to make libbpf from this make file too?
all: $(RCV_OBJ) $(SND_OBJ)

.PHONY: clean

clean:
	rm -f $(RCV_OBJ) $(SND_OBJ)

$(RCV_OBJ): %.o: %.c %.h Makefile $(RCV_DEPS_H) $(COMMON_DEPS_H)
	$(CC) $(CFLAGS) -c -o $@ $<

$(SND_OBJ): %.o: %.c %.h Makefile $(SND_DEPS_H) $(COMMON_DEPS_H)
	$(CC) $(CFLAGS) -c -o $@ $<