
#ifndef __VTL_UTIL_H
#define __VTL_UTIL_H

#include <sys/types.h>        // needed for socket(), uint8_t, uint16_t, uint32_t


#define IPPROTO_VTL           200 //Nombre arbitraire...
#define VTL_HDRLEN            20 //Nombre arbitraire....

struct vtlhdr {

	uint16_t checksum;
}; 

#endif /* __VTL_UTIL_H */