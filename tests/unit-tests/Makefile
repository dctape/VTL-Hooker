
TARGET := unit-tests

CC := gcc
CFLAGS := -g -Wall -Wextra
CFLAGS += -Wnull-dereference -Wjump-misses-init


LIBS = -lpcap


all: $(TARGET)

$(TARGET): %: %.c Makefile
	$(CC) $(CFLAGS) $< -o $@ $(LIBS)