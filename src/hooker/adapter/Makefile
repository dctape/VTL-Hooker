
ADAPTER_OBJ = adapter.o

LIB_DIR = ../../lib

CC := gcc
CFLAGS := -g -Wall

all: $(ADAPTER_OBJ)

.PHONY: clean

clean:
	rm -f $(ADAPTER_OBJ)


$(ADAPTER_OBJ): adapter.c adapter.h $(LIB_DIR)/config.h
	$(CC) $(CFLAGS) -o $@ -c $<