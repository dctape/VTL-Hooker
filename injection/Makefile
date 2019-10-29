
KERN_TARGETS  := injection_kern
USER_TARGETS := injection #TODO: rename it to injection_user ?

LIBBPF_DIR = ../libbpf/src/
COMMON_DIR = ../common/

RAW_SOCK_DIR = raw_sock

all: make-rawsock

make-rawsock: 
	make -C $(RAW_SOCK_DIR)

include $(COMMON_DIR)/common.mk

RAW_SOCK_OBJ = $(RAW_SOCK_DIR)/raw_sock.o
USER_DEPS := $(RAW_SOCK_OBJ)
