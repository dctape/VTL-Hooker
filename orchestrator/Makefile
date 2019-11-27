
USER_TARGETS := orchestrator


LIBBPF_DIR = ../libbpf/src/
COMMON_DIR = ../common/
LAUNCHER_DIR = ../launcher

EXTRA_DEPS := $(LAUNCHER_DIR)/launcher.h

## Pas la manière la plus obptimale pour inclure les 
## dépendances objets.
## Transformer les différents composants en bibliothèques ?
DEPS_OBJS = $(LAUNCHER_DIR)/launcher.o

include $(COMMON_DIR)/common.mk

LIBS += -lpcap