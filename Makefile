#
# Makefile for building eBPF programs
#  similar to kernel/samples/bpf/
#
# Still depend on a kernel source tree.
#

TARGETS := hooker1
TARGETS += hooker2


BPF_DIR = bpf
TOOLS_PATH = ./bpf/tools


# Generate file name-scheme based on TARGETS
KERN_SOURCES = ${TARGETS:=_kern.c}
USER_SOURCES = ${TARGETS:=_user.c}
KERN_OBJECTS = ${KERN_SOURCES:.c=.o}
USER_OBJECTS = ${USER_SOURCES:.c=.o}

KDIR ?= /lib/modules/$(shell uname -r)/source
ARCH := $(subst x86_64,x86,$(shell arch))


CFLAGS := -no-pie -g -O2 -Wall

# Local copy of include/linux/bpf.h kept under ./kernel-usr-include
#
CFLAGS += -I./bpf/kernel-usr-include/
##CFLAGS += -I$(KERNEL)/usr/include
#
# Interacting with libbpf
CFLAGS += -I$(TOOLS_PATH)/lib


LDFLAGS= -lelf

# Objects that xxx_user program is linked with:
#TODO : optimize this later...
OBJECT_LOADBPF = ./bpf/bpf_load.o
OBJECT_ADAPTER = adapter.o
OBJECT_BPFMANAGER = bpf-manager.o
OBJECT_UTIL = util.o
OBJECT_UDP = udp.o
OBJECTS := $(OBJECT_LOADBPF) 
OBJECTS += $(OBJECT_ADAPTER) 
OBJECTS += $(OBJECT_BPFMANAGER) 
OBJECTS += $(OBJECT_UTIL)
OBJECTS += $(OBJECT_UDP)


# The static libbpf library
# TODO : use libbpf shared 
LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a

LLC ?= llc
CLANG ?= clang

CC = gcc

NOSTDINC_FLAGS := -nostdinc -isystem $(shell $(CC) -print-file-name=include)

CLANG_FLAGS = -I. -I$(KDIR)/arch/$(ARCH)/include \
	-I$(KDIR)/arch/$(ARCH)/include/generated \
	-I$(KDIR)/include \
	-I$(KDIR)/arch/$(ARCH)/include/uapi \
	-I$(KDIR)/arch/$(ARCH)/include/generated/uapi \
	-I$(KDIR)/include/uapi \
	-I$(KDIR)/include/generated/uapi \
	-include $(KDIR)/include/linux/kconfig.h \
	-I$(KDIR)/tools/testing/selftests/bpf/ \
	-D__KERNEL__ -D__BPF_TRACING__ -Wno-unused-value -Wno-pointer-sign \
	-D__TARGET_ARCH_$(ARCH) -Wno-compare-distinct-pointer-types \
	-Wno-gnu-variable-sized-type-not-at-end \
	-Wno-address-of-packed-member -Wno-tautological-compare \
	-Wno-unknown-warning-option \
	-include $(BPF_DIR)/asm_goto_workaround.h \
	-O2 -emit-llvm

# TODO: can we remove(?) copy of uapi/linux/bpf.h stored here: ./tools/include/
# LINUXINCLUDE := -I./tools/include/
#
# bpf_helper.h need newer version of uapi/linux/bpf.h
# (as this git-repo use new devel kernel features)

EXTRA_CFLAGS=-Werror

all: $(TEST) dependencies $(TARGETS) $(KERN_OBJECTS)

.PHONY: dependencies clean verify_cmds verify_llvm_target_bpf $(CLANG) $(LLC)

#TODO : fix clean
clean:
	@find . -type f \
		\( -name '*~' \
		-o -name '*.ll' \
		-o -name '*.bc' \
		-o -name 'core' \) \
		-exec rm -vf '{}' \;
	rm -f $(OBJECTS)
	rm -f $(TARGETS)
	rm -f $(KERN_OBJECTS)
	rm -f $(USER_OBJECTS)
	make -C $(TOOLS_PATH)/lib/bpf clean


dependencies: verify_llvm_target_bpf linux-src-devel-headers

linux-src:
	@if ! test -d $(KERNEL)/; then \
		echo "ERROR: Need kernel source code to compile against" ;\
		echo "(Cannot open directory: $(KERNEL))" ;\
		exit 1; \
	else true; fi

linux-src-libbpf: linux-src
	@if ! test -d $(KERNEL)/tools/lib/bpf/; then \
		echo "WARNING: Compile against local kernel source code copy" ;\
		echo "       and specifically tools/lib/bpf/ "; \
	else true; fi

linux-src-devel-headers: linux-src-libbpf
	@if ! test -d $(KERNEL)/usr/include/ ; then \
		echo -n "WARNING: Need kernel source devel headers"; \
		echo    " likely need to run:"; \
		echo "       (in kernel source dir: $(KERNEL))"; \
		echo -e "\n  make headers_install\n"; \
		true ; \
	else true; fi

verify_cmds: $(CLANG) $(LLC)
	@for TOOL in $^ ; do \
		if ! (which -- "$${TOOL}" > /dev/null 2>&1); then \
			echo "*** ERROR: Cannot find LLVM tool $${TOOL}" ;\
			exit 1; \
		else true; fi; \
	done

verify_llvm_target_bpf: verify_cmds
	@if ! (${LLC} -march=bpf -mattr=help > /dev/null 2>&1); then \
		echo "*** ERROR: LLVM (${LLC}) does not support 'bpf' target" ;\
		echo "   NOTICE: LLVM version >= 3.7.1 required" ;\
		exit 2; \
	else true; fi

# Most xxx_user program still depend on old bpf_load.c
$(OBJECT_LOADBPF): ./bpf/bpf_load.c ./bpf/bpf_load.h
	$(CC) $(CFLAGS) -o $@ -c $<

LIBBPF_SOURCES  = $(TOOLS_PATH)/lib/bpf/*.c


# New ELF-loaded avail in libbpf (in bpf/libbpf.c)
$(LIBBPF): $(LIBBPF_SOURCES) $(TOOLS_PATH)/lib/bpf/Makefile
	make -C $(TOOLS_PATH)/lib/bpf/ all

#TODO: optimize this later
$(OBJECT_ADAPTER): adapter.c config.h
	$(CC) $(CFLAGS) -o $@ -c $<

$(OBJECT_BPFMANAGER): bpf-manager.c config.h
	$(CC) $(CFLAGS) -o $@ -c $< $(LIBBPF)

$(OBJECT_UTIL): ./lib/util.c
	$(CC) $(CFLAGS) -o $@ -c $<

$(OBJECT_UDP): udp.c config.h
	$(CC) $(CFLAGS) -o $@ -c $<

#LPTHREAD = -lpthread
##LIBBPF += $(TOOLS_PATH)/lib/libbpf/src/*.o

# Compiling of eBPF restricted-C code with LLVM
#  clang option -S generated output file with suffix .ll
#   which is the non-binary LLVM assembly language format
#   (normally LLVM bitcode format .bc is generated)
#
# Use -Wno-address-of-packed-member as eBPF verifier enforces
# unaligned access checks where necessary
#

$(KERN_OBJECTS): %.o : %.c $(BPF_DIR)/bpf_helpers.h config.h ./lib/maps.h Makefile
	$(CLANG) $(CLANG_FLAGS) -c $< -o ${@:.o=.ll} 
	$(LLC) -march=bpf -mcpu=$(CPU) -filetype=obj -o $@ ${@:.o=.ll}


$(TARGETS): %: %_user.c $(OBJECTS) $(LIBBPF) Makefile $(BPF_DIR)/bpf_util.h
	$(CC) $(CFLAGS) $(OBJECTS) $(LDFLAGS) -o $@ $<  $(LIBBPF) -lpthread




