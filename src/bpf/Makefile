ROOT_DIR = ../../
#TODO: add hooker bpf files
BPF_TARGETS := bpf_tc.o
BPF_TARGETS += bpf_xdp.o
BPF_TARGETS += bpf_arqin.o
BPF_TARGETS += bpf_hooker.o

INCLUDE_BPF = include
INCLUDE_VTL = $(ROOT_DIR)/include/vtl

LLC = llc
CLANG = clang


CFLAGS ?= -I./$(INCLUDE_BPF)
## A cause de xsk socket => include/vtl
## TODO: Briser cette dépendance.
#CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/ -I../headers

EXTRA_DEPS := $(INCLUDE_VTL)/vtl_macros.h

all: $(BPF_TARGETS)

.PHONY: clean $(CLANG) $(LLC)

clean:
	rm -f $(BPF_TARGETS)
	rm -f *.ll
	rm -f *~


$(BPF_TARGETS): %.o: %.c  Makefile $(EXTRA_DEPS) 
	$(CLANG) -S \
	    -target bpf \
	    -D __BPF_TRACING__ \
	    $(CFLAGS) \
	    -Wall \
	    -Wno-unused-value \
	    -Wno-pointer-sign \
	    -Wno-compare-distinct-pointer-types \
	    -Werror \
	    -O2 -emit-llvm -c -g -o ${@:.o=.ll} $<
	$(LLC) -march=bpf -filetype=obj -o $@ ${@:.o=.ll}