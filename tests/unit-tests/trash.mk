
TARGETS := test_tc_helpers
OBJS = ${TARGETS.o}

DEPFILES = ${OBJS:.o=.d}

ROOT_DIR = ../../

COMMON_DIR ?= $(ROOT_DIR)/common/
LIBBPF_DIR ?= $(ROOT_DIR)/libbpf/src/


CC := gcc
CFLAGS += -g -Wall -Wextra -Wpedantic \
          -Wformat=2 -Wno-unused-parameter -Wshadow \
          -Wwrite-strings -Wstrict-prototypes -Wold-style-definition \
          -Wredundant-decls -Wnested-externs -Wmissing-include-dirs 
CFLAGS += -Wnull-dereference -Wjump-misses-init -Wlogical-op
CFLAGS += -O2
CFLAGS += -I$(ROOT_DIR)/headers/

# LDFLAGS ?= -L$(LIBBPF_DIR)


# LIBS = -lpcap
# LIBS += -l:libbpf.a

DEPS_OBJS = $(COMMON_DIR)/tc_user_helpers.o


all: $(TARGETS)

$(TARGETS): %: %.c Makefile
        $(CC) $(CFLAGS) $< -o $@ $(LIBS) $(DEPS_OBJS)

$(TARGETS):
        $(CC)

%.dep.mk: %c
        $(CC) -M -MP -MT '$(<:.c=.o) $@' $< >$@

-include $(DEPFILES)