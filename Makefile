ROOT_DIR = .

BIN_DIR = $(ROOT_DIR)/bin
SRC_DIR = $(ROOT_DIR)/src
LIBTOOLS = $(ROOT_DIR)/lib
BPFPROG_DIR = $(ROOT_DIR)/src/bpf
LIBBPF_DIR = $(ROOT_DIR)/lib/libbpf/src/


MODULES := $(SRC_DIR)/api
MODULES += $(SRC_DIR)/adaptor
MODULES += $(SRC_DIR)/common
MODULES += $(SRC_DIR)/launcher
MODULES += $(SRC_DIR)/dashboard

BIN_CLEAN = $(addsuffix _clean, $(BIN_DIR))
MODULES_CLEAN = $(addsuffix _clean, $(MODULES))
LIBTOOLS_CLEAN = $(addsuffix _clean, $(LIBTOOLS))
BPFPROG_CLEAN = $(addsuffix _clean, $(BPFPROG_DIR))

STATIC_LIBVTL = $(BIN_DIR)/libvtl.a

LIBVTL_OBJS := $(SRC_DIR)/api/*.o
LIBVTL_OBJS += $(SRC_DIR)/adaptor/*.o
LIBVTL_OBJS += $(SRC_DIR)/common/*.o
LIBVTL_OBJS += $(SRC_DIR)/launcher/*.o

VTL_DASHBOARD = $(BIN_DIR)/vtl-dashboard


CC := gcc
CFLAGS += -g -Wall -Wextra -Wpedantic \
          -Wformat=2 -Wno-unused-parameter -Wshadow \
          -Wwrite-strings -Wstrict-prototypes -Wold-style-definition \
          -Wredundant-decls -Wnested-externs -Wmissing-include-dirs 
CFLAGS += -Wnull-dereference -Wjump-misses-init -Wlogical-op
CFLAGS += -O2
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/ -g
CFLAGS += -I$(ROOT_DIR)/src/headers/

ARFLAGS = rcs
LDFLAGS ?= -L$(LIBBPF_DIR) 

LIBS := -l:libbpf.a -lelf 
LIBS += -lpcap -lpthread
LIBS += -lcurses #pour le dashboard

all: build
	@echo "Build finished."

.PHONY: clean 
clean: clean-bin clean-modules clean-bpfprog clean-libtools
	
build: build-libtools build-bpfprog build-modules

build-libtools: $(LIBTOOLS)
	@echo "Build libtools finished."

build-bpfprog: $(BPFPROG_DIR)
	@echo "Build bpf programs finished."

build-modules: $(MODULES) build-libvtl build-dashboard
	@echo "Build vtl modules finished."

build-libvtl: $(STATIC_LIBVTL)
	@echo "Build static libvtl finished."

build-dashboard: $(VTL_DASHBOARD)
	@echo "Build vtl-dashboard finished."


clean-bin: $(BIN_CLEAN)
	@echo "Clean bin finished."

clean-modules: $(MODULES_CLEAN)
	@echo "Clean modules finished."

clean-bpfprog: $(BPFPROG_CLEAN)
	@echo "Clean bpf programs finished."

clean-libtools: $(LIBTOOLS_CLEAN)
	@echo "Clean libtools finished."


$(LIBTOOLS) $(BPFPROG_DIR) $(MODULES): force
	$(MAKE) -C $@

$(STATIC_LIBVTL): $(LIBVTL_OBJS)
	$(AR) $(ARFLAGS) $@ $?

$(VTL_DASHBOARD): $(SRC_DIR)/dashboard/dashboard.o $(LIBVTL_OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $(LIBVTL_OBJS) $< $(LIBS)

$(LIBTOOLS_CLEAN) $(BPFPROG_CLEAN) $(MODULES_CLEAN):
	$(MAKE) -C $(subst _clean,,$@) clean

$(BIN_CLEAN):
	$(RM) $(STATIC_LIBVTL) $(VTL_DASHBOARD)

force :;

# llvm-check: $(CLANG) $(LLC)
# 	@for TOOL in $^ ; do \
# 		if [ ! $$(command -v $${TOOL} 2>/dev/null) ]; then \
# 			echo "*** ERROR: Cannot find tool $${TOOL}" ;\
# 			exit 1; \
# 		else true; fi; \
# 	done


## llvm-check : quelques vérification au niveau du compilateur llvm
# precheck: llvm-check
# 	@echo "precheck finished."








