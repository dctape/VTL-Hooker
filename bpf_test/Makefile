ROOT_DIR = .

USER_TARGETS := shared_map
USER_TARGETS += xdp_ack
USER_TARGETS += op_bit
USER_TARGETS += libbpf_ex
USER_TARGETS += tail_call

USER_OBJS = ${USER_TARGETS:=.o}

BPFPROG_DIR = $(ROOT_DIR)/bpf
LIBBPF_DIR = $(ROOT_DIR)/lib/libbpf/src/

DEP_DIR = deps

DEPS := $(patsubst %,$(DEP_DIR)/%.d,$(basename $(USER_OBJS)))

# compilers (at least gcc and clang) don't create the subdirectories automatically
$(shell mkdir -p $(dir $(DEPS)) >/dev/null)

CC := gcc
CFLAGS += -g -Wall -Wextra -Wpedantic \
          -Wformat=2 -Wno-unused-parameter -Wshadow \
          -Wwrite-strings -Wstrict-prototypes -Wold-style-definition \
          -Wredundant-decls -Wnested-externs -Wmissing-include-dirs 
CFLAGS += -Wnull-dereference -Wjump-misses-init -Wlogical-op
CFLAGS += -O2
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/ -g
CFLAGS += -I$(ROOT_DIR)/headers/

# flags required for dependency generation; passed to compilers
DEPFLAGS = -MT $@ -MD -MP -MF $(DEP_DIR)/$*.Td

LDFLAGS ?= -L$(LIBBPF_DIR) 

LIBS = -l:libbpf.a -lelf

all: build-bpfprog $(USER_TARGETS)


build-bpfprog: $(BPFPROG_DIR)
	@echo "Build bpf programs finished."


$(BPFPROG_DIR) : force
	$(MAKE) -C $@

$(USER_TARGETS): %: %.c $(DEP_DIR)/%.d
	$(CC) $(DEPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $< $(LIBS)
	mv -f $(DEP_DIR)/$*.Td $(DEP_DIR)/$*.d


force :;

.PRECIOUS: $(DEP_DIR)/%.d
$(DEP_DIR)/%.d: ;

-include $(DEPS)