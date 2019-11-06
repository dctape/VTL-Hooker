
#TODO: add hooker bpf files
BPF_TARGETS := bpf_tc.o
BPF_TARGETS += bpf_xdp.o

INCLUDE = include

LLC ?= llc
CLANG ?= clang
CC ?= gcc

CFLAGS ?= -I./include

EXTRA_DEPS +=

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