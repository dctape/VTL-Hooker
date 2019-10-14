
KERN_TARGETS  := injection_kern
USER_TARGETS := injection

LIBBPF_DIR = ../libbpf/src/

#Compilation avec libbpf kernel source :
# cela semble ne pas marcher;
# <bpf/bpf.h> manquant
#LIBBPF_DIR = /data/kernel/tools/lib/bpf 
COMMON_DIR = ../common/

include $(COMMON_DIR)/common.mk
# Intéressant car permet d'ajouter les bibliothèques 
# comme l'on veut.
CFLAGS += $(libnet-config --defines)
LIBS += -lnet