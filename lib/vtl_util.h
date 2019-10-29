
#ifndef __VTL_UTIL_H
#define __VTL_UTIL_H


#include <stdint.h>

#define IPPROTO_VTL           200 //Nombre arbitraire...
#define VTL_HDRLEN            20 //Nombre arbitraire....

struct vtlhdr {

	uint16_t checksum;
}; 

#endif /* __VTL_UTIL_H */