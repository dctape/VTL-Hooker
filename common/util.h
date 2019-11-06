
#ifndef __UTIL_H
#define __UTIL_H

#include <stdint.h>

char *allocate_strmem (int len);
uint8_t *allocate_ustrmem (int len);
int *allocate_intmem (int len);
int *allocate_intmem (int len);
uint16_t checksum (uint16_t *addr, int len);


#endif /* __UTIL_H */