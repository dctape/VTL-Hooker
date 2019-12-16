ROOT_DIR = ../..
ADAPTOR_DIR = ../adaptor
LAUNCHER_DIR = ../launcher

OBJS := api.o

STATIC_LIBVTL = libvtl.a

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

ARFLAGS = rcs

LIBVTL_OBJS := $(OBJS)
LIBVTL_OBJS += $(ADAPTOR_DIR)/adaptor_receive.o
LIBVTL_OBJS += $(ADAPTOR_DIR)/adaptor_send.o
LIBVTL_OBJS += $(LAUNCHER_DIR)/launcher.o

all: $(OBJS) $(STATIC_LIBVTL)

.PHONY: clean
clean:
	$(RM) $(OBJS) $(STATIC_LIBVTL)
	$(RM) -r $(DEP_DIR)

$(OBJS):%.o: %.c $(DEP_DIR)/%.d Makefile
	$(CC) $(DEPFLAGS) $(CFLAGS) -c -o $@ $<
	mv -f $(DEP_DIR)/$*.Td $(DEP_DIR)/$*.d

$(STATIC_LIBVTL): $(LIBVTL_OBJS)
	$(AR) $(ARFLAGS) $@ $?

.PRECIOUS: $(DEP_DIR)/%.d
$(DEP_DIR)/%.d: ;
-include $(DEPS)