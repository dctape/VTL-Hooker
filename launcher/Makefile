
OBJS := launcher.o

CC := gcc
CFLAGS := -g -Wall -Wextra
CFLAGS += -Wnull-dereference -Wjump-misses-init

LIBBPF_DIR = ../libbpf/src/
CFLAGS += -I$(LIBBPF_DIR)/build/usr/include/  -I../headers

# TODO : améliorer cette partie
# TODO: Do we need to make libbpf from this make file too?
all: $(OBJS)

.PHONY: clean

clean:
	rm -f $(OBJS)

%.o: %.c %.h
	$(CC) $(CFLAGS) -c -o $@ $<