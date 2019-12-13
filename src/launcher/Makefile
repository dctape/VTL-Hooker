ROOT_DIR = ../..
OBJS := launcher.o

DEP_DIR = deps
LIBBPF_DIR = $(ROOT_DIR)/lib/libbpf/src

DEPS := $(patsubst %,$(DEP_DIR)/%.d,$(basename $(OBJS)))

# compilers (at least gcc and clang) don't create the subdirectories automatically
$(shell mkdir -p $(dir $(DEPS)) >/dev/null)

CC := gcc
CFLAGS += -g -Wall -Wextra -Wpedantic \
          -Wformat=2 -Wno-unused-parameter -Wshadow \
          -Wwrite-strings -Wstrict-prototypes -Wold-style-definition \
          -Wredundant-decls -Wnested-externs -Wmissing-include-dirs 
CFLAGS += -Wnull-dereference -Wjump-misses-init -Wlogical-op
CFLAGS += -O2

# Because of automatic dependency generation
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/ -g
CFLAGS += -I$(ROOT_DIR)/src/headers/

DEPFLAGS = -MT $@ -MD -MP -MF $(DEP_DIR)/$*.Td

all: $(OBJS)

.PHONY: clean
clean:
	$(RM) -f $(OBJS)
	$(RM) -r $(DEP_DIR)

$(OBJS):%.o: %.c $(DEP_DIR)/%.d Makefile
	$(CC) $(DEPFLAGS) $(CFLAGS) -c -o $@ $<
	mv -f $(DEP_DIR)/$*.Td $(DEP_DIR)/$*.d


.PRECIOUS: $(DEP_DIR)/%.d
$(DEP_DIR)/%.d: ;
-include $(DEPS)

