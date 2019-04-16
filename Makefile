CFLAGS=-std=gnu11 -O2 -Wall -Werror
PROGRAMS=tcp-server test_cgroup

all: $(PROGRAMS)

tcp-server: tcp-server.o
	$(CC) $+ -o '$@' 

test_cgroup: test_cgroup.o common.o cgroup_helpers.o
	$(CC) $+ -o '$@' -lbcc

clean:
	rm --force --verbose -- $(PROGRAMS) *.o

.PHONY: all clean
