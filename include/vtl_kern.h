/**
 *  header file for objects to include in bpf_program
 *  a big probabilty of duplication (see bpf.h)
 *  Compulsory refactoring for this file.
 **/ 

#include <stdint.h>

//TODO: Faire cette définition dans un fichier config ou util ?.


/* En-tête de paquet vtl */
typedef struct vtlhdr vtlhdr_t;
struct vtlhdr
{

        uint16_t checksum;
};

#define IPPROTO_VTL           0xc8 //Nombre arbitraire...