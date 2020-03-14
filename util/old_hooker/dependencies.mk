ADAPTER_OBJ = adapter.o
UDP_OBJ = udp.o

LIB_DIR = ../lib
CC := gcc

CFLAGS := -g -Wall
LIBBPF_DIR = ../libbpf/src/
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/  -I../headers
# add other options when necessary


# USER_DEPS := $(ADAPTER_OBJ)
# USER_DEPS += $(UDP_OBJ)

all: $(ADAPTER_OBJ) $(UDP_OBJ)

$(ADAPTER_OBJ): adapter.c adapter.h $(LIB_DIR)/config.h
	$(CC) $(CFLAGS) -o $@ -c $<

$(UDP_OBJ): udp.c udp.h $(LIB_DIR)/config.h
	$(CC) $(CFLAGS) -o $@ -c $<