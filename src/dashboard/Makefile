BIN := dashboard
OBJS := ${BIN:=.o}

DEP_DIR = deps
COMMON_DIR = ../common

DEPS := $(patsubst %,$(DEP_DIR)/%.d,$(basename $(OBJS)))
# compilers (at least gcc and clang) don't create the subdirectories automatically
$(shell mkdir -p $(dir $(DEPS)) >/dev/null)

LIBS += -lcurses
include $(COMMON_DIR)/common.mk





