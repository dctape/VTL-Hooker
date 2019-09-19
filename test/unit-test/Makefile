
TARGETS := injection

KERN_OBJECTS := injection_tc_kern.o


BPFDIR = ../../bpf
LIBDIR = ../../lib
HOOKERDIR = ../../hooker
TOOLS_PATH = $(BPFDIR)/tools



KDIR ?= /lib/modules/$(shell uname -r)/source
ARCH := $(subst x86_64,x86,$(shell arch))

CC = gcc
CFLAGS := -no-pie -g -O2 -Wall
CFLAGS += -I./bpf/kernel-usr-include/
CFLAGS += -I$(TOOLS_PATH)/lib

LDFLAGS= -lelf

OBJECT_LOADBPF = $(BPFDIR)/bpf_load.o
OBJECT_BPFMANAGER = $(BPFDIR)/bpf-manager.o

OBJECTS := $(OBJECT_LOADBPF)  
OBJECTS += $(OBJECT_BPFMANAGER) 


LIBBPF = $(TOOLS_PATH)/lib/bpf/libbpf.a

LLC ?= llc
CLANG ?= clang

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
	-include $(BPFDIR)/asm_goto_workaround.h \
	-O2 -emit-llvm

EXTRA_CFLAGS=-Werror

all: $(TARGETS) $(KERN_OBJECTS)

#TODO : fix clean
clean:
	@find . -type f \
		\( -name '*~' \
		-o -name '*.ll' \
		-o -name '*.bc' \
		-o -name 'core' \) \
		-exec rm -vf '{}' \;
	rm -f $(KERN_OBJECTS)
	rm -f $(UNIT_BPF_TESTS)
#	rm -f $(KERN_OBJECTS)
#	rm -f $(USER_OBJECTS)
	make -C $(TOOLS_PATH)/lib/bpf clean

# Most xxx_user program still depend on old bpf_load.c
$(OBJECT_LOADBPF): $(BPFDIR)/bpf_load.c $(BPFDIR)/bpf_load.h
	$(CC) $(CFLAGS) -o $@ -c $<

$(OBJECT_BPFMANAGER): $(BPFDIR)/bpf-manager.c $(LIBDIR)/config.h
	$(CC) $(CFLAGS) -o $@ -c $< $(LIBBPF)


LIBBPF_SOURCES  = $(TOOLS_PATH)/lib/bpf/*.c


# New ELF-loaded avail in libbpf (in bpf/libbpf.c)
$(LIBBPF): $(LIBBPF_SOURCES) $(TOOLS_PATH)/lib/bpf/Makefile
	make -C $(TOOLS_PATH)/lib/bpf/ all





$(KERN_OBJECTS): %.o : %.c $(BPFDIR)/bpf_helpers.h $(LIBDIR)/config.h $(LIBDIR)/maps.h Makefile
	$(CLANG) $(CLANG_FLAGS) -c $< -o ${@:.o=.ll} 
	$(LLC) -march=bpf -mcpu=$(CPU) -filetype=obj -o $@ ${@:.o=.ll}

#Problème d'exécution
# Solution; installation de libtool ??
#ou problème d'édition des liens 
#$(UNIT_BPF_TESTS): %: %.o 
#	$(CC) $(libnet-config --defines) $(CFLAGS)  $+ -o '$@' -lnet

$(TARGETS): %: %.c $(OBJECTS) $(LIBBPF) Makefile $(BPFDIR)/bpf-manager.h
	$(CC) $(libnet-config --defines) $(CFLAGS) $(OBJECTS) $(LDFLAGS) -o $@ $<  $(LIBBPF) -lnet -lpthread