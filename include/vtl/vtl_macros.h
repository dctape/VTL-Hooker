
#ifndef __VTL_MACROS_H
#define __VTL_MACROS_H


#define IPPROTO_VTL           0xc8 //Nombre arbitraire...

/**
 *  vtl header length
 **/ 
#define VTL_HDRLEN            0x14//Nombre arbitraire....

/**
 * vtl error buffer size 
 **/ 
#define VTL_ERRBUF_SIZE       0x100 


//TODO: Is it necessary ?
#define IP4_HDRLEN            0x14 // IPv4 header length
#define VTL_DATA_SIZE         0x400// ideal size ? 1024 ? 16k ?

//TODO: rewrite in enums ?
#define VTL_MODE_IN                0x1
#define VTL_MODE_OUT               0x2
#define VTL_MODE_INOUT             0x3


#endif /* __VTL_MACROS_H */