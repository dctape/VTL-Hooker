
KERN_TARGETS := capture_kern
USER_TARGETS := capture

RECV_FILE := lion.jpg

LIBBPF_DIR = ../libbpf/src/

COMMON_DIR = ../common/

all: 

clean-file: 
	rm -rf $(RECV_FILE)

include $(COMMON_DIR)/common.mk

LIBS += -lpthread
