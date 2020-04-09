ROOT_DIR = ../../

TARGETS := capture
TARGETS += cpy_capture

OBJS = ${TARGETS:=.o}

CLEAN_FILE = lion.jpg

ADAPTOR_DIR = $(ROOT_DIR)/src/adaptor/
COMMON_DIR = $(ROOT_DIR)/src/common/
LIBBPF_DIR = $(ROOT_DIR)/lib/libbpf/src/

DEP_DIR = deps
DEPS := $(patsubst %,$(DEP_DIR)/%.d,$(basename $(OBJS)))
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

#COMMON_OBJS := $(COMMON_DIR)/util.o
#COMMON_OBJS += $(COMMON_DIR)/tc_user_helpers.o
COMMON_OBJS := $(COMMON_DIR)/xdp_user_helpers.o
COMMON_OBJS += $(COMMON_DIR)/xsk_user_helpers.o

ADAPTOR_OBJS := $(ADAPTOR_DIR)/adaptor_receive.o

LDFLAGS ?= -L$(LIBBPF_DIR) 

LIBS := -l:libbpf.a -lelf
LIBS += -lpthread

all: $(TARGETS)

$(TARGETS): %: %.c $(COMMON_OBJS) $(ADAPTOR_OBJS) clean-lion $(DEP_DIR)/%.d
	$(CC) $(DEPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $(COMMON_OBJS) $(ADAPTOR_OBJS) $< $(LIBS)
	mv -f $(DEP_DIR)/$*.Td $(DEP_DIR)/$*.d

## hackish workaround
clean-lion:
	$(RM) $(CLEAN_FILE)

.PHONY: clean
clean:
	$(RM) -r $(TARGETS) $(DEP_DIR) $(CLEAN_FILE)

.PRECIOUS: $(DEP_DIR)/%.d
$(DEP_DIR)/%.d: ;

-include $(DEPS)