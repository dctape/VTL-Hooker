ROOT_DIR = ..
#TODO: add hooker bpf files
BPF_TARGETS := tc_kern.o
BPF_TARGETS += xdp_kern.o
BPF_TARGETS += xdp_ack_kern.o

INCLUDE_BPF = include
#INCLUDE_VTL = $(ROOT_DIR)/include/vtl

LLC = llc
CLANG = clang


CFLAGS ?= -I./$(INCLUDE_BPF)
## A cause de xsk socket => include/vtl
## TODO: Briser cette dépendance.
#CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/ -I../headers

EXTRA_DEPS := 

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