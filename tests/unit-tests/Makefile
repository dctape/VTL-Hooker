ROOT_DIR = ../../

TARGETS := test_tc_helpers
TARGETS += test_xdp_helpers
TARGETS += test_adaptor
TARGETS += test_util
# TARGETS += test_api


OBJ_DIR = objs
DEP_DIR = deps

API_DIR = $(ROOT_DIR)/src/api
ADAPTOR_DIR = $(ROOT_DIR)/src/adaptor
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
CFLAGS += -I$(ROOT_DIR)/include
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/ -g
CFLAGS += -I$(ROOT_DIR)/src/headers/
CFLAGS += -I$(ROOT_DIR)/src

# flags required for dependency generation; passed to compilers
DEPFLAGS = -MT $@ -MD -MP -MF $(DEP_DIR)/$*.Td

COMMON_OBJS := $(COMMON_DIR)/util.o
COMMON_OBJS += $(COMMON_DIR)/tc_user_helpers.o
COMMON_OBJS += $(COMMON_DIR)/xdp_user_helpers.o
COMMON_OBJS += $(COMMON_DIR)/xsk_user_helpers.o

API_OBJ := $(API_DIR)/api.o
ADAPTOR_OBJS := $(ADAPTOR_DIR)/adaptor_receive.o
ADAPTOR_OBJS += $(ADAPTOR_DIR)/adaptor_send.o

LDFLAGS ?= -L$(LIBBPF_DIR) 

LIBS = -l:libbpf.a -lelf

all: $(TARGETS)

$(TARGETS): %: %.c $(COMMON_OBJS) $(API_OBJ) $(ADAPTOR_OBJS) $(DEP_DIR)/%.d
	$(CC) $(DEPFLAGS) $(CFLAGS) $(LDFLAGS) -o $@ $(COMMON_OBJS) $(API_OBJ) $(ADAPTOR_OBJS) $< $(LIBS)
	mv -f $(DEP_DIR)/$*.Td $(DEP_DIR)/$*.d

.PHONY: clean
clean:
	$(RM) -r $(TARGETS) $(OBJ_DIR) $(DEP_DIR)

.PRECIOUS: $(DEP_DIR)/%.d
$(DEP_DIR)/%.d: ;

-include $(DEPS)