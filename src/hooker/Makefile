

KERN_TARGETS := redirector_kern_1
USER_TARGETS := hooker_1

LIBBPF_DIR = ../libbpf/src/
COMMON_DIR = ../common/
LIB_DIR = ../lib

ADAPTER_DIR = ./adapter
UDP_DIR = ./udp


all: make-adapter make-udp

make-adapter:
	make -C $(ADAPTER_DIR)

make-udp:
	make -C $(UDP_DIR)


include $(COMMON_DIR)/common.mk

LIBS += -lpthread

ADAPTER_OBJ = $(ADAPTER_DIR)/adapter.o
UDP_OBJ = $(UDP_DIR)/udp.o

USER_DEPS := $(ADAPTER_OBJ)
USER_DEPS += $(UDP_OBJ)

KERN_DEPS = $(LIB_DIR)/maps.h

