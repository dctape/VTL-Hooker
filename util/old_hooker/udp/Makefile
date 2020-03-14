
UDP_OBJ = udp.o

LIB_DIR = ../../lib

CC := gcc
CFLAGS := -g -Wall

all: $(UDP_OBJ)

.PHONY: clean

clean:
	rm -f $(UDP_OBJ)


$(UDP_OBJ): udp.c udp.h $(LIB_DIR)/config.h
	$(CC) $(CFLAGS) -o $@ -c $<