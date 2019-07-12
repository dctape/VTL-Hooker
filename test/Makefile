
TEST := tcp-server
TEST += tcp-client
TEST += client-chat
TEST += server-chat

CC = gcc

CFLAGS := -no-pie -g -O2 -Wall

all: $(TEST)


$(TEST): %: %.o 
	$(CC) $(CFLAGS) $+ -o '$@'