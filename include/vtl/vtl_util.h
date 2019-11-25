
#ifndef __VTL_UTIL_H
#define __VTL_UTIL_H


#include <stdint.h>

#define IPPROTO_VTL           200 //Nombre arbitraire...
#define VTL_HDRLEN            20 //Nombre arbitraire....
/* En-tête de paquet vtl */
typedef struct vtl_header vtlhdr_t;
struct vtl_header {

	uint16_t checksum;
};

#endif /* __VTL_UTIL_H */