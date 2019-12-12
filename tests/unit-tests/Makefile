ROOT_DIR = ../../

TARGETS := test_tc_helpers
TARGETS += test_xdp_helpers


OBJ_DIR = objs
DEP_DIR = deps

COMMON_DIR = $(ROOT_DIR)/src/common/
LIBBPF_DIR = $(ROOT_DIR)/lib/libbpf/src/

OBJS = ${TARGETS:=.o}
SRC = ${TARGETS:=.c}
#DEPS = ${OBJS:.o=.d}
DEPS := $(patsubst %,$(DEP_DIR)/%.d,$(basename $(OBJS)))

$(shell mkdir -p $(dir $(OBJS)) >/dev/null)
$(shell mkdir -p $(dir $(DEPS)) >/dev/null)

CC := gcc
CFLAGS += -g -Wall -Wextra -Wpedantic \
          -Wformat=2 -Wno-unused-parameter -Wshadow \
          -Wwrite-strings -Wstrict-prototypes -Wold-style-definition \
          -Wredundant-decls -Wnested-externs -Wmissing-include-dirs 
CFLAGS += -Wnull-dereference -Wjump-misses-init -Wlogical-op
CFLAGS += -O2
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/ -g
CFLAGS += -I$(ROOT_DIR)/src/headers/
CFLAGS += -I$(ROOT_DIR)/src

# flags required for dependency generation; passed to compilers
DEPFLAGS = -MT $@ -MD -MP -MF $(DEP_DIR)/$*.Td

COMMON_OBJS := $(COMMON_DIR)/tc_user_helpers.o
COMMON_OBJS += $(COMMON_DIR)/xdp_user_helpers.o

LDFLAGS ?= -L$(LIBBPF_DIR) 

LIBS = -l:libbpf.a -lelf

all: $(TARGETS)

$(TARGETS): %: %.c $(COMMON_OBJS) $(DEP_DIR)/%.d
	$(CC) $(DEPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $(COMMON_OBJS) $< $(LIBS)
	mv -f $(DEP_DIR)/$*.Td $(DEP_DIR)/$*.d

.PHONY: clean
clean:
	$(RM) -r $(TARGETS) $(OBJ_DIR) $(DEP_DIR)

.PRECIOUS: $(DEP_DIR)/%.d
$(DEP_DIR)/%.d: ;

-include $(DEPS)