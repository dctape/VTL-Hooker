
OBJ := raw_sock.o

LIB_DIR = ../../lib

CC := gcc
CFLAGS := -g -Wall

all: $(OBJ)

.PHONY: clean

clean:
	rm -f $(OBJ)


$(OBJ): raw_sock.c raw_sock.h $(LIB_DIR)/vtl_util.h
	$(CC) $(CFLAGS) -o $@ -c $<