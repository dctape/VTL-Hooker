ROOT_DIR = ../../

TARGETS := test_tc_helpers


OBJ_DIR = objs
DEP_DIR = deps

COMMON_DIR = $(ROOT_DIR)/src/common/
LIBBPF_DIR = $(ROOT_DIR)/lib/libbpf/src/

OBJS = ${TARGETS:=.o}
SRC = ${TARGETS:=.c}
#DEPS = ${OBJS:.o=.d}
DEPS := $(patsubst %,$(DEP_DIR)/%.d,$(basename $(SRC)))

$(shell mkdir -p $(dir $(OBJS)) >/dev/null)
$(shell mkdir -p $(dir $(DEPS)) >/dev/null)

CC := gcc
CFLAGS += -g -Wall -Wextra -Wpedantic \
          -Wformat=2 -Wno-unused-parameter -Wshadow \
          -Wwrite-strings -Wstrict-prototypes -Wold-style-definition \
          -Wredundant-decls -Wnested-externs -Wmissing-include-dirs 
CFLAGS += -Wnull-dereference -Wjump-misses-init -Wlogical-op
CFLAGS += -O2
CFLAGS += -I$(ROOT_DIR)/src/headers/
CFLAGS += -I$(ROOT_DIR)/src

# flags required for dependency generation; passed to compilers
DEPFLAGS = -MT $@ -MD -MP -MF $(DEP_DIR)/$*.Td

DEP_OBJS = $(COMMON_DIR)/tc_user_helpers.o



all: $(TARGETS)

$(TARGETS): %: %.c Makefile
	$(CC) $(DEPFLAGS) $(CFLAGS) $< -o $@ $(LIBS) $(DEP_OBJS)
	mv -f $(DEP_DIR)/$*.Td $(DEP_DIR)/$*.d

.PHONY: clean
clean:
	$(RM) -r $(TARGETS) $(OBJ_DIR) $(DEP_DIR)

.PRECIOUS: $(DEP_DIR)/%.d
$(DEP_DIR)/%.d: ;

-include $(DEPS)