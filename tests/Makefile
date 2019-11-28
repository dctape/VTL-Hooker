
USER_TARGETS := server
USER_TARGETS += client


LIBBPF_DIR = ../libbpf/src/
COMMON_DIR = ../common/

API_DIR = ../api
ADAPTOR_DIR = ../adaptor

EXTRA_DEPS := $(API_DIR)/api.h

## Pas la manière la plus obptimale pour inclure les 
## dépendances objets.
## Transformer les différents composants en bibliothèques ?
# DEPS_OBJS := $(API_DIR)/api.o
# DEPS_OBJS += $(ADAPTOR_DIR)/adaptor_receive.o
# DEPS_OBJS += $(ADAPTOR_DIR)/adaptor_send.o

include $(COMMON_DIR)/common.mk

LDFLAGS += -L$(API_DIR)
LIBS += -lvtl