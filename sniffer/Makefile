
CC = gcc
CFLAGS = -g -Wall
LDFLAGS = -lpcap

TARGET = sniffer

all: $(TARGET)

.PHONY: clean

clean:
	rm -rf $(TARGET)

$(TARGET): sniffer.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)