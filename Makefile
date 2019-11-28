# LLC = llc
# CLANG = clang



MODULES := adaptor bpf launcher
LIBVTL_DIR := api
ORCHESTRATOR := orchestrator
TESTS = tests

MODULES_CLEAN = $(addsuffix _clean, $(MODULES))
LIBVTL_CLEAN = $(addsuffix _clean, $(LIBVTL_DIR ))
ORCHESTRATOR_CLEAN = $(addsuffix _clean, $(ORCHESTRATOR))
TESTS_CLEAN = $(addsuffix _clean, $(TESTS))

VTL_CLEAN = $(LIBVTL_CLEAN) $(TESTS_CLEAN) $(ORCHESTRATOR_CLEAN) $(MODULES_CLEAN)  



LIBBPF_DIR = libbpf/src/

OBJECT_LIBBPF = $(LIBBPF_DIR)/libbpf.a

all: dependencies build
	@echo "Build finished."

.PHONY: clean force dependencies

$(VTL_CLEAN):
	$(MAKE) -C $(subst _clean,,$@) clean


clean: $(VTL_CLEAN)


# Compilation de la bibliothèque statique libbpf
$(OBJECT_LIBBPF):
	@if [ ! -d $(LIBBPF_DIR) ]; then \
		echo "Error: Need libbpf submodule"; \
		echo "May need to run git submodule update --init"; \
		exit 1; \
	else \
		cd $(LIBBPF_DIR) && $(MAKE) all; \
		mkdir -p build; DESTDIR=build $(MAKE) install_headers; \
	fi

libbpf: $(OBJECT_LIBBPF)

dependencies: libbpf


$(MODULES) $(ORCHESTRATOR): force
	$(MAKE) -C $@ 

build-modules: $(MODULES)
	@echo "Build modules finished."


$(LIBVTL_DIR): force
	$(MAKE) -C $@ 

build-libvtl: $(LIBVTL_DIR)
	@echo "Build libvtl finished."

build-orchestrator: $(ORCHESTRATOR)
	@echo "Build orchestrator finished."

$(TESTS): force
	$(MAKE) -C $@

build-tests: $(TESTS)
	@echo "Build tests finished."


build: build-modules build-libvtl build-orchestrator build-tests


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








