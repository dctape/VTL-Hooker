

KERN_TARGETS := redirector_kern_1
USER_TARGETS := hooker_1

LIBBPF_DIR = ../libbpf/src/
COMMON_DIR = ../common/
LIB_DIR = ../lib

# DEPS_DIR = ./ => Boucle infinie

## sub-make for user dependencies

include dependencies.mk
include $(COMMON_DIR)/common.mk

LIBS += -lpthread

ADAPTER_OBJ = adapter.o
UDP_OBJ = udp.o

USER_DEPS := $(ADAPTER_OBJ)
USER_DEPS += $(UDP_OBJ)

KERN_DEPS = $(LIB_DIR)/maps.h

# all: $(ADAPTER_OBJ) $(UDP_OBJ)

# $(ADAPTER_OBJ): adapter.c $(LIB_DIR)/config.h
# 	$(CC) $(CFLAGS) -o $@ -c $<

# $(UDP_OBJ): udp.c $(LIB_DIR)/config.h
# 	$(CC) $(CFLAGS) -o $@ -c $<