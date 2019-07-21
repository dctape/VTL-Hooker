
UNIT_TEST := injection


CC = gcc

CFLAGS := -no-pie -g -O2 -Wall

all: $(UNIT_TEST)


$(UNIT_TEST): %: %.o 
	$(CC) $(CFLAGS) $+ -o '$@'