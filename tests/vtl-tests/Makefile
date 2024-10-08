
# TARGETS := server-stream
# TARGETS += client-stream
# TARGETS += client_perf
TARGETS := server-aware
TARGETS += client-aware

OBJS = ${TARGETS:=.o}

RCV_FILES =  ./files-receiver

ROOT_DIR = ../..
LIBVTL_DIR = $(ROOT_DIR)/bin
LIBBPF_DIR = $(ROOT_DIR)/lib/libbpf/src/
DEP_DIR = deps

DEPS := $(patsubst %,$(DEP_DIR)/%.d,$(basename $(OBJS)))
$(shell mkdir -p $(dir $(DEPS)) >/dev/null)
DEPFLAGS = -MT $@ -MD -MP -MF $(DEP_DIR)/$*.Td

CC := gcc
CFLAGS += -g -Wall -Wextra -Wpedantic \
          -Wformat=2 -Wno-unused-parameter -Wshadow \
          -Wwrite-strings -Wstrict-prototypes -Wold-style-definition \
          -Wredundant-decls -Wnested-externs -Wmissing-include-dirs 
CFLAGS += -Wnull-dereference -Wjump-misses-init -Wlogical-op
CFLAGS += -O0
CFLAGS += -I$(ROOT_DIR)/include
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/ -g
CFLAGS += -I$(ROOT_DIR)/src/headers/

OBJECT_LIBVTL = $(LIBVTL_DIR)/libvtl.a

LDFLAGS = -L$(LIBVTL_DIR)
LDFLAGS += -L$(LIBBPF_DIR) 
LIBS  = -l:libvtl.a -l:libbpf.a -lelf -lpthread

all: $(TARGETS)

$(TARGETS): %: %.c $(OBJECT_LIBVTL) Makefile $(DEP_DIR)/%.d
	$(CC) $(DEPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@  $< $(LIBS)
	mv -f $(DEP_DIR)/$*.Td $(DEP_DIR)/$*.d

.PHONY: clean
clean:
	$(RM) -r $(TARGETS) $(DEP_DIR) $(RCV_FILES)/*

.PRECIOUS: $(DEP_DIR)/%.d
$(DEP_DIR)/%.d: ;

-include $(DEPS)
