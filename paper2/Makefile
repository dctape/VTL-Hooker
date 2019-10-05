# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)


KERN_TARGETS  := af_xdp_kern
USER_TARGETS := af_xdp_user

LIBBPF_DIR = ../libbpf/src/

#Compilation avec libbpf kernel source :
# cela semble ne pas marcher;
# <bpf/bpf.h> manquant
#LIBBPF_DIR = /data/kernel/tools/lib/bpf 
COMMON_DIR = ../common/

include $(COMMON_DIR)/common.mk
# Intéressant car permet d'ajouter les bibliothèques 
# comme l'on veut.
LIBS += -lpthread
